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
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory,
        argmax_computation,
        write_classification,
        end_state
    );

    signal current_state : state_type := init_filter_window;
    signal next_state : state_type := init_filter_window;

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
begin
    fltSize_squaredp3 <= "11100" when fltSize_data_out = X"0005" else "01100";
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');

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

    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, cntr1_data, fltSize_squaredp3, cntr1_max_reached)
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
                            next_state <= end_state;
                        end if;
                    end case;
            when init_image_cache =>
                    
            when start_convolution =>

            when fetch_to_cache =>
                    
            when fetch_to_image_window =>

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