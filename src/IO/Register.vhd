LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY nReg IS
	Generic (n:integer:=16);
	PORT (input: IN  std_logic_vector(n-1 downto 0);
		en,rst,clk : IN std_logic;
		output :out std_logic_vector(n-1 downto 0));
END ENTITY nReg;



Architecture nRegArch of nReg is

begin


process (rst,clk) 
begin
if (rst='1') then
	output<= (others =>'0');
elsif (clk'event and clk='1') then 
	if (en='1') then
		output<=input;
	end if ;
end if;
end process;
 

end Architecture;
