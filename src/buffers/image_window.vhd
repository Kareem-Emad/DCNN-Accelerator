library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- Layout of the image window:
-- d(0)	=>	q(0)	q(1)	q(2)	q(3)	q(4)
-- d(1)	=>	q(5)	q(6)	q(7)	q(8)	q(9)
-- d(2)	=>	q(10)	q(11)	q(12)	q(13)	q(14)
-- d(3)	=>	q(15)	q(16)	q(17)	q(18)	q(19)
-- d(4)	=>	q(20)	q(21)	q(22)	q(23)	q(24)
-------------------------------------------------------------------------------

entity ImageWindow is
	port(
		d : in wordarr_t(4 downto 0);
		q : out wordarr_t(25 downto 0);
		clk : in std_logic := '0';
		load : in std_logic := '0';
		reset : in std_logic := '0'
	);
end ImageWindow;

architecture Structural of ImageWindow is
begin
	gen_queues: for i in 0 to 4 generate
		queuei : entity dcnn.Queue
			generic map(5)
			port map(
				d => d(i),
				q => q(5*(i + 1)-1 downto 5*i),
				clk => clk,
				load => load,
				reset => reset
			);
	end generate gen_queues;
end Structural;
