library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;
use dcnn.constants.all;
use dcnn.config.all;

entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16;  -- size of the address bus
        WREG : natural := 5;  --size of img width reg (max 28, 5 bits)   
        HREG: natural := 16; --for now since i don't know how big the FC stage img is
        creg: natural := 16 --could change according to size
    );
    port (
        clk             :   in  std_logic;
        io_ready_in     :   in  std_logic;
        io_done_out     :   out std_logic;
        mem_data_in     :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out    :   out std_logic_vector(N - 1 downto 0);
        mem_addr_out    :   out std_logic_vector(M - 1 downto 0);
        mem_write_out   :   out std_logic; -- writes into memory
        mem_read_out    :   out std_logic; -- reads from memory
        filter_data_out :   out std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        init_filter_window,
        init_image_cache,
        init_image_window,
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory,
        argmax_computation,
        write_classification,
        end_state
    );

    signal current_state : state_type := init_image_cache; --init_filter_window;
    signal next_state : state_type := init_image_cache; --init_filter_window;

    signal cntr1_reset : std_logic := '0';
    signal cntr1_reset_new : std_logic := '0';
    signal cntr1_enable : std_logic := '1';
    signal cntr1_mode : std_logic := '0';
    signal cntr1_max_val : std_logic_vector(4 downto 0) := (others => '1');
    signal cntr1_max_reached : std_logic := 'Z';
    signal cntr1_data : std_logic_vector(4 downto 0) := (others => 'Z');

    signal fltSize_reset : std_logic := '0';
    signal fltSize_load : std_logic := '0';
    -- signal fltSize_data_in : std_logic_vector(N-1 downto 0) := '0';
    signal fltSize_data_out : std_logic_vector(N-1 downto 0) := (others => '0');
    signal fltSize_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');

    signal bias_reset : std_logic := '0';
    signal bias_load : std_logic := '0';
    signal bias_data_out : std_logic_vector(N-1 downto 0) := (others => '0');
    signal bias_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');

    signal addr1_reset : std_logic := '0';
    signal addr1_enable : std_logic := '1';
    signal addr1_mode : std_logic := '0';
    signal addr1_max_reached : std_logic := 'Z';
    signal addr1_data : std_logic_vector(M-1 downto 0) := (others => 'Z');

    signal fltSize_squaredp3 : std_logic_vector(4 downto 0) := (others => 'Z');
    signal write_mem_to_fltr : std_logic := '0';
    ------------Signals for Cache----------------
    signal cache_height_reset : std_logic := '0'; --for cache height register
    signal cache_height_load : std_logic := '0';
    signal cache_height : std_logic_vector(N-1 downto 0) := (others => '0');
    signal cache_height_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');
    signal cache_height_1 : std_logic_vector(N-1 downto 0);

    signal cache_width_reset : std_logic := '0'; --for cache width register
    signal cache_width_load : std_logic := '0';
    signal cache_width : std_logic_vector(N-1 downto 0) := (others => 'Z');
    signal cache_width_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');
    signal cache_width_1 : std_logic_vector(N-1 downto 0);

    signal cache_height_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache height counter
    signal cache_height_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal cache_height_count_rst : std_logic := '0';
    signal cache_height_count_en : std_logic := '0';
    signal cache_height_count_mode : std_logic_vector(1 downto 0) := (others => '0');
    signal cache_height_ended : std_logic := 'Z';
    signal max_height : std_logic_vector(15 downto 0) := (others => '0'); 

    signal cache_width_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache width counter
    signal cache_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal cache_width_count_rst : std_logic := '0';
    signal cache_width_count_en : std_logic := '0';
    signal cache_width_count_mode : std_logic := '0';
    signal cache_width_ended : std_logic := 'Z';
    signal max_width : std_logic_vector(15 downto 0) := (others => '0'); 

    signal cache_data_in  : std_logic_vector(N - 1 downto 0) := (others => '0');
    signal cache_data_out   : wordarr_t(4 downto 0) := (others => (others => 'Z'));
    signal cache_out_sel    : std_logic_vector(N-1 downto 0) := (others => '0');--(cache_width_count+5); --make sure
    signal cache_load        : std_logic := '0';
    signal cache_rst : std_logic := '0';
    
    signal not_clk : std_logic := '0';
    signal base_addr : std_logic_vector(M-1 downto 0) := (others => '0'); --to be coming from counter later  
