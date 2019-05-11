library ieee;
library dcnn;

use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity DCNNFullSystem is
    generic ( 
        N : natural := 16;
        M : natural := 16;
        WREG : natural := 5;
        HREG : natural := 16
    );
    port (
        clk : in std_logic;
        reset : in std_logic;

        -- Interface with the CPU
        interrupt	:	in	std_logic;
		loadProcess	:	in	 std_logic;
		CNNImage	:	in	std_logic;
		ready		:	out	std_logic;
		done		:	out	std_logic;
		din		    :	in	std_logic_vector(15 downto 0);
        dout		:	out	std_logic_vector(3 downto 0)
    );
end DCNNFullSystem;

architecture structural of DCNNFullSystem is
    -- Computation / IO interface
    signal computation_done, start_computation : std_logic;

    -- I/O / memory interface signals
    signal IO_mem_read, IO_mem_write : std_logic;
    signal IO_mem_address : std_logic_vector(M-1 downto 0);
    signal IO_data_into_mem : std_logic_vector(N-1 downto 0);

    -- Computation / memory interface signals
    signal comp_mem_read, comp_mem_write : std_logic;
    signal comp_mem_address : std_logic_vector(M-1 downto 0);
    signal comp_data_into_mem : std_logic_vector(N-1 downto 0);
    
    -- Memory signals
    signal mem_read, mem_write : std_logic;
    signal mem_address : std_logic_vector(N-1 downto 0);
    signal data_into_mem : std_logic_vector(N-1 downto 0);
    signal data_outof_mem : std_logic_vector(N-1 downto 0);
begin
    mem_read <= '1' when IO_mem_read = '1' else comp_mem_read;
    mem_write <= '1' when IO_mem_write = '1' else comp_mem_write;
    mem_address <= IO_mem_address when IO_mem_read = '1' or IO_mem_write = '1' else comp_mem_address;
    data_into_mem <= IO_data_into_mem when IO_mem_read = '1' or IO_mem_write = '1' else comp_data_into_mem;

    IO_inst : entity dcnn.IO
        port map (
            clk => clk,
            rst => reset,
            interrupt => interrupt,
            loadProcess => loadProcess,
            CNNImage => CNNImage,
            ready => ready,
            done => done,
            din => din,
            dout => dout,

            processDone => computation_done,
            processCntrlAccL => start_computation,

            memWE => IO_mem_write,
            memRE => IO_mem_read,
            addToMem => IO_mem_address,
            wordToMem => IO_data_into_mem
        );
    
    DCNNChip_inst : entity dcnn.DCNNChip
        generic map ( N => N, M => M, WREG => WREG, HREG => HREG )
        port map (
            clk => clk,
            reset => reset,

            io_ready_in => start_computation,
            io_done_out => computation_done,

            mem_read_out => comp_mem_read,
            mem_write_out => comp_mem_write,
            mem_addr_out => comp_mem_address,
            mem_data_in => data_outof_mem,
            mem_data_out => comp_data_into_mem
        );
    
    ram_inst : entity dcnn.Ram
        port map (
            clk => clk,
            read_in => mem_read,
            write_in => mem_write,
            address_in => mem_address,
            data_in => data_into_mem,
            data_out => data_outof_mem
        );
end structural;