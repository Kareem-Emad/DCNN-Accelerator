LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux4X1 IS
	PORT(
		i_op0	:	IN	std_logic;
		i_op1	:	IN	std_logic;
		i_op2	:	IN	std_logic;
		i_op3	:	IN	std_logic;
		i_sel0	:	IN	std_logic;
		i_sel1	:	IN	std_logic;
		o_out	:	OUT	std_logic
	);
END ENTITY;

ARCHITECTURE behavioral OF mux4X1 IS
BEGIN
	o_out <= i_op0	WHEN (i_sel0 = '0' and i_sel1 = '0')
	ELSE i_op1	WHEN (i_sel0 = '1' and i_sel1 = '0')
	ELSE i_op2	WHEN (i_sel0 = '0' and i_sel1 = '1')
	ELSE i_op3	WHEN (i_sel0 = '1' and i_sel1 = '1');
END ARCHITECTURE;