-----------------------------------------------------------------------------------------------------------------
    --for implementation optimization
    signal filter_tbt: std_logic; -- state signal
    -- signal add_upper_limit_in: std_logic_vector(M-1 downto 0):=(others=>'1');
   
    --Signals between states
    signal edged: std_logic;
    signal second_fetch: std_logic;

    --connected to window col counter (normal counter)
    signal wind_width_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache width counter
    signal wind_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal wind_width_count_rst : std_logic := '0';
    signal wind_width_count_en : std_logic := '0';
    signal wind_width_count_mode : std_logic := '0';
    signal wind_width_ended : std_logic := 'Z';
    signal wind_max_width : std_logic_vector(15 downto 0) := (others => '0'); 
    ------ for image window ----------------
    signal wind_en: std_logic := '0';
    signal wind_rst : std_logic := '0';
    signal wind_col_in  : wordarr_t(4 downto 0) := (others => (others => '0'));
    signal wind_col_out : wordarr_t(24 downto 0) := (others => (others => 'Z'));
    ------ for control register -----------
    signal ftc_cntrl_reg_in: std_logic_vector(creg-1 downto 0);
    signal ftc_cntrl_reg_out: std_logic_vector(creg-1 downto 0);
    signal ftc_cntrl_reg_en: std_logic;
    signal ftc_cntrl_reg_rst: std_logic;
    --cnrl reg out
    signal edged_o : std_logic;
    signal second_fetch_o : std_logic;
    signal cache_height_ended_o : std_logic;
    signal cache_width_ended_o : std_logic;
    signal wind_width_ended_o : std_logic;
    signal begin_ftc_o : std_logic;
    signal begin_ftc: std_logic := '0';
    -----------------------------------------------------------
