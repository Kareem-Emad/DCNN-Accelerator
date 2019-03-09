library ieee;
use ieee.std_logic_1164.all;

--Compares 2 n bit signed operands
entity NComparator is
	generic(N : natural := 16); --Generic input to specifiy the input size
	
	port(
		in0 : in std_logic_vector(N-1 downto 0);  --First operand
		in1 : in std_logic_vector(N-1 downto 0);  --Second operand
		en  : in std_logic := '0';                --Enable signal
		ot  : out std_logic_vector(N-1 downto 0)  --Output = max(in0, in1)
	);
end entity NComparator;

architecture DataFlow of NComparator is
	component NAdder
		generic(N : natural := 16); --Generic input to specifiy the Adder's size

		port(
			a   : in std_logic_vector(N-1 downto 0);   --First operand 
			b   : in std_logic_vector(N-1 downto 0);   --Second operand
			cin : in std_logic := '0';                 --Carry in bit (default = 0)
			en  : in std_logic := '0';                 --Enable signal
			s   : out std_logic_vector(N-1 downto 0);  --Sum (a+b)
			cout: out std_logic                        --Carry out bit
		);
	end component NAdder;

	component NMUX
		generic(N : natural := 16); --Generic input to specifiy the MUX's size
	
		port(
			in0: in std_logic_vector(N-1 downto 0);  --First input
			in1: in std_logic_vector(N-1 downto 0);  --Second input
			sel: in std_logic;                       --Selector bit
			en : in std_logic := '0';                --Enable bit
			ot : out std_logic_vector(N-1 downto 0)  --Output(Chosen value)
		);
	end component NMUX;
	
	component TriState
		generic(N : natural := 16); --Generic input to specifiy the input size

		port(
			inp: in std_logic_vector(N-1 downto 0);  --Input signal
			en : in std_logic := '0';                --Buffer enable
			ot : out std_logic_vector(N-1 downto 0)  --Output signal
		);
	end component TriState;

	--Holds the 1's complement of in1
	signal in1_inverted: std_logic_vector(N-1 downto 0);
	
	--Holds the output of the subtraction step
	signal sub_res: std_logic_vector(N-1 downto 0);
	
	--Holds the carry out of the subtraction step [sign indicator]
	signal carry_out: std_logic;
	
	--Temporarily holds the output of the MUX
	signal tmp_ot_mux: std_logic_vector(N-1 downto 0);
	
	--Temporary result [Checks in case comparing +ve and -ve resulted in an overflow]
	signal tmp_ot: std_logic_vector(N-1 downto 0);

begin
	--Get the 1's complement of in1
	in1_inverted <= not(in1);
	
	--Perform the addition F = in0 + 1's comp(in1) + cin = in0 - in1` + 1 [Subtraction]
	DoSubtraction: NAdder generic map(N) port map(in0, in1_inverted, '1', en, sub_res, carry_out);

	--Select max(in0, in1) based on the sign bit
	--If sign bit = 0, sub_res is +ve and in0>=in1
	--Else, sub_res is -ve and in1>in0
	SelectGreater: NMUX generic map(N) port map(in0, in1, sub_res(N-1), en, tmp_ot_mux);
	
	--Checks if operands have opposite signs. In this case the +ve is automatically greater.
	--This check is important in case subtraction opposite sign operands results in overflow.
	tmp_ot <= in0 when in0(N-1) = '0' and in1(N-1) = '1'
	else in1 when in1(N-1) = '0' and in0(N-1) = '1'
	else tmp_ot_mux;
	
	--Assign the comparasion result based on the enable signal
	ActivateOut: TriState generic map(N) port map(tmp_ot, en, ot);
end architecture DataFlow;
