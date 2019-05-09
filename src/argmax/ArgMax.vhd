library ieee;
use ieee.std_logic_1164.all;
library dcnn;
use dcnn.config.all;

--Get the arg max of the values formed at the final layer in the FC
entity ArgMax is
	port (
		inp: in std_logic_vector(n_word-1 downto 0) := (others => '0'); --New input to compare against previous max
		idx: in std_logic_vector(3 downto 0)   := (others => '0'); --Index of the new input
		en : in std_logic := '0'; --enable signal
		clk: in std_logic;        --Clk, falling edge
		rst: in std_logic := '0'; --reset = 1 at first and then 0 otherwise
		ans: out std_logic_vector(3 downto 0) := (others => '0')  --Has the answer at all times
	);
end entity ArgMax;

architecture DataFlow of ArgMax is
	constant N : integer := n_word;
	signal out_val         : std_logic_vector(N-1 downto 0);
	signal out_idx         : std_logic_vector(3 downto 0);
	signal reg_val_out     : std_logic_vector(N-1 downto 0);
	signal reg_idx_out     : std_logic_vector(3 downto 0);
	signal tmp		       : std_logic_vector(N-1 downto 0);
	signal tmp_idx		   : std_logic_vector(3 downto 0);

begin
	tmp <= (N-1 => '1', others => '0');
	tmp_idx <= (others => '0');
	valReg: entity dcnn.Reg_16 port map(out_val, reg_val_out, tmp, clk, en, rst);
	idxReg: entity dcnn.Reg_4 port map(out_idx, reg_idx_out, tmp_idx, clk, en, rst); 
	
	compare: entity dcnn.Comparator 
		 port map(reg_val_out, inp, reg_idx_out, idx, en, out_val, out_idx);
	
	ans <= out_idx;
end architecture DataFlow;
