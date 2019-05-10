LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY accelerator IS
	PORT(
		i_clk		:	IN	std_logic;	--clock sent to chip
		i_rst		:	IN	std_logic;	--reset sent to chip
		i_interrupt	:	IN	std_logic;	--interrupt sent to chip
		i_loadProcess	:	IN	 std_logic;	--'0' = process, '1' = load
		i_CNNImage	:	IN	std_logic;	--'0' = CNN, '1' = image
		o_ready		:	OUT	std_logic;	--ready sent by chip to CPU
		o_done		:	OUT	std_logic;	--done sent to CPU
		i_din		:	IN	std_logic_vector(15 downto 0);	--Data packet sent from CPU
		o_dout		:	OUT	std_logic_vector(3 downto 0)	--Result sent to CPU
	);
END ENTITY;

ARCHITECTURE struct OF accelerator IS

COMPONENT IO IS
    PORT(
		--Interface with CPU
		clk		:	IN	std_logic;
		rst		:	IN	std_logic;
		interrupt	:	IN	std_logic;
		loadProcess	:	IN	 std_logic;
		CNNImage	:	IN	std_logic;
		ready		:	OUT	std_logic;
		done		:	OUT	std_logic;
		din		:	IN	std_logic_vector(15 downto 0);
		dout		:	OUT	std_logic_vector(3 downto 0);
		--Interface with accelerator
		processDone	:	IN	std_logic;
		processCntrlAccL:	OUT	std_logic;
		--Interface with memory
		memWE		:	OUT	std_logic;
		memRE		:	OUT	std_logic;
		addToMem	:	OUT	std_logic_vector(15 downto 0);
		wordToMem	:	OUT	std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT Ram IS
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(15 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END COMPONENT;

--SIGNALS for memory control
SIGNAL writeEnMem		:	std_logic;
SIGNAL readEnMem		:	std_logic;
SIGNAL memAddress		:	std_logic_vector(15 downto 0);
SIGNAL memWordWrite		:	std_logic_vector(15 downto 0);
SIGNAL memWordRead		:	std_logic_vector(15 downto 0);
--------------------------------------------------------------------------------------------------------

--AHMED
--SIGNALS to connect to accelerator
SIGNAL processDone	:	std_logic;	--signal sent when accelerator has finished
SIGNAL	processCntrlAccl:	std_logic;	--signal sent from IO to accelerator to start processing
--------------------------------------------------------------------------------------------------------

BEGIN

	ioU:	io PORT MAP(i_clk, i_rst, i_interrupt, i_loadProcess, i_CNNImage, o_ready, o_done, i_din, o_dout,
				processDone, processCntrlAccl, writeEnMem, readEnMem, memAddress, memWordWrite);

	mem:	ram PORT MAP(i_clk, writeEnMem, memAddress, memWordWrite, memWordRead);

END ARCHITECTURE;
--	ioU:	io PORT MAP(