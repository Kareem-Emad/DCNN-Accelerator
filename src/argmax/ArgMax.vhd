library ieee;
use ieee.std_logic_1164.all;

--Get the arg max of the values formed at the final layer in the FC
entity ArgMax is
	generic( N: natural := 16); --Input size 

	port(
		inp: in std_logic_vector(N-1 downto 0) := (others => '0'); --New input to compare against previous max
		idx: in std_logic_vector(3 downto 0)   := (others => '0'); --Index of the new input
		en : in std_logic := '0'; --enable signal
		clk: in std_logic;        --Clk, falling edge
		rst: in std_logic := '0'; --reset = 1 at first and then 0 otherwise
		ans: out std_logic_vector(3 downto 0) := (others => 'Z')  --Has the answer at all times
	);
end entity ArgMax;

architecture DataFlow of ArgMax is
	component Comparator
		generic(N: natural := 16); --Input size
		
		port(
			in0  : in std_logic_vector(N-1 downto 0);       --First operand
			in1  : in std_logic_vector(N-1 downto 0);       --Second operand
			idx0 : in std_logic_vector(3 downto 0);         --Index of the first operand
			idx1 : in std_logic_vector(3 downto 0);         --Index of the second operand
			en   : in std_logic := '0';                     --Enable signal
			otVal: out std_logic_vector(N-1 downto 0);      --Output = max(in0, in1)
			otIdx: out std_logic_vector(3 downto 0) --Output = idx of max(in0, in1)
		);
	end component Comparator;

	component Reg is
    		generic(n : natural := 16); -- number of bits

    		port(
        		d  : in std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel input
        		q  : out std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel output
			rst_data: std_logic_vector(n-1 downto 0) := (others => '0'); -- data to reset to
        		clk, load, reset : in std_logic := '0' -- clock, load, and reset
    		);
	end component Reg;
	
	signal out_val         : std_logic_vector(N-1 downto 0);
	signal out_idx         : std_logic_vector(3 downto 0);
	signal reg_val_out     : std_logic_vector(N-1 downto 0);
	signal reg_idx_out     : std_logic_vector(3 downto 0);
	
begin
	valReg: Reg generic map(N) port map(out_val, reg_val_out, (N-1 => '1', others => '0'), clk, en, rst);
	idxReg: Reg generic map(4) port map(out_idx, reg_idx_out, (others => '0'), clk, en, rst); 
	
	compare: Comparator generic map(N) 
		 port map(reg_val_out, inp, reg_idx_out, idx, en, out_val, out_idx);
	
	ans <= out_idx;
end architecture DataFlow;
