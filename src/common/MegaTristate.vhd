library ieee;
use ieee.std_logic_1164.all;
library dcnn;
use dcnn.config.all;

--Tri-states an n bit output based on the enable signal
entity MegaTristate is 
	port(
		inp: in wordarr_t(0 to 24);  --Input signal
		en : in std_logic := '0';                --Buffer enable
		ot : out wordarr_t(0 to 24)  --Output signal
	);
end entity MegaTristate;

architecture DataFlow of MegaTristate is
begin
	ot <= inp when en = '1'
		else (others => (others => 'Z'));
end architecture DataFlow;
