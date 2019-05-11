LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY IO IS
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
END ENTITY IO;

ARCHITECTURE struct OF IO IS
COMPONENT IOInterface IS
	PORT(
		i_clk	:	IN	std_logic;
		i_rst	:	IN	std_logic;
		i_int	:	IN	std_logic;
		i_load	:	IN	std_logic;
		i_data	:	IN	std_logic_vector(15 downto 0);
		o_data	:	OUT	std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT IOController IS
GENERIC(n	:	integer	:=	16);
	PORT(
		i_clk		:	IN	std_logic;	--clock sent by CPU
		i_rst		:	IN	std_logic;	--reset signal sent by CPU, to initialize chip
		i_int		:	IN	std_logic;	--interrupt signal sent by CPU, informs the chip that a command is sent
		i_op		:	IN	std_logic;	--signal to determine type of operation, '0' = process and '1' = load
		i_dtype		:	IN	std_logic;	--signal to specify data type if sent operation was load, '0' = CNN and '1' = Img
		i_decompI	:	IN	std_logic;	--signal sent from Image decompression, to indicate decompression finished
		i_wordI		:	IN	std_logic;	--signal sent from Image decompression, to indicate a word is ready
		i_decompC	:	IN	std_logic;	--signal sent from CNN decompression, to indicate decompression finished
		i_wordC		:	IN	std_logic;	--signal sent from CNN decompression, to indicate a word is ready
		i_processDone	:	IN	std_logic;	--signal sent from CNN logic, result is ready
		o_ready		:	OUT	std_logic;	--signal sent by chip, to inform CPU that chip is ready to receive
		o_loadDecompImg	:	OUT	std_logic;	--signal to load packet to decompression counters of Image
		o_loadDecompCNN	:	OUT	std_logic;	--signal to load packet to decompression counters of CNN
		o_writeMem	:	OUT	std_logic;	--signal write sent to memory
		o_readMem	:	OUT	std_logic;	--signal read sent to memory
		o_process	:	OUT	std_logic;	--signal to CNN logic to process data
		o_done		:	OUT	std_logic;	--signal sent by chip, when it finishes processing
		o_address	:	OUT	std_logic_vector(15 downto 0)	--address to write to
		);

END COMPONENT;

COMPONENT DecompressImage IS
    PORT(
		clk		:	IN	std_logic;
		rst		:	IN	std_logic;
		din		:	IN	std_logic_vector(15 downto 0);
		proces		:	IN	std_logic;
		decompressed	:	OUT	std_logic;
		word		:	OUT	std_logic;
		dataOut		:	OUT	std_logic_vector(15 downto 0)
	);
END COMPONENT;

COMPONENT JDecomp IS 
	PORT(
		clk		:	IN	std_logic;
		en		:	IN	std_logic;
		rst		:	IN	std_logic;
		recPack		:	IN	std_logic_vector(15 downto 0);
		wordDone	:	OUT	std_logic;
		packetDone	:	OUT	std_logic;
		decompWord	:	OUT	std_logic_vector(15 downto 0));


END COMPONENT;

SIGNAL doneImgCntrl	:	std_logic;
SIGNAL wordImgCntrl	:	std_logic;
SIGNAL doneCNNCntrl	:	std_logic;
SIGNAL wordCNNCntrl	:	std_logic;
SIGNAL decompCntrlImg	:	std_logic;
SIGNAL decompCntrlCNN	:	std_logic;
SIGNAL writeMemCntrlMem	:	std_logic;
SIGNAL readMemCntrlMem	:	std_logic;
SIGNAL wordMemDecomp	:	std_logic_vector(15 downto 0);
SIGNAL addCntrlMem	:	std_logic_vector(15 downto 0);
SIGNAL dataIOIntrDecomp	:	std_logic_vector(15 downto 0);
SIGNAL wordImgMux	:	std_logic_vector(15 downto 0);
SIGNAL wordCNNMux	:	std_logic_vector(15 downto 0);

BEGIN

	IOContU:	IOController GENERIC MAP(16) PORT MAP(clk, rst, interrupt, loadProcess, CNNImage, doneImgCntrl, wordImgCntrl,
								doneCNNCntrl, wordCNNCntrl, processDone, ready, decompCntrlImg, decompCntrlCNN,
								writeMemCntrlMem, readMemCntrlMem, processCntrlAccL, done, addCntrlMem);

	IOInterU:	IOInterface PORT MAP(clk, rst, interrupt, loadProcess, din, dataIOIntrDecomp);
	
	ImgDecompU:	DecompressImage PORT MAP(clk, rst, dataIOIntrDecomp, decompCntrlImg, doneImgCntrl, wordImgCntrl, wordImgMux);

	JsonDecompU:	JDecomp PORT MAP(clk, decompCntrlCNN, rst, dataIOIntrDecomp, wordCNNCntrl, doneCNNCntrl, wordCNNMux);
	
--	loop1:	FOR i IN 0 TO 15 GENERATE
--			mux4X1U:	mux4X1 PORT MAP(wordImgMux(i), wordCNNMux(i), '0', '0', selDataMux(0), selDataMux(1), wordMemDecomp(i));
--		END GENERATE;
--
--	selDataMux <= "00"	WHEN doneImgCntrl = '1'
--	ELSE "01"		WHEN doneCNNCntrl = '1'
--	ELSE "10"		WHEN doneImgCntrl = '0'		--dummy condition to reserve choice
--	ELSE "11"		WHEN doneCNNCntrl = '0';	--dummy condition to reserve choice

	wordToMem <= wordImgMux	WHEN wordImgCntrl = '1'
	ELSE wordCNNMux			WHEN wordCNNCntrl = '1'
	ELSE x"0000";

	memWE <= writeMemCntrlMem;
	memRE <= readMemCntrlMem;
	addToMem <= addCntrlMem;

END ARCHITECTURE;
