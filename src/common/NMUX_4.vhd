library ieee;
use ieee.std_logic_1164.all;
library dcnn;
use dcnn.config.all;

--Multiplexes 2 n bit operands
entity NMUX_4 is
	port(
		in0: in std_logic_vector(4-1 downto 0);  --First input
		in1: in std_logic_vector(4-1 downto 0);  --Second input
		sel: in std_logic;                       --Selector bit
		en : in std_logic := '0';                --Enable bit
		ot : out std_logic_vector(4-1 downto 0)  --Output(Chosen value)
	);
end entity NMUX_4;

architecture DataFlow of NMUX_4 is
	--Signal to temporarily hold the multiplexed output
	signal multiplexed_out: std_logic_vector(4-1 downto 0);

begin
	--Determine the value of the multiplexed output
	multiplexed_out <= in0 when sel = '0'
	else in1;
	ot <= multiplexed_out;
end architecture DataFlow;
