library ieee;
use ieee.std_logic_1164.all;

--Adds 2 n bit signed operands
entity NAdder is
	generic(N : natural := 16); --Generic input to specifiy the Adder's size

	port(
		a   : in std_logic_vector(N-1 downto 0);   --First operand 
		b   : in std_logic_vector(N-1 downto 0);   --Second operand
		cin : in std_logic := '0';                 --Carry in bit (default = 0)
		en  : in std_logic := '0';                 --Enable signal
		s   : out std_logic_vector(N-1 downto 0);  --Sum (a+b)
		cout: out std_logic                        --Carry out bit
	);
end entity NAdder;

architecture DataFlow of NAdder is
	component BitAdder
		port(
			a   : in std_logic;             --First operand
			b   : in std_logic;             --Second operand
			cin : in std_logic := '0';      --Carry in bit (default value = 0)
			en  : in std_logic := '0';      --Enable signal
			s   : out std_logic;            --Sum (a+b)
			cout: out std_logic             --Carry out bit
		);
	end component BitAdder;
	
	component TriState
		generic(N : natural := 16); --Generic input to specifiy the input size

		port(
			inp: in std_logic_vector(N-1 downto 0);  --Input signal
			en : in std_logic := '0';                --Buffer enable
			ot : out std_logic_vector(N-1 downto 0)  --Output signal
		);
	end component TriState;
	
	--Stores the carry out of every addition (rippled carry)
	signal carries: std_logic_vector(N downto 0);
	
	--Temporarily holds the summation output
	signal tmp_s: std_logic_vector(N-1 downto 0);
	
	--Temporarily holds the carry out bit
	signal tmp_cout_in : std_logic_vector(0 downto 0);
	signal tmp_cout_out: std_logic_vector(0 downto 0);

begin
	carries(0) <= cin;  --Place the carry in as the first in the carry group
	
	--Adding n bit numbers using the carry propagation method
	AdditionLoop: for i in 0 to 15 generate
		AdditionStep: BitAdder port map(a(i), b(i), carries(i), en, tmp_s(i), carries(i+1));
	end generate;  
	
	--Assigning the sum based on the enable signal
	ActivateSum: TriState generic map(N) port map(tmp_s, en, S);
	
	--Assigning the carry out based on the enable signal
	tmp_cout_in(0) <= carries(16);
	ActiviateCout: TriState generic map(1) port map(tmp_cout_in, en, tmp_cout_out);
	cout <= tmp_cout_out(0);
	
end architecture DataFlow;
