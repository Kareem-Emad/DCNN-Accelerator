library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity Controller is
    generic (
        N : natural := 16;  -- precision of the data
        M : natural := 16  -- size of the address bus
    );
    port (
        clk             :   in  std_logic;
        io_ready        :   in  std_logic;
        io_done         :   out std_logic := 'Z';
        mem_data_in     :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out    :   out std_logic_vector(N - 1 downto 0);
        mem_addr        :   out std_logic_vector(M - 1 downto 0);
        mem_write       :   out std_logic;
        mem_read        :   out std_logic;
        filter_data     :   out std_logic_vector(N-1 downto 0)
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
        if current_state = init_filter_window then

        elsif current_state = init_image_cache then

        elsif current_state = start_convolution then
        
        elsif current_state = fetch_to_cache then

        elsif current_state = fetch_to_image_window then

        elsif current_state = write_to_memory then

        elsif current_state = argmax_computation then

        elsif current_state = write_classification then

        elsif current_state = end_state then
            next_state <= next_state;
        end if;
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