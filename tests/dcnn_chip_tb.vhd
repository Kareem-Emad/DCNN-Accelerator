library ieee, modelsim_lib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use modelsim_lib.util.all;
library dcnn;
use dcnn.config.all;

entity DCNNChipTB is
end DCNNChipTB;

architecture TB of DCNNChipTB is
    signal clk, reset, read_mem, write_mem, not_clk : std_logic := '0';
    signal address : std_logic_vector(15 downto 0) := (others => 'Z');
    signal data_into_mem, data_outof_mem : std_logic_vector(15 downto 0) := (others => 'Z');
    signal io_done_out : std_logic;
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

    dcnn_chip_inst : entity dcnn.DCNNChip
        port map (
            clk => clk,
            reset => reset,
            io_ready_in => '1',
            io_done_out => io_done_out,

            mem_read_out => read_mem,
            mem_write_out => write_mem,
            mem_addr_out => address,
            mem_data_in => data_outof_mem,
            mem_data_out => data_into_mem
        );

    process is
    begin
        reset <= '1';
        wait for period;
        reset <= '0';
        wait for period;

        wait for 50000 * period;
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;
end TB;