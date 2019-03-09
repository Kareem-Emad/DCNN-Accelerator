library ieee;
use ieee.std_logic_1164.all;

--Multiplexes 2 n bit operands
entity NMUX is
	generic(N : natural := 16); --Generic input to specifiy the MUX's size
	
	port(
		in0: in std_logic_vector(N-1 downto 0);  --First input
		in1: in std_logic_vector(N-1 downto 0);  --Second input
		sel: in std_logic;                       --Selector bit
		en : in std_logic := '0';                --Enable bit
		ot : out std_logic_vector(N-1 downto 0)  --Output(Chosen value)
	);
end entity NMUX;

architecture DataFlow of NMUX is
	component TriState
		generic(N : natural := 16); --Generic input to specifiy the input size

		port(
			inp: in std_logic_vector(N-1 downto 0);  --Input signal
			en : in std_logic := '0';                --Buffer enable
			ot : out std_logic_vector(N-1 downto 0)  --Output signal
		);
	end component TriState;
	
	--Signal to temporarily hold the multiplexed output
	signal multiplexed_out: std_logic_vector(N-1 downto 0);

begin
	--Determine the value of the multiplexed output
	multiplexed_out <= in0 when sel = '0'
	else in1;
	
	--Assign the output signal based on the enable value
	ActivateOutput: TriState generic map(N) port map(multiplexed_out, en, ot);
end architecture DataFlow;
