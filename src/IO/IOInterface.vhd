LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY IOInterface IS
	PORT(
		i_clk	:	IN	std_logic;
		i_rst	:	IN	std_logic;
		i_int	:	IN	std_logic;
		i_load	:	IN	std_logic;
		i_data	:	IN	std_logic_vector(15 downto 0);
		o_data	:	OUT	std_logic_vector(15 downto 0)
	);
END ENTITY;

ARCHITECTURE behavioral OF IOInterface IS

COMPONENT nReg IS
GENERIC (n	:	integer:=16);
	PORT (
		input		:	IN	std_logic_vector(n-1 downto 0);
		en,rst,clk	:	IN	std_logic;
		output		:	OUT	std_logic_vector(n-1 downto 0));
END COMPONENT;

SIGNAL enReg	:	std_logic;

BEGIN

	packetReg:	nReg GENERIC MAP(16) PORT MAP(i_data, enReg, i_rst, i_clk, o_data);
	enReg <= i_int and i_load;

END ARCHITECTURE;
