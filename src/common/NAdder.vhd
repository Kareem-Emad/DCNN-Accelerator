library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use dcnn.config.all;

--Adds 2 n bit signed operands
entity NAdder is
	port(
		a   : in std_logic_vector(n_word-1 downto 0);   --First operand 
		b   : in std_logic_vector(n_word-1 downto 0);   --Second operand
		cin : in std_logic := '0';                 --Carry in bit (default = 0)
		s   : out std_logic_vector(n_word-1 downto 0);  --Sum (a+b)
		cout: out std_logic                        --Carry out bit
	);
end entity NAdder;

architecture DataFlow of NAdder is
	constant N : natural := n_word;
	component BitAdder
		port(
			a   : in std_logic;             --First operand
			b   : in std_logic;             --Second operand
			cin : in std_logic := '0';      --Carry in bit (default value = 0)
			s   : out std_logic;            --Sum (a+b)
			cout: out std_logic             --Carry out bit
		);
	end component BitAdder;
	
	--Stores the carry out of every addition (rippled carry)
	signal carries: std_logic_vector(N downto 0);
	
	--Temporarily holds the summation output
	signal tmp_s: std_logic_vector(N-1 downto 0);
	
	--Temporarily holds the carry out bit
	signal tmp_cout : std_logic_vector(0 downto 0);

begin
	carries(0) <= cin;  --Place the carry in as the first in the carry group
	
	--Adding n bit numbers using the carry propagation method
	AdditionLoop: for i in 0 to 15 generate
		AdditionStep: BitAdder port map(a(i), b(i), carries(i), tmp_s(i), carries(i+1));
	end generate;  
	
	s <= tmp_s;
	tmp_cout(0) <= carries(16);
	cout <= tmp_cout(0);
	
end architecture DataFlow;
