library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;
use dcnn.config.all;

entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16;  -- size of the address bus
        WREG : natural := 5;  --size of img width reg (max 28, 5 bits)   
        HREG: natural := 16 --for now since i don't know how big the FC stage img is
        );
    port (
        clk                 :   in  std_logic;
        reset               :   in  std_logic; -- to-do: OR all other resets with this.
        io_ready_in         :   in  std_logic;
        io_done_out         :   out std_logic;
        mem_data_in         :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out        :   out std_logic_vector(N - 1 downto 0);
        mem_addr_out        :   out std_logic_vector(M - 1 downto 0);
        mem_write_out       :   out std_logic; -- writes into memory
        mem_read_out        :   out std_logic; -- reads from memory
        filter_data_out     :   out std_logic_vector(N-1 downto 0);
        filter_ready_out    :   out std_logic;
        wind_en             :   out std_logic;
        wind_rst            :   out std_logic;
        wind_col_in         :   out wordarr_t(4 downto 0);
	    comp_unit_ready     :   out std_logic;
	    comp_unit_data1     :   out std_logic_vector(N-1 downto 0);
	    comp_unit_data2     :   out std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        fetch_nlayers,
        fetch_layer_info_1,
        fetch_layer_info_2,
        fetch_layer_info_3,
        fetch_layer_info_4,
        fetch_layer_info_5,
        fetch_layer_info_6,
        fetch_layer_info_7,
        init_filter_window_1,
        init_filter_window_2,
        init_image_cache_1,
        init_image_cache_2,
        postini_cache,
        preini_img_window,
        init_image_window,
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory,
        argmax_computation,
        write_classification,
        end_state
    );

    -- State signals
    signal current_state : state_type := fetch_nlayers;
    signal next_state : state_type := fetch_layer_info_1;
    signal actual_next_state : state_type := fetch_layer_info_1;

    -- General-purpose reset signal.
    signal gen_reset : std_logic := '0'; 

    -- Generic Counter
    signal cntr1_reset : std_logic := '0';
    signal cntr1_reset_new : std_logic := '0';
    signal cntr1_enable : std_logic := '1';
    signal cntr1_mode : std_logic := '0';
    signal cntr1_max_val : std_logic_vector(5 downto 0) := (others => '1');
    signal cntr1_max_reached : std_logic := 'Z';
    signal cntr1_data : std_logic_vector(5 downto 0) := (others => 'Z');

    -- Memory Addressing
    signal addr1_reset : std_logic := '0';
    signal addr1_enable : std_logic := '1';
    signal addr1_mode : std_logic := '0';
    signal addr1_max_reached : std_logic := 'Z';
    signal addr1_data : std_logic_vector(M-1 downto 0) := (others => 'Z');
    signal write_mem_to_fltr : std_logic := '0';
    signal mem_read, mem_write : std_logic;
    signal base_addr : std_logic_vector(M-1 downto 0) := x"0009";

    -- signal img_offset_addr: std_logic_vector(M-1 downto 0) := (others => 'Z');
    -- signal img_offset_rst: std_logic;
    -- signal img_offset_rst: std_logic;
    -- signal img_offset_rst: std_logic;
    

    -- Layer information signals
    signal nlayers_counter_enable : std_logic := '0';
    signal nlayers_load : std_logic := '0';
    signal nlayers_data_load : std_logic_vector(2 downto 0) := "000";
    signal nlayers_max_reached : std_logic := '0';
    signal nlayers_out : std_logic_vector(2 downto 0);

    signal layer_type_load : std_logic := '0';
    signal layer_type_data_load : std_logic_vector(1 downto 0) := "00";
    signal layer_type_out : std_logic_vector(1 downto 0);
    signal IsPoolLayer, IsConvLayer, IsFCLayer : std_logic;
    
    signal nflt_layer_enable : std_logic := '0';
    signal nflt_layer_load : std_logic := '0';
    signal nflt_layer_data_load : std_logic_vector(3 downto 0) := "0000";
    signal nflt_layer_max_reached : std_logic;
    signal nflt_layer_out : std_logic_vector(3 downto 0);

    signal flt_size_load : std_logic := '0';
    signal flt_size_data_load : std_logic_vector(2 downto 0) := "000";
    signal flt_size_out : std_logic_vector(2 downto 0);
    
    signal new_width_load : std_logic := '0';
    signal new_width_data_load : std_logic_vector(4 downto 0) := "00000";
    signal new_width_out : std_logic_vector(4 downto 0);

    signal new_size_squared_load : std_logic := '0';
    signal new_size_squared_data_load : std_logic_vector(15 downto 0) := (others => '0');
    signal new_size_squared_out : std_logic_vector(15 downto 0);
    
    signal layer_mem_size_load : std_logic := '0';
    signal layer_mem_size_data_load : std_logic_vector(15 downto 0) := (others => '0');
    signal layer_mem_size_out : std_logic_vector(15 downto 0);

    signal num_channels_enable : std_logic := '0';
    signal num_channels_load : std_logic := '0';
    signal num_channels_data_load : std_logic_vector(2 downto 0) := (others => '0');
    signal num_channels_max_reached : std_logic;
    signal num_channels_out : std_logic_vector(2 downto 0);
    
    signal img_width_load : std_logic := '0';
    signal img_width_data_load : std_logic_vector(4 downto 0) := (others => '0');
    signal img_width_out : std_logic_vector(4 downto 0);
    signal img_height_out : std_logic_vector(4 downto 0);
   

    
   

    --connected to window col counter (normal counter)
    signal wind_width_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache width counter
    signal wind_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal wind_width_count_rst : std_logic := '0';
    signal wind_width_count_en : std_logic := '0';
    signal wind_width_count_mode : std_logic := '0';
    signal wind_width_ended : std_logic := 'Z';
    signal wind_max_width: std_logic_vector(15 downto 0);

    ------ for image window ----------------
    -- signal wind_en: std_logic := '0';
    -- signal wind_rst : std_logic := '0';
    -- signal wind_col_in  : wordarr_t(4 downto 0) := (others => (others => '0'));
    -- signal wind_col_out : wordarr_t(24 downto 0) := (others => (others => 'Z'));
    
    
    ------------Signals for Cache----------------
    signal cache_height_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache height counter
    -- signal cache_height_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal cache_height_count_rst : std_logic := '0';
    signal cache_height_count_en : std_logic := '0';
    signal cache_height_count_mode : std_logic_vector(1 downto 0) := (others => '0');
    signal cache_height_ended : std_logic := 'Z';
    signal cache_height_1 : std_logic_vector(N-1 downto 0);
    signal max_height : std_logic_vector(15 downto 0);

    signal cache_width_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache width counter
    -- signal cache_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal cache_width_count_rst : std_logic := '0';
    signal cache_width_count_en : std_logic := '0';
    signal cache_width_count_mode : std_logic := '0';
    signal cache_width_ended : std_logic := 'Z';
    signal cache_width_1 : std_logic_vector(N-1 downto 0):= (others => '0');
    

    signal cache_data_in  : std_logic_vector(N - 1 downto 0) := (others => '0');
    signal cache_data_out   : wordarr_t(4 downto 0) := (others => (others => 'Z'));
    signal cache_out_sel    : std_logic_vector(N-1 downto 0) := (others => '0');--(cache_width_count+5); --make sure
    signal cache_load        : std_logic := '0';
    signal cache_rst : std_logic := '0';

    signal not_clk : std_logic := '0';
      
    ----ftc cntrl reg
    signal ftc_cntrl_reg_in: std_logic_vector(15 downto 0);
    signal ftc_cntrl_reg_out: std_logic_vector(15 downto 0);
    signal ftc_cntrl_reg_en: std_logic;
    signal ftc_cntrl_reg_rst: std_logic;
    --ftc cntrl reg in
    signal edged: std_logic;
    signal second_fetch: std_logic;
    signal begin_ftc: std_logic;
    signal ini_wind: std_logic;
    signal finish_wind_row : std_logic;
    --ftc cnrl reg out
    signal edged_o : std_logic;
    signal second_fetch_o : std_logic;
    signal cache_height_ended_o : std_logic;
    signal cache_width_ended_o : std_logic;
    signal wind_width_ended_o : std_logic;
    signal begin_ftc_o : std_logic;
    signal ini_wind_o: std_logic;
    signal finish_wind_row_o : std_logic;
     --for implementation optimization
     signal filter_tbt: std_logic; -- state signal
  

