library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


------------------------------------------------------------------------------------
-- BoothMultiplier entity is an implementation of standard Booth Algoirthm.
-- Takes 16 cycles to calculate product.
-- Does not preserve product after 16 cycles.
------------------------------------------------------------------------------------
entity BoothMultiplier is 
	port(
		M         : in signed(15 downto 0);-- First operand
		R        : in signed(15 downto 0);-- Second operand
		cnt_enable : in std_logic;-- enable from counter
		Product     : out signed(31 downto 0);-- Final product
		clk : in std_logic -- clock
	);
end entity BoothMultiplier;

architecture BoothMultiplierWorkFlow of BoothMultiplier is 



signal A:  signed(32 downto 0);
signal S:  signed(32 downto 0);
signal P:  signed(32 downto 0);

begin
process (clk)
begin
	if( rising_edge(clk) ) then
		-- A,P,S values setup
		if (cnt_enable = '0') then
			A(32 downto 17) <= M ;
			A(16 downto 0) <= (OTHERS=>'0') ;

			S(32 downto 17) <= -M(15 downto 0 ) ;
			S(16 downto 0) <= (OTHERS=>'0') ;

			P(16 downto 0) <= R&'0'  ;
			P(32 downto 17) <= (OTHERS=>'0') ;

		else
			--Loop N iterations when counter is enabled
			if( P(1 downto 0) = "01" ) then
				P <= shift_right(P+A,1) ;--P+A 
			else

				if( P(1 downto 0) = "10" ) then
					P <=  shift_right(P+S,1) ;--P+S 
				else
					P <= shift_right(P,1);-- Arithemtic Shift Right
				end if;

			end if;

  	end if;

		Product <= P(32 downto 1);
	
  end if;
end process;

end architecture BoothMultiplierWorkFlow;