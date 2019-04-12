library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use dcnn.config.all;

entity FilterWindow is
	port(
		d : in word_t;
		q : out wordarr_t(0 to 24);
		clk : in std_logic := '0';
		load : in std_logic := '0';
		reset : in std_logic := '0'
	);
end FilterWindow;

architecture Structural of FilterWindow is
begin
	queuei : entity dcnn.Queue
        generic map(25)
        port map(
            d => d,
            q => q,
            clk => clk,
            load => load,
            reset => reset
        );
end Structural;
