LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY mux2x1 IS
	Generic (n:integer:=16);
	Port(in0,in1: in std_logic_vector(n-1 downto 0);
		sel : in std_logic;
		out1 : out std_logic_vector(n-1 downto 0));
end entity mux2x1;

Architecture mux2x1Arch of mux2x1 is

begin

out1 <= in0 when sel = '0' 
else in1 when sel = '1';

end Architecture;