begin
    fltSize_squaredp3 <= "11100" when fltSize_data_out = X"0005" else "01100";
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');
    not_clk <= "not"(clk);
    --width_ended <= '1' when cache_width_ended = '1' else '0';
    -- height_ended <= '1' when cache_height_ended = '1' else '0';
    cache_width_1 <= std_logic_vector(unsigned(cache_width) + 1); --cache_width - 1;
    cache_height_1 <= std_logic_vector(unsigned(cache_width) - 1);

    --fetch cache cotntrol register
    ftc_cntrl_reg_in<= 
                edged & --15
                second_fetch & --14
                cache_height_ended &  --13
                cache_width_ended & --12
                wind_width_ended & --11
                begin_ftc & --10
                (9 downto 0 =>'0');

    (edged_o,second_fetch_o,
    cache_height_ended_o,
    cache_width_ended_o,
    wind_width_ended_o,
    begin_ftc_o) <= ftc_cntrl_reg_out(15 downto 10);

    ftc_cntrl_reg : entity dcnn.Reg
    port map (
        clk => not_clk,
        reset => ftc_cntrl_reg_rst,
        load => ftc_cntrl_reg_en,
        d => ftc_cntrl_reg_in,
        q => ftc_cntrl_reg_out,
        rst_data => (others=>'0')
    );

    cntr1_inst : entity dcnn.Counter
    port map (
        clk => clk,
        reset => cntr1_reset,
        enable => cntr1_enable,
        mode_in => cntr1_mode,
        max_val_in => cntr1_max_val,
        max_reached_out => cntr1_max_reached,
        counter_out => cntr1_data
    );
    
    cntr_mem_addr : entity dcnn.Counter
    generic map (
        N => 16
    ) 
    port map (
        clk => clk,
        reset => addr1_reset,
        enable => addr1_enable,
        mode_in => addr1_mode,
        max_val_in => (others => '1'),
        max_reached_out => addr1_max_reached,
        counter_out => addr1_data
    );

    reg_filter_height : entity dcnn.Reg
    port map (
        clk => clk,
        reset => fltSize_reset,
        load => fltSize_load,
        d => mem_data_in,
        q => fltSize_data_out,
        rst_data => fltSize_rst_data
    );

    reg_bias1 : entity dcnn.Reg
    port map (
        clk => clk,
        reset => bias_reset,
        load => bias_load,
        d => mem_data_in,
        q => bias_data_out,
        rst_data => bias_rst_data
    );
    ---------------For Initialize Cache stat -----------------------
    img_cache : entity dcnn.Cache
        port map(
            in_word => cache_data_in,
            cache_in_sel => cache_width_count(4 downto 0),
            cache_out_sel  => cache_out_sel(4 downto 0), --not used here
            decoder_enable => cache_load,
            out_column => cache_data_out,
            clk => not_clk,
            reset => cache_rst
        );  

    img_window : entity dcnn.ImageWindow
        port map(
            d => wind_col_in,
            q => wind_col_out, --not used here
            clk => not_clk,
            load => wind_en,
            reset => wind_rst
        );

    reg_cache_height : entity dcnn.Reg
        port map (
            clk => not_clk,
            reset => cache_height_reset,
            load => cache_height_load,
            d => cache_height_in,
            q => cache_height,
            rst_data => cache_height_rst_data
        );
    
    reg_cache_width : entity dcnn.Reg
        port map (
            clk => not_clk,
            reset => cache_width_reset,
            load => cache_width_load,
            d => cache_width_in,
            q => cache_width,
            rst_data => cache_width_rst_data
        );
    
    CacheWidthCounter : entity dcnn.Counter 
        generic map (
            N => 16
        ) 
        port map(
            clk => clk,
            reset => cache_width_count_rst,
            enable => cache_width_count_en,
            mode_in => cache_width_count_mode, -- 0 if +1, 1 if -1
            max_val_in => max_width, --cache_width,
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
            max_val_in => max_height,   --cache_height_1,
            max_reached_out => cache_height_ended,
            counter_out => cache_height_count
        );

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
    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, cntr1_data, fltSize_squaredp3, cntr1_max_reached ,cache_height_ended,cache_width_ended,mem_data_in,addr1_data,
        begin_ftc_o,cache_height_ended_o,cache_width_ended_o,wind_width_ended_o)
    begin
        case current_state is
            -- Fetch the filter window; Needs a counter.
            when init_filter_window =>
                -- Assumes the counter starts at the right memory address.
                case cntr1_data is
                    when "00000" => -- 1: Load Filter Size
                        -- Filter data not ready yet.
                        write_mem_to_fltr <= '0';
                        -- Prepare the counter for the future.
                        cntr1_reset_new <= '0';
                        cntr1_enable <= '1';
                        cntr1_mode <= '0';
                        cntr1_max_val <= "11111";

                        -- Prepare the memory address counter for the future.
                        addr1_reset <= '0';
                        addr1_enable <= '1';
                        addr1_mode <= '0';
                        
                        -- Load Filter Size from memory
                        fltSize_reset <= '0';
                        fltSize_load <= '1';
                        mem_addr_out <= addr1_data;
                        mem_write_out <= '0';
                        mem_read_out <= '1';

                        -- The next state will be the same because we change nothing.
                        next_state <= current_state;
                    when "00001" => -- 2: Load Bias
                        fltSize_load <= '0';
                        cntr1_max_val <= fltSize_squaredp3;

                        -- Load bias from memory
                        mem_addr_out <= addr1_data;
                        mem_read_out <= '1';
                        bias_reset <= '0';
                        bias_load <= '1';
                        
                        next_state <= current_state;
                    -- when "00010" => 
                    when others => -- 3: Fetch to the filter window.
                        bias_load <= '0';
                        if cntr1_max_reached = '0' then -- 4: Loop: for i = 0; i < Imax; i++
                            -- 5:   If Edge: Write 0. Ignored for now..
                            -- 6:   Else: Fetch pixel from current mem loc.
                            mem_addr_out <= addr1_data;
                            mem_read_out <= '1';
                            write_mem_to_fltr <= '1';
                        else
                            cntr1_reset_new <= '1';
                            mem_read_out <= '0';
                            write_mem_to_fltr <= '0';
                            next_state <= init_image_cache;
                        end if;
                    end case;
            
            when init_image_cache =>
                case cntr1_data is
                    when "00000" => --for initialization
                        max_width <= x"0004"; --for testing only, should be written in previous state

                        cache_rst <= '1';
                        addr1_enable <= '0';
                        max_height <= x"0005";

                        cache_width_count_rst <= '1';
                        cache_width_count_mode <= '0';
                        cache_height_count_rst <= '1';
                        cache_height_count_mode <= "00";

                        ftc_cntrl_reg_rst <= '1';
                        ftc_cntrl_reg_en <= '0';

                        cntr1_reset_new <= '0';
                        cntr1_enable <= '1';
                        cntr1_mode <= '0';
                        cntr1_max_val <= "11111";
                        next_state <= current_state;
                    when others =>
                        cache_rst <= '0';
                        ftc_cntrl_reg_rst <= '0';
                        ftc_cntrl_reg_en <= '1';

                        if cache_height_ended_o = '0' then 
                            if cache_width_ended_o = '0' then --add pixel to cache
                                addr1_enable <= '1';
                                mem_addr_out <= std_logic_vector(unsigned(base_addr) + unsigned(addr1_data));
                                mem_read_out <= '1';
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
                                mem_read_out <= '0';
                                cache_load <= '0';
                                cache_width_count_en <= '0';
                                cache_width_count_rst <= '1';
                                begin_ftc <= '0';

                                cache_height_count_en <= '1';
                                cache_height_count_rst <= '0';

                            end if;
                            next_state <= current_state;
                        else --outer loop ended
                            cache_height_count_rst <= '1';
                            cache_width_count_rst <= '1';
                            next_state <= init_image_window;
                            wind_width_count_rst <= '1';
                            wind_max_width <= x"0004";
                        end if;
                    end case;
            when init_image_window => --to be in the same tate need to check that cache_hight_count == 4 && wind_col_count <= cache_width_count 
                
                if wind_width_ended_o = '0' then  --If window_col_count != 5
                    cache_out_sel <= wind_width_count;
                    wind_col_in<= cache_data_out;
                    wind_en <= '1';
                    
                    wind_width_count_rst<='0';
                    wind_width_count_en <= '1';
                    wind_width_count_mode<='0';
                    next_state <= current_state;
                else
                    wind_width_count_en <= '0';
                    next_state <= start_convolution;    
                end if;
                    
                -- when out from init image window: 
                --     wind_width_count = 4
                --     cache_width_count = 0
                --     cache_hight_count = 0
            when start_convolution =>

            when fetch_to_cache =>
                    --max_height <= cache_height_1;
            when fetch_to_image_window =>
                    --wind_max_width <= cache_width_1;
            when write_to_memory =>

            when argmax_computation =>

            when write_classification =>

            when others =>
                next_state <= current_state;
            end case;
    end process;
                    
    -- This process syncs the reset of cntr1, normally asynchronously reset.
    -- This needs to be synchronized since otherwise we'd have a glitch in the computation of the next state.
    sync_cntr1_reset : process(clk, cntr1_reset_new)
    begin
        if falling_edge(clk) then
            cntr1_reset <= cntr1_reset_new;
        end if;
    end process;
    
    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk, next_state)
    begin
        if falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end Mixed;