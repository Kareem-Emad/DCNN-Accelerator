library ieee;
use ieee.std_logic_1164.all;

--Addes two bits
entity BitAdder is
	port(
		a   : in std_logic;             --First operand
		b   : in std_logic;             --Second operand
		cin : in std_logic := '0';      --Carry in bit(default value = 0)
		en  : in std_logic := '0';      --Enable signal(Disabled by default)
		s   : out std_logic;            --Sum (a+b)
		cout: out std_logic             --Carry out bit
	);
end entity BitAdder;

architecture DataFlow of BitAdder is
	component TriState
		generic(N : natural := 16); --Generic input to specifiy the input size

		port(
			inp: in std_logic_vector(N-1 downto 0);  --Input signal
			en : in std_logic := '0';                --Buffer enable
			ot : out std_logic_vector(N-1 downto 0)  --Output signal
		);
	end component TriState;
	
	--NOTE: I am using std_logic_vector(0 down to 0) to avoid type mismatch
	--      between std_logic and std_logic_vector

	--A temporary signal to hold the sum value
	signal tmp_sum_in : std_logic_vector(0 downto 0);
	signal tmp_sum_out: std_logic_vector(0 downto 0);

	--A temporary signal to hold the carry out
	signal tmp_cout_in : std_logic_vector(0 downto 0);
	signal tmp_cout_out: std_logic_vector(0 downto 0);

begin
	tmp_sum_in(0)  <= a XOR b XOR cin;  
	tmp_cout_in(0) <= (a AND b) OR (cin AND (a XOR b));
	
	--Assign sum based on the enable signal
	ActivateSum: TriState generic map(1) port map(tmp_sum_in, en, tmp_sum_out);
	s <= tmp_sum_out(0);

	--Assign carry out based on the enable signal
	ActivateCout: TriState generic map(1) port map(tmp_cout_in, en, tmp_cout_out);
	cout <= tmp_cout_out(0);
end architecture DataFlow;
