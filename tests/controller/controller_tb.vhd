library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;

entity ControllerTB is
end ControllerTB;

architecture TB of ControllerTB is
    signal clk, read_mem, write_mem : std_logic := '0';
    signal address : std_logic_vector(15 downto 0) := (others => 'Z');
    signal data_into_mem, data_outof_mem : std_logic_vector(15 downto 0) := (others => 'Z');
    signal filter_data : std_logic_vector(15 downto 0) := (others => 'Z');
    signal io_ready : std_logic := '1';
    constant period : time := 1 ns;
begin
    ram_inst : entity dcnn.Ram
        port map (
            clk => clk,
            read_in => read_mem,
            write_in => write_mem,
            address_in => address,
            data_in => data_into_mem,
            data_out => data_outof_mem
        );

    controller_inst : entity dcnn.Controller
        port map (
            clk => clk,
            io_ready_in => io_ready,
            mem_data_in => data_outof_mem,
            mem_data_out => data_into_mem,
            mem_addr_out => address,
            mem_read_out => read_mem,
            mem_write_out => write_mem,
            filter_data_out => filter_data
        );
-- 2: Initialize memory values (maybe in the simulator?)
-- 3: Test the initialization of the filter window.

    process is
    begin
        wait for period * 4;
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;
end TB;