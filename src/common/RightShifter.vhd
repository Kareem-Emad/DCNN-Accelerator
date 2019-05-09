library ieee;
use ieee.std_logic_1164.all;
library dcnn;
use dcnn.config.all;

entity RightShifter is
	port(
		inp: in std_logic_vector(n_word-1 downto 0) := (others => '0');  --Input to be shifted
		en : in std_logic := '0';                                   --enable
		ot : out std_logic_vector(n_word-1 downto 0) := (others => '0')  --Shifted output
	);	
end entity RightShifter;

architecture DataFlow of RightShifter is
	constant N : integer := n_word;
	
	--Temporarily hold the output value
	signal tmp_ot : std_logic_vector(N-1 downto 0);
	signal padding: std_logic_vector(amt-1 downto 0) := (others => '0');
begin
	--Assume that a sane person provided the shifting amount [no error checking :V]
	tmp_ot <= inp(N-1) & padding & inp(N-2 downto amt);

	--Activiate the output based on the enable signal
	ot <= tmp_ot;
	
end architecture DataFlow;
