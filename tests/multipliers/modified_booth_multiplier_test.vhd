library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;

entity ModifiedBoothTest is
end ModifiedBoothTest;



-- Problems Found : Component Takes two cycles to load input

architecture Test of ModifiedBoothTest is


component ModifiedBoothMultiplier is 
	port(
		M         : in signed(15 downto 0);-- First operand
		R        : in signed(15 downto 0);-- Second operand
		cnt_enable : in std_logic;-- enable from counter
		product     : out signed(31 downto 0);-- Final product
		clk : in std_logic -- clock
	);
end component ModifiedBoothMultiplier;


constant period : time := 100 ps;
signal clk : std_logic := '0';

signal a,b : signed(15 downto 0) := (others=>'0') ;
signal p : signed(31 downto 0) := (others=>'0') ;

signal enable : std_logic := '0';


begin
    process is
        begin
            clk <= '0';
            wait for period / 2;
            clk <= '1';
            wait for period / 2;
        end process;

    process is
       
    begin
	b(3 downto 0) <= "1111";
	a(3 downto 0) <= "1001";
        wait for period;
 	--wait for period;

	enable <= '1';
 	wait for period;
 	wait for period;
 	wait for period;
 	wait for period;
 	wait for period;
 	wait for period;
 	wait for period;
 	wait for period;
        assert  p = "00000000000000000000000010000111";
      
    end process;

    gen_m_booth: ModifiedBoothMultiplier 
        port map(
            a,b,enable,p,clk
        );
end Test;
