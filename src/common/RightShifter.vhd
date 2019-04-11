library ieee;
use ieee.std_logic_1164.all;

entity RightShifter is
	generic( N: natural := 16; amt: natural := 1); --Input size and amount to shift [assume valid amount] 
	
	port(
		inp: in std_logic_vector(N-1 downto 0) := (others => '0');  --Input to be shifted
		en : in std_logic := '0';                                   --enable
		ot : out std_logic_vector(N-1 downto 0) := (others => '0')  --Shifted output
	);	
end entity RightShifter;

architecture DataFlow of RightShifter is
	component TriState
		generic(N : natural := 16); --Generic input to specifiy the input size

		port(
			inp: in std_logic_vector(N-1 downto 0);  --Input signal
			en : in std_logic := '0';                --Buffer enable
			ot : out std_logic_vector(N-1 downto 0)  --Output signal
		);
	end component TriState;
	
	--Temporarily hold the output value
	signal tmp_ot : std_logic_vector(N-1 downto 0);
	signal padding: std_logic_vector(amt-1 downto 0) := (others => '0');
begin
	--Assume that a sane person provided the shifting amount [no error checking :V]
	tmp_ot <= inp(N-1) & padding & inp(N-2 downto amt);

	--Activiate the output based on the enable signal
	ActivateOutput: TriState generic map(N) port map(tmp_ot, en, ot);
	
end architecture DataFlow;
