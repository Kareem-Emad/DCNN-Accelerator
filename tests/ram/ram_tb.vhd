library ieee;
use ieee.std_logic_1164.all;
library work;

entity ram_tb is
end ram_tb;

architecture tb of ram_tb is
    signal clk, read_in, write_out : std_logic := '0';
    signal address : std_logic_vector(3 downto 0) := (others => 'Z');
    signal data_in, data_out : std_logic_vector(15 downto 0) := (others => 'Z');
    constant period : time := 1 ns;

begin
    ram_inst : entity work.ram
        generic map (
            N => 16,
            M => 4
        )
        port map (
            clk => clk, read_in => read_in, write_out => write_out,
            address => address,
            data_in => data_in,
            data_out => data_out
        );
    
    process is
    begin
        address <= "0001";
        write_out <= '1';
        wait for period;
        assert (data_out = X"0101") report "Reading from the memory failed!";
        write_out <= '0';
        address <= "0010";
        read_in <= '1';
        data_in <= (others => '1');
        wait for period;
        read_in <= '0';
        write_out <= '1';
        wait for period;
        assert (data_out = (15 downto 0 => '1')) report "Writing to the memory failed!";
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
end tb;