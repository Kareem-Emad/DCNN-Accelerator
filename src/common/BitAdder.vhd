library ieee;
use ieee.std_logic_1164.all;

--Addes two bits
entity BitAdder is
	port(
		a   : in std_logic;             --First operand
		b   : in std_logic;             --Second operand
		cin : in std_logic := '0';      --Carry in bit(default value = 0)
		s   : out std_logic;            --Sum (a+b)
		cout: out std_logic             --Carry out bit
	);
end entity BitAdder;

architecture DataFlow of BitAdder is
	--NOTE: I am using std_logic_vector(0 down to 0) to avoid type mismatch
	--      between std_logic and std_logic_vector

	--A temporary signal to hold the sum value
	signal tmp_sum : std_logic_vector(0 downto 0);

	--A temporary signal to hold the carry out
	signal tmp_cout : std_logic_vector(0 downto 0);

begin
	tmp_sum(0)  <= a XOR b XOR cin;  
	tmp_cout(0) <= (a AND b) OR (cin AND (a XOR b));
	
	--Assign sum based on the enable signal
	s <= tmp_sum(0);

	--Assign carry out based on the enable signal
	cout <= tmp_cout(0);
end architecture DataFlow;
