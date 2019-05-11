--Design of IO Control

--Implemented as a Moore machine (input function of state)

--using three processes, the first combinational for next state calculation, the second clocked
--for current state update and the third combinational for output calculation.

--set initial address of CNN
--try to buffer i_clk to addresses counters if a delay is needed

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY IOController IS
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

END ENTITY;

ARCHITECTURE behavioral	OF IOController IS

COMPONENT upCounter	IS

GENERIC(n	:	integer:=8);

	PORT(
		i_clk	:	IN	std_logic;	--internal clock is chip, if we decide to have one
		i_rst	:	IN	std_logic;	--reset signal sent from controller
		i_en	:	IN	std_logic;	--enable for counter
		o_cnt	:	OUT	std_logic_vector(n-1 downto 0)	--current count
	);
END COMPONENT;

TYPE state_type IS (s_init, s_waitO, s_deImg, s_deCNN, s_process, s_waitRI, s_waitRC , s_waitRL, s_sendR);	--defining states
--s_init	initialization state, to initialize addresses and registers
--s_waitO	wait for CPU to send packet or command, sends ready signal ready to CPU to indicate that it's ready
--s_deImg	send signals to inform Image decompression HW that a packet is ready to decompress
--s_deCNN	send signals to inform CNN decompression HW that a packet is ready to decompress
--s_process	send process signal to Accelerator Logic to start working
--s_waitRI	wait for Image decompression HW to finish packet
--s_waitRC	wait for CNN decompression HW to finish packet
--s_waitRL	wait for Accelerator Logic HW to finish processing
--s_sendR	atate to send result to CPU

SIGNAL t_currentState	:	state_type;	--current state
SIGNAL t_nextState	:	state_type;	--next state
SIGNAL enAddCntrCNN	:	std_logic;	--enable for CNN address counter
SIGNAL enAddCntrImg	:	std_logic;	--enable for image address counter
SIGNAL imgAddLines	:	std_logic_vector(9 downto 0);
SIGNAL CNNAddLines	:	std_logic_vector(9 downto 0);

BEGIN

	imgAddCntr:	upCounter GENERIC MAP(10) PORT MAP(i_clk, i_rst, enAddCntrImg, imgAddLines(9 downto 0)); --assuming image 		size does not exceed 1024 byte i.e 32X32 pixel
	
	CNNAddCntr:	upCounter GENERIC MAP(10) PORT MAP(i_clk, i_rst, enAddCntrCNN, CNNAddLines(9 downto 0));

	PROCESS(t_currentState, i_int, i_decompI, i_decompC, i_processDone, i_op, i_dtype)
	BEGIN
		CASE t_currentState IS
			WHEN s_init =>
				IF(i_rst = '0')	THEN
					t_nextState <= s_waitO;

			WHEN s_waitO =>
				IF(i_int = '1' and i_op = '1' and i_dtype = '1')	THEN
					t_nextState <= s_deImg;

				ELSIF(i_int = '1' and i_op = '1' and i_dtype ='0')	THEN
					t_nextState <= s_deCNN;

				ELSIF(i_int = '1' and i_op = '0')	THEN
					t_nextState <= s_process;

				ELSE
					t_nextState <= t_currentState;
				END IF;

			WHEN s_deImg =>
				IF(i_rst = '0')	THEN
					t_nextState <= s_waitRI;

			WHEN s_deCNN =>
				IF(i_rst = '0')	THEN
					t_nextState <= s_waitRC;

			WHEN s_process =>
				IF(i_rst = '0')	THEN
					t_nextState <= s_waitRL;

			WHEN s_waitRI =>
				IF(i_decompI = '1')	THEN
					t_nextState <= s_waitO;
			
				ELSE
					t_nextState <= t_currentState;
				END IF;

			WHEN s_waitRC =>
				IF(i_decompC = '1')	THEN
					t_nextState <= s_waitO;

				ELSE
					t_nextState <= t_currentState;
				END IF;

			WHEN s_waitRL =>
				IF(i_processDone = '1')	THEN
					t_nextState <= s_sendR;

				ELSE
					t_nextState <= t_currentState;
				END IF;

			WHEN s_sendR =>
				IF(i_rst = '0')	THEN
					t_nextState <= s_waitO;
		END CASE;
	END PROCESS;

	PROCESS(i_clk, i_rst)
	BEGIN
		IF(i_rst = '1')	THEN
			t_currentState <= s_init;

		ELSIF rising_edge(i_clk)	THEN
			t_currentState <= t_nextState;
		END IF;
	END PROCESS;
	
	PROCESS(t_currentState, i_wordI, I_wordC, imgAddLines, CNNAddLines)
	BEGIN
		CASE t_currentState IS
			WHEN s_init =>
				o_address <= x"0000";
				o_ready <= '0';
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_process <= '0';
				o_done <= '0';
				o_readMem <= '0';
					
			WHEN s_waitO =>
				o_ready <= '1';

				o_address <= x"0000";
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_process <= '0';
				o_done <= '0';
				o_readMem <= '0';

			WHEN s_deImg =>
				o_loadDecompImg <= '1';

				o_address <= x"0000";
				o_ready <= '0';
				o_loadDecompCNN <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_process <= '0';
				o_done <= '0';
				o_readMem <= '0';

			WHEN s_deCNN =>
				o_loadDecompCNN <= '1';

				o_address <= x"0000";
				o_ready <= '0';
				o_loadDecompImg <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_process <= '0';
				o_done <= '0';
				o_readMem <= '0';

			WHEN s_process =>
				o_process <= '1';

				o_address <= x"FFFF";
				o_ready <= '0';
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_done <= '0';
				o_readMem <= '0';
		
			WHEN s_waitRI =>
				IF(i_wordI = '1')	THEN
					o_writeMem <= '1';
					enAddCntrImg <= '1';

				ELSE
					o_writeMem <= '0';
					enAddCntrImg <= '0';
				END IF;

				o_address(15 downto 10) <= "000000";
				o_address(9 downto 0) <= imgAddLines;

				o_ready <= '0';
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				enAddCntrCNN <= '0';
				o_process <= '0';
				o_done <= '0';
				o_readMem <= '0';
	
			WHEN s_waitRC =>
				IF(i_wordC = '1')	THEN
					o_writeMem <= '1';
					enAddCntrCNN <= '1';

				ELSE
					o_writeMem <= '0';
					enAddCntrCNN <= '0';
				END IF;

				o_address(15 downto 10) <= "000001";
				o_address(9 downto 0) <= CNNAddLines;

				o_ready <= '0';	
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				enAddCntrImg <= '0';
				o_process <= '0';
				o_done <= '0';
				o_readMem <= '0';

			WHEN s_waitRL =>
				o_address <= x"FFFF";
				o_process <= '1';

				o_ready <= '0';
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_done <= '0';
				o_readMem <= '0';

			WHEN s_sendR =>
				o_done <= '1';
				o_readMem <= '1';
				o_address <= x"FFFF";

				o_ready <= '0';
				o_loadDecompImg <= '0';
				o_loadDecompCNN <= '0';
				o_writeMem <= '0';
				enAddCntrImg <= '0';
				enAddCntrCNN <= '0';
				o_process <= '0';
		END CASE;
	END PROCESS;
END ARCHITECTURE;
