library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity shiftReg is
port( 
	en,inp,clk,rst : in std_logic;
	myWord : out std_logic_vector(15 downto 0));
	
end shiftReg;


Architecture shReg of shiftReg is

signal initial_val : std_logic_vector(15 downto 0):= x"0000";

begin

process(clk,rst)

begin
	if(rst = '1') then
		initial_val <= (others =>'0');

	elsif(rising_edge(clk) ) then
		if(en = '1') then

			initial_val <=  initial_val(14 downto 0)& inp;
		end if;
	end if;
end process;

myWord <= initial_val;

end shReg;
