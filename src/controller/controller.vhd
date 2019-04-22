
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;


entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16  -- size of the address bus
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

    signal channel_ctr_reset : std_logic := '0';
    signal channel_ctr_enable  : std_logic := '0';
    signal channel_ctr_mode: std_logic := '0';
    signal channel_max_reached_out : std_logic;
    signal channel_ctr_out : std_logic_vector(2 downto 0);
    signal channel_ctr_max_val_in : std_logic_vector(2 downto 0);

    -- Memory Addressing
    signal addr1_reset : std_logic := '0';
    signal addr1_enable : std_logic := '1';
    signal addr1_mode : std_logic := '0';
    signal addr1_max_reached : std_logic := 'Z';
    signal addr1_data : std_logic_vector(M-1 downto 0) := (others => 'Z');
    signal write_mem_to_fltr : std_logic := '0';
    signal mem_read, mem_write : std_logic;

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

    -- Cache Init Signals
    signal max_width : std_logic_vector(4 downto 0);
    signal max_height : std_logic_vector(4 downto 0);

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

    ctr_channel : entity dcnn.counter
    generic map (
        N => 3
    )
    port map (
        clk => clk,
        reset => channel_ctr_reset,
        enable => channel_ctr_enable,
        mode_in => channel_ctr_mode,
        max_val_in => channel_ctr_max_val_in,
        max_reached_out => channel_max_reached_out,
        counter_out => channel_ctr_out
    );

    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, addr1_data, mem_data_in, 
    IsPoolLayer, flt_size_out, cntr1_max_reached, img_width_out)
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
                -- Cleaning up
                -- TO-DO: Transfer Image Cache here!
            when init_image_cache_2 =>
                -- TO-DO: Image Cache Loop here!
            when start_convolution =>
		
            when fetch_to_cache =>
                    
            when fetch_to_image_window =>
            -- we need to add a counter for the convolution process.
            when write_to_memory =>
                
            when argmax_computation =>

            when write_classification =>

            when others =>
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