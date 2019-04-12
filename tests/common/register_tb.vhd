library ieee;
use ieee.std_logic_1164.all;
library dcnn;

entity RegTB is
end RegTB;

architecture TB of RegTB is
    signal clk, load, reset : std_logic := '0';
    signal data_in, data_out : std_logic_vector(15 downto 0) := (others => '1');
    signal rst_data : std_logic_vector(15 downto 0) := (others => '0');
    constant period : time := 1 ns;

begin
    reg_inst : entity dcnn.Reg
        port map (
            clk => clk,
            reset => reset,
            load => load,
            d => data_in,
            q => data_out,
            rst_data => rst_data
        );

    process is
    begin
        load <= '1';
        data_in <= X"1234";
        wait for period;
        load <= '0';
        assert (data_out = X"1234") report "Writing to register failed!";
        wait for period;
        assert (data_out = X"1234") report "Register does not latch!";
        wait for period;
        reset <= '1';
        wait for period;
        assert (data_out = X"0000") report "Reset does not work!";
        reset <= '0';
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;
end TB;