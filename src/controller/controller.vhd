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
        mem_write_out   :   out std_logic;
        mem_read_out    :   out std_logic;
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
    signal next_state : state_type := init_image_cache;

begin
    -- This process computes the next state given the current state and the inputs.
    comp_ns : process(current_state)
    begin
        case current_state is
            when init_filter_window =>
                -- Fetch the filter window; Needs a counter.
                -- 1: Load Filter Width
                -- 2: Load Filter Height
                -- 3: Load Bias
                -- 4: If FilterWidth=3, Set Imax=9. Else Set Imax=25.
                -- 5: Loop: for i = 0; i < Imax; i++
                -- 6:   If Edge: Write 0. 
                -- 7:   Else: Fetch pixel from current mem loc.
            when init_image_cache =>

            when start_convolution =>

            when fetch_to_cache =>

            when fetch_to_image_window =>

            when write_to_memory =>

            when argmax_computation =>

            when write_classification =>

            when end_state =>
                next_state <= current_state;
            end case;
    end process;

    
    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk)
    begin
        if falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end Mixed;