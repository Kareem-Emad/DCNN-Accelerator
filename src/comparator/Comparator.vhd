library ieee;
use ieee.std_logic_1164.all;
library dcnn;
use dcnn.config.all;

--Compares 2 n bit signed operands and outputs the index of max along with the max
entity Comparator is		
	port(
		in0  : in std_logic_vector(n_word-1 downto 0);       --First operand
		in1  : in std_logic_vector(n_word-1 downto 0);       --Second operand
		idx0 : in std_logic_vector(3 downto 0);         --Index of the first operand
		idx1 : in std_logic_vector(3 downto 0);         --Index of the second operand
		en   : in std_logic := '0';                     --Enable signal
		otVal: out std_logic_vector(n_word-1 downto 0);      --Output = max(in0, in1)
		otIdx: out std_logic_vector(3 downto 0) --Output = idx of max(in0, in1)
	);
end entity Comparator;

architecture DataFlow of Comparator is
	constant N : integer := n_word;
	--Holds the 1's complement of in1
	signal in1_inverted: std_logic_vector(N-1 downto 0);
	
	--Holds the output of the subtraction step
	signal sub_res: std_logic_vector(N-1 downto 0);
	
	--Holds the carry out of the subtraction step [sign indicator]
	signal carry_out: std_logic;
	
	--Temporarily holds the output of the value MUX
	signal tmp_ot_mux_val: std_logic_vector(N-1 downto 0);
	
	--Temporarily holds the output of the index MUX
	signal tmp_ot_mux_idx: std_logic_vector(3 downto 0);

	--Temporary result (val) [Checks in case comparing +ve and -ve resulted in an overflow]
	signal tmp_ot_val: std_logic_vector(N-1 downto 0);

	--Temporary result (idx) [Checks in case comparing +ve and -ve resulted in an overflow]
	signal tmp_ot_idx: std_logic_vector(3 downto 0);

begin
	--Get the 1's complement of in1
	in1_inverted <= not(in1);
	
	--Perform the addition F = in0 + 1's comp(in1) + cin = in0 - in1` + 1 [Subtraction]
	DoSubtraction: entity dcnn.NAdder port map(in0, in1_inverted, '1', sub_res, carry_out);

	--Select max(in0, in1) based on the sign bit
	--If sign bit = 0, sub_res is +ve and in0>=in1
	--Else, sub_res is -ve and in1>in0
	SelectGreater: entity dcnn.NMUX port map(in0, in1, sub_res(N-1), en, tmp_ot_mux_val);
	SelectIndex  : entity dcnn.NMUX_4 port map(idx0, idx1, sub_res(N-1), en, tmp_ot_mux_idx); 

	--Checks if operands have opposite signs. In this case the +ve is automatically greater.
	--This check is important in case subtraction opposite sign operands results in overflow.
	tmp_ot_val <= in0 when in0(N-1) = '0' and in1(N-1) = '1'
	else in1 when in1(N-1) = '0' and in0(N-1) = '1'
	else tmp_ot_mux_val;

	tmp_ot_idx <= idx0 when in0(N-1) = '0' and in1(N-1) = '1'
	else idx1 when in1(N-1) = '0' and in0(N-1) = '1'
	else tmp_ot_mux_idx;
	
	--Assign the value of the comparison result based on the enable signal
	otVal <= tmp_ot_val;

	--Assign the index of the comparison result based on the enable signal
	otIdx <= tmp_ot_idx;
	
end architecture DataFlow;