--Design for generic counter

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_Unsigned.all;

ENTITY upCounter IS

GENERIC(n	:	integer);

	PORT(
		i_clk	:	IN	std_logic;	--internal clock is chip, if we decide to have one
		i_rst	:	IN	std_logic;	--reset signal sent from controller
		i_load	:	IN	std_logic;	--signal to load 'i_cnt' to counter
		i_cnt	:	IN	std_logic_vector(n-1 downto 0);	--input count to set
		o_cnt	:	OUT	std_logic_vector(n-1 downto 0)	--current count
		);

END ENTITY;

ARCHITECTURE behavioral OF upCounter IS

SIGNAL count	:	std_logic_vector(n-1 downto 0);

BEGIN
	process(i_clk, i_rst)
	BEGIN
		IF rising_edge(i_clk)	THEN
			IF(i_rst = '1')	THEN
				count <= x"0";

			ELSIF(i_rst = '0' and i_load = '1')	THEN
				count <= i_cnt;

			ELSE
				count <= count + x"1";

			END IF;
		END IF;
	END PROCESS;
	
	o_cnt <= count;

END ARCHITECTURE;