begin
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');
    filter_ready_out <= '1' when write_mem_to_fltr = '1' else '0';
    IsPoolLayer <= '1' when layer_type_out = "01" else '0';
    IsConvLayer <= '1' when layer_type_out = "00" else '0';
    IsFCLayer <= '1' when layer_type_out = "10" else '0';
    gen_reset <= reset;
    mem_read_out <= mem_read when reset = '0' else '0';
    mem_write_out <= mem_write when reset = '0' else '0';
    actual_next_state <= next_state when reset = '0' else fetch_nlayers;
    img_height_out <= img_width_out;
    not_clk <= "not"(clk);
    cache_width_1 <= (15 downto 5=>'0')&std_logic_vector(unsigned(img_width_out) - 1);
    -- cache_width_1(15 downto 5);
    -- cache_height_1(4 downto 0) <= std_logic_vector(unsigned(img_height_out) - 1);
    cache_height_1 <= (15 downto 5=>'0')&std_logic_vector(unsigned(img_height_out) - 1);
    --Three by Three filter
    filter_tbt<='1' when flt_size_out = std_logic_vector(to_signed(3, 3))
    else '0' ; 

    -- Layer Information Components
    nlayers : entity dcnn.LoadedCounter
    generic map (N => 3)
    port map (
        clk => clk, reset => gen_reset, enable => nlayers_counter_enable,
        load => nlayers_load, mode_in => '1', max_val_in => "000",
        load_data_in => nlayers_data_load, max_reached_out => nlayers_max_reached,
        counter_out => nlayers_out
    );
    
    layer_type : entity dcnn.Reg
    generic map (N => 2)
    port map (
        clk => clk, reset => gen_reset, load => layer_type_load, 
        d => layer_type_data_load, q => layer_type_out, rst_data => "00"
    );

    nflt_layer : entity dcnn.LoadedCounter
    generic map (N => 4)
    port map (
        clk => clk, reset => gen_reset, enable => nflt_layer_enable,
        load => nflt_layer_load, mode_in => '1', max_val_in => "0000",
        load_data_in => nflt_layer_data_load, max_reached_out => nflt_layer_max_reached,
        counter_out => nflt_layer_out
    );

    flt_size : entity dcnn.Reg
    generic map (N => 3)
    port map (
        clk => clk, reset => gen_reset, load => flt_size_load, 
        d => flt_size_data_load, q => flt_size_out, rst_data => "000"
    );

    new_width : entity dcnn.Reg
    generic map (N => 5)
    port map (
        clk => clk, reset => gen_reset, load => new_width_load,
        d => new_width_data_load, q => new_width_out, rst_data => "00000"
    );

    new_size_squared : entity dcnn.Reg
    port map (
        clk => clk, reset => gen_reset, load => new_size_squared_load,
        d => new_size_squared_data_load,  q => new_size_squared_out, rst_data => (others => '0')
    );

    layer_mem_size : entity dcnn.Reg
    port map (
        clk => clk, reset => gen_reset, load => layer_mem_size_load,
        d => layer_mem_size_data_load,  q => layer_mem_size_out, rst_data => (others => '0')
    );

    num_channels : entity dcnn.LoadedCounter
    generic map (N => 3)
    port map (
        clk => clk, reset => gen_reset, enable => num_channels_enable,
        load => num_channels_load, mode_in => '1', max_val_in => "000",
        load_data_in => num_channels_data_load, max_reached_out => num_channels_max_reached,
        counter_out => num_channels_out
    );

    img_width : entity dcnn.Reg
    generic map ( N => 5 )
    port map (
        clk => clk, reset => gen_reset, load => img_width_load,
        d => img_width_data_load, q => img_width_out, rst_data => "11100"
    );
    
    -- Generic counter
    cntr1_inst : entity dcnn.Counter
    generic map (N => 6)
    port map (
        clk => clk,
        reset => cntr1_reset,
        enable => cntr1_enable,
        mode_in => cntr1_mode,
        max_val_in => cntr1_max_val,
        max_reached_out => cntr1_max_reached,
        counter_out => cntr1_data
    );
    
    -- Memory addressing
    cntr_mem_addr : entity dcnn.Counter
    generic map (
        N => 16
    ) 
    port map (
        clk => clk,
        reset => gen_reset,
        enable => addr1_enable,
        mode_in => addr1_mode,
        max_val_in => (others => '1'),
        max_reached_out => addr1_max_reached,
        counter_out => addr1_data
    );

    -- Image Cache components
    img_cache : entity dcnn.Cache
        port map(
            in_word => cache_data_in,
            cache_in_sel => cache_width_count(4 downto 0),
            cache_out_sel  =>wind_width_count(4 downto 0),--not used here
            decoder_enable => cache_load,
            out_column => cache_data_out,
            clk => not_clk,
            reset => cache_rst
        );  

        
    -- reg_cache_height : entity dcnn.Reg
    -- port map (
    --     clk => not_clk,
    --     reset => cache_height_reset,
    --     load => cache_height_load,
    --     d => cache_height_in,
    --     q => cache_height,
    --     rst_data => cache_height_rst_data
    -- );

    -- reg_cache_width : entity dcnn.Reg
    -- port map (
    --     clk => not_clk,
    --     reset => cache_width_reset,
    --     load => cache_width_load,
    --     d => cache_width_in,
    --     q => cache_width,
    --     rst_data => cache_width_rst_data
    -- );

    cache_width_cntr : entity dcnn.Counter 
    generic map (
        N => 16
    ) 
    port map(
        clk => clk,
        reset => cache_width_count_rst,
        enable => cache_width_count_en,
        mode_in => cache_width_count_mode, -- 0 if +1, 1 if -1
        max_val_in => cache_width_1,
        max_reached_out => cache_width_ended,
        counter_out => cache_width_count
    );

    cache_height_cntr : entity dcnn.AdvancedCounter
    generic map (
        N => 16
    ) 
    port map(
        clk => clk,
        reset => cache_height_count_rst,
        enable => cache_height_count_en,
        mode_in => cache_height_count_mode, -- 0 if +1, 1 if -1
        max_val_in => max_height,
        max_reached_out => cache_height_ended,
        counter_out => cache_height_count
    );

    --Image window components
    window_width_cntr : entity dcnn.Counter 
    generic map (
        N => 16
    ) 
    port map(
        clk => clk,
        reset => wind_width_count_rst,
        enable => wind_width_count_en,
        mode_in => wind_width_count_mode, -- 0 if +1, 1 if -1
        max_val_in => wind_max_width,
        max_reached_out => wind_width_ended,
        counter_out => wind_width_count
    );


    ---making a control reg for the sake of homogienity inside states
    ftc_cntrl_reg_in<= 
                    edged & --15
                    second_fetch & --14
                    cache_height_ended &  --13
                    cache_width_ended & --12
                    wind_width_ended & --11
                    begin_ftc & --10
                    ini_wind & --9
                    finish_wind_row & --8
                     (7 downto 0 =>'0');

    (edged_o,second_fetch_o,
    cache_height_ended_o,
    cache_width_ended_o,
    wind_width_ended_o,
    begin_ftc_o,
    ini_wind_o,
    finish_wind_row_o) <= ftc_cntrl_reg_out(15 downto 8);

    ftc_cntrl_reg : entity dcnn.Reg
    port map (
        clk => not_clk,
        reset => ftc_cntrl_reg_rst,
        load => ftc_cntrl_reg_en,
        d => ftc_cntrl_reg_in,
        q => ftc_cntrl_reg_out,
        rst_data => (others=>'0')
    );


    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, addr1_data, mem_data_in, 
    IsPoolLayer, flt_size_out, cntr1_max_reached, img_width_out,
    filter_tbt,cache_height_ended_o,edged_o,cache_width_ended_o,second_fetch_o,wind_width_ended_o,cache_data_out,cache_height_ended,cache_width_ended,ini_wind_o,ini_wind,
    finish_wind_row,finish_wind_row_o)--finish_wind_row_o
    begin
        case current_state is
            -- Fetches the number of layers into the nlayers counter.
            when fetch_nlayers =>
                addr1_enable <= '1';
                addr1_mode <= '0';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                mem_write <= '0';
                nlayers_load <= '1';
                nlayers_data_load <= mem_data_in(2 downto 0);
                next_state <= fetch_layer_info_1;
            -- Fetch layer_type
            when fetch_layer_info_1 =>
                nlayers_load <= '0';
                layer_type_load <= '1';
                mem_addr_out <= addr1_data;
                layer_type_data_load <= mem_data_in(1 downto 0);
                next_state <= fetch_layer_info_2;
            -- Fetch nflt_layer
            when fetch_layer_info_2 =>
                layer_type_load <= '0';
                nflt_layer_load <= '1';
                mem_addr_out <= addr1_data;
                nflt_layer_data_load <= mem_data_in(3 downto 0);
                next_state <= fetch_layer_info_3;
            -- Fetch new filter size
            when fetch_layer_info_3 =>
                nflt_layer_load <= '0';
                flt_size_load <= '1';
                mem_addr_out <= addr1_data;
                flt_size_data_load <= mem_data_in(2 downto 0);
                next_state <= fetch_layer_info_4;
            -- Fetch new image size
            when fetch_layer_info_4 =>
                flt_size_load <= '0';
                new_width_load <= '1';
                mem_addr_out <= addr1_data;
                new_width_data_load <= mem_data_in(4 downto 0);
                next_state <= fetch_layer_info_5;
            -- Fetch new image size squared
            when fetch_layer_info_5 =>
                new_width_load <= '0';
                new_size_squared_load <= '1';
                mem_addr_out <= addr1_data;
                new_size_squared_data_load <= mem_data_in;
                next_state <= fetch_layer_info_6;
            -- Fetch the total memory area taken by the following layer
            when fetch_layer_info_6 =>
                new_size_squared_load <= '0';
                layer_mem_size_load <= '1';
                mem_addr_out <= addr1_data;
                layer_mem_size_data_load <= mem_data_in;
                if layer_type_out = "01" then
                    next_state <= fetch_layer_info_7;
                else
                    next_state <= init_filter_window_1;
                end if; 
            -- Fetch the new number of channels (for the FC layer)
            when fetch_layer_info_7 =>
                layer_mem_size_load <= '0';
                mem_addr_out <= addr1_data;
                num_channels_enable <= '0';
                num_channels_load <= '1';
                num_channels_data_load <= mem_data_in(2 downto 0);
                img_width_load <= '1';
                img_width_data_load <= "00101"; -- i.e. 5
                next_state <= init_filter_window_1;
            -- Step 1 of Init filter: reset the counter, prepare for the loop
            when init_filter_window_1 =>
                mem_read <= '0';
                mem_write <= '0';
                layer_mem_size_load <= '0';
                num_channels_load <= '0';
                addr1_enable <= '0';
                img_width_load <= '0';
                -- do stuff 
                if IsPoolLayer = '1' then
                    next_state <= init_image_cache_1;
                else
                    mem_read <= '1';
                    write_mem_to_fltr <= '1';
                    cntr1_reset <= '1';
                    cntr1_enable <= '0';
                    next_state <= init_filter_window_2;
                end if;
            -- Step 2 of Init filter: actual loop
            when init_filter_window_2 =>
                cntr1_reset <= '0';
                cntr1_enable <= '1';
                cntr1_mode <= '0';
                if flt_size_out = "011" then
                    cntr1_max_val <= "001000"; -- (8 = 9 - 1)
                else
                    cntr1_max_val <= "100100"; -- (24 = 25 - 1)
                end if;
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                write_mem_to_fltr <= '1';
                if cntr1_max_reached = '0' then
                    next_state <= init_filter_window_2;
                else
                    next_state <= init_image_cache_1;
                end if;
                
            when init_image_cache_1 =>
                -- Cleaning up from Init filter window
                cntr1_enable <= '0';
                write_mem_to_fltr <= '0';
                mem_read <= '0';
                addr1_enable <= '0';
                nflt_layer_enable <= '0';

                -- Properly set the maximum width and height
                -- max_width <= img_width_out;
                max_height <= x"0005";
                -- Reset stuff
                cntr1_reset <= '1';
                ftc_cntrl_reg_rst <= '1';--reset control register
                ftc_cntrl_reg_en <= '0';
                cache_rst <= '1'; --reset cache and its counters
                cache_width_count_rst <= '1';
                cache_width_count_mode <= '0';
                cache_height_count_rst <= '1';
                cache_height_count_mode <= "00";
                -- Next state is the loop
                next_state <= init_image_cache_2;

            when init_image_cache_2 =>
                cache_rst <= '0';
                ftc_cntrl_reg_rst <= '0';
                ftc_cntrl_reg_en <= '1';

                if cache_height_ended_o = '0' then 
                    if cache_width_ended_o = '0' then --add pixel to cache
                        addr1_enable <= '1';
                        mem_addr_out <= std_logic_vector(unsigned(base_addr) + unsigned(addr1_data));
                        mem_read <= '1';
                        cache_data_in <= mem_data_in;
                        cache_load <= '1';

                        cache_height_count_en <= '0';
                        cache_width_count_rst <= '0';
                        if begin_ftc_o='0' then  -- starting new row   
                            cache_width_count_en<='0';
                            begin_ftc<='1';
                        else
                            cache_width_count_en<='1';
                            begin_ftc<='1';
                        end if;
                    else --inner loop ended
                        addr1_enable <= '0';
                        mem_read <= '0';
                        cache_load <= '0';
                        cache_width_count_en <= '0';
                        cache_width_count_rst <= '1';
                        begin_ftc <= '0';

                        cache_height_count_en <= '1';
                        cache_height_count_rst <= '0';

                    end if;
                    next_state <= current_state;
                else --outer loop ended
                    cache_width_count_rst <= '1'; --resetting for next states 
                    cache_height_count_en <= '0';
                    next_state <= postini_cache;
                    wind_width_count_rst <= '1';
                    -- wind_width_count_rst <= '0';
                    wind_max_width <= x"0004";
                    ini_wind <= '1';
                    edged <= '0';
                    second_fetch<='0';
                   
                end if;
            when postini_cache=> -- setting up what is needed for next states (fetch to cache, i need to dec height)
                ftc_cntrl_reg_rst <= '1'; --for fetch to cache
                -- -1 height 1 to prepare for fetch to cache
                cache_height_count_en <= '1';
                cache_height_count_mode <= "01";
                next_state <= preini_img_window;
                
            when preini_img_window => --for the sake of reusing this state for fetch to wind
                cache_height_count_en <= '0';
              
                ftc_cntrl_reg_rst <= '0'; 
                ftc_cntrl_reg_en<='1';
                if finish_wind_row = '1' then
                    next_state<= fetch_to_cache;
                elsif ini_wind='1' then
                    next_state <= init_image_window;
                    wind_width_count_rst<='1';
                else
                    next_state<= start_convolution;
                    wind_width_count_rst<='0';
                end if;
                
            when init_image_window => --to be in the same tate need to check that cache_hight_count == 4 && wind_col_count <= cache_width_count 
                wind_max_width <= x"0004";

                wind_rst<='0';  
                 --for "fetch to cache" state  
                -- ftc_cntrl_reg_rst <= '0'; 
                -- ftc_cntrl_reg_en<='1';
                cache_height_count_en <= '0';
                -- cache_out_sel <= wind_width_count;

                if wind_width_ended_o = '0' then  --If window_col_count != 5
                    wind_col_in<= cache_data_out;
                    wind_en <= '1';

                    wind_width_count_rst<='0';
                    if ini_wind_o='1' then
                        ini_wind<='0';
                        wind_width_count_en <= '0';
                    else
                        wind_width_count_en <= '1';
                    end if;
                    
                    wind_width_count_mode<='0';
                    next_state <= current_state;
                else
                    wind_width_count_en <= '0';
                    wind_en <= '0';
                    next_state <= start_convolution_1;   
                    wind_max_width<=cache_width_1; 
                end if;
             
            when start_convolution =>
                next_state <= fetch_to_cache;   
		
            when fetch_to_cache =>  
            -- Cleaning up
            mem_read <= '0';
            channel_zero <= '0';

            --Making sure signals are correctly set
            addr1_reset<='0';
            ftc_cntrl_reg_en<='1';
            ftc_cntrl_reg_rst<='0'; ----must be reset at end on ini windowwwww please.
            max_height<=cache_height_1;
         
            wind_en <= '0';
            --Deciding when to incremend counters (height and width)
            if cache_width_ended_o='1' then 
                cache_width_count_rst<='1'; -- rst to 0000
                cache_width_count_en<='0';
                finish_wind_row<='0';
                wind_width_count_rst<='1'; -- rst to 0000
                ini_wind<='1';

                if cache_height_ended_o='0' then
                    cache_height_count_rst<='0';       
                    cache_height_count_en<='1'; 
                    cache_height_count_mode<="00"; -- to increment 1
                    
                else
                    cache_height_count_en<='0'; 
                end if;
            else
                ini_wind<='0';
                cache_height_count_en<='0'; 
                cache_width_count_rst<='0';


                if begin_ftc_o='0' then         
                    cache_width_count_en<='0';
                    begin_ftc<='1';
                else
                    cache_width_count_en<='1';
                    begin_ftc<='1';
                end if;
                    
                cache_width_count_mode<='0'; -- +1
            end if;

               --Deciding if i'm about to load 0's into cache
            if (cache_width_ended='1' and cache_height_ended='1') or edged_o='1' then -- for self latching
               edged<='1';
            else
               edged<='0';
            end if;
            
            --What value will be pushed into cache
            if  edged_o='0' then  --undefined in first time, should be pre initialized to 0 in some previouse state

                addr1_enable<='1'; 
                addr1_mode<='0'; -- given that it is a counter that only jumps +1
                mem_read <='1';
                mem_addr_out <= std_logic_vector(unsigned(base_addr) + unsigned(addr1_data));
                cache_data_in<=mem_data_in;
                cache_load<='1';
                
            else
                
                cache_load<='1';
                cache_data_in<=(others=>'0'); --insert 0
                addr1_enable<='0'; 
                mem_read <='0';
                -- edged<='0';


            end if;
            --decide next state
            -- if ini_wind='1'
            if  filter_tbt='1' and second_fetch_o='0' and ini_wind='0' then-- and (cache_width_ended_o='0' or (cache_width_ended_o='1' and cache_width(0)='1')) then --even with so i can fetch again
                next_state<=fetch_to_cache;
                second_fetch<='1';
            elsif finish_wind_row='1' then    
                next_state<= fetch_to_cache;
                second_fetch<='0';
            elsif ini_wind='1' then
                next_state<=write_to_memory;
                second_fetch<='0';
            else 
                next_state<=fetch_to_image_window;
                second_fetch<='0';
            end if;
                -- next_state<= --for now for testing purposes
                
            --prepae for fetch to iimg_wind
            


        when fetch_to_image_window => --assuming col counter is at 4 (first window already initialized)
        --cache in sel is window_col_counter.

        --- I'll disable alll uneeded counterrrrss and stuff
         
            cache_load<='0';
            
            cache_width_count_en<='0';
            cache_height_count_en<='0';
            addr1_enable<='0'; 
            mem_read <='0';

            -- next_state<=fetch_to_cache;

            ftc_cntrl_reg_en<='1';
            ftc_cntrl_reg_rst<='0';

            cache_out_sel<= wind_width_count;
            if wind_width_ended_o='1' and filter_tbt='1'  then
                wind_en<='1';
                wind_col_in<=(others => (others => '0'));
                wind_width_count_en<='0';
            elsif  wind_width_ended_o='0' then --because if max_reachd i need to re initialize window
                wind_en<='1';
                wind_col_in<= cache_data_out;
                wind_width_count_rst<='0';
                wind_width_count_en<='1';
                wind_width_count_mode<='0';
            else
                wind_en<='0';
                wind_width_count_en<='0';
            end if;


            --decide next state
            if filter_tbt='1' and second_fetch_o='0' then
                second_fetch<='1';
                next_state<=fetch_to_image_window;

            else
      
                if wind_width_ended_o='1' then
                    finish_wind_row <= '1'; -- reset signal 

                    -- if finish_wind_row_o='1'then --end of row
                    --     -- finish_wind_row <= '1'; -- reset signal 
                    next_state<=fetch_to_cache;
                    -- else
                        -- next_state<=write_to_memory;
                    -- end if;
                    -- ini_wind<='1'; --fetch new window and
                else
                    -- ini_wind<='0';
                    finish_wind_row <= '0';
                    next_state<=write_to_memory;
                end if; 
              
                second_fetch<='0';  
            end if; 

        when write_to_memory =>
        --disable controls of fetch
         
        cache_load<='0';
            
        cache_width_count_en<='0';
        cache_height_count_en<='0';
        addr1_enable<='0'; 
        mem_read <='0';
        -- disable controls of previous state
            ftc_cntrl_reg_en<='0';
            wind_width_count_en<='0';
            wind_en<='0';

            next_state<=preini_img_window;

  
            when argmax_computation =>

            when write_classification =>

            when end_state =>
                next_state <= current_state;
            end case;
    end process;
    
    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk, actual_next_state)
    begin
        if falling_edge(clk) then
            current_state <= actual_next_state;
        end if;
    end process;
end Mixed;