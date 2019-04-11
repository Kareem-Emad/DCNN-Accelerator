library ieee;
use ieee.std_logic_1164.all;
library work;

entity RegTB is
end RegTB;

architecture TB of RegTB is
    signal clk, load, reset : std_logic := '0';
    signal data_in, data_out : std_logic_vector(15 downto 0) := (others => '1');
    constant period : time := 1 ns;

begin
    reg_inst : entity work.Reg
        port map (
            clk => clk,
            reset => reset,
            load_in => load,
            d_in => data_in,
            q_out => data_out 
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