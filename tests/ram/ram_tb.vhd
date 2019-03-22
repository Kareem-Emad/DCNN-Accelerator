library ieee;
use ieee.std_logic_1164.all;
library work;

entity RamTB is
end RamTB;

architecture TB of RamTB is
    signal clk, read_in, write_out : std_logic := '0';
    signal address : std_logic_vector(7 downto 0) := (others => 'Z');
    signal data_in, data_out : std_logic_vector(15 downto 0) := (others => 'Z');
    constant period : time := 1 ns;

begin
    ram_inst : entity work.Ram
        port map (
            clk => clk, read_in => read_in, write_out => write_out,
            address => address,
            data_in => data_in,
            data_out => data_out
        );
    
    process is
    begin
        write_out <= '0';
        address <= X"10";
        read_in <= '1';
        data_in <= (others => '1');
        wait for period;
        read_in <= '0';
        write_out <= '1';
        wait for period;
        assert (data_out = (15 downto 0 => '1')) report "R/W to the memory failed!";
        write_out <= '0';
        wait for period;
        assert (data_out = (15 downto 0 => 'Z')) report "The RAM keeps the line busy!";
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;
end TB;