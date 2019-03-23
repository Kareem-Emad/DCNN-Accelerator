library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Queue entity is an implementation of FIFO structure. Parallel output is
-- also supported.
-------------------------------------------------------------------------------

entity Queue is
    generic(
        cap : natural := 5; -- Queue's capacity (number of words it can store). 
        n_word : natural := 16 -- number of bits in a word
    );
    port(
        -- word to be pushed
        input_word : in std_logic_vector(n_word-1 downto 0) := (others => '0');
        -- parallel output of the whole stored data 
        -- (not sure this is the best way, looks ugly to me)
        parallel_out : out std_logic_vector(n_word*cap-1 downto 0) := (others => '0');
        clk : in std_logic := '0';
        -- pushes input_word into the queue thus evicting the word #capacity-1
        -- the next clock cycle we get parallel_out[0:n_word] = input_word
        load : in std_logic := '0';
        reset : in std_logic := '0'
    );
end Queue;

architecture Dataflow of Queue is
	component Reg is
    		generic(n : natural := 16); -- number of bits

    		port(
        		d  : in std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel input
        		q  : out std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel output
			rst_data: std_logic_vector(n-1 downto 0) := (others => '0'); -- data to reset to
        		clk, load, reset : in std_logic := '0' -- clock, load, and reset
    		);
	end component;

type vector_array is array(0 to cap-1) of std_logic_vector(n_word-1 downto 0);
signal d_arr : vector_array;
signal q_arr : vector_array;
begin
	d_arr(0) <= input_word;

    	reg0: Reg
        generic map(n_word)
        port map(
        	d_arr(0),
            	q_arr(0),
		        (others => '0'),
            	clk, load, reset
        );

    	parallel_out(n_word-1 downto 0) <= q_arr(0);

    	gen_regs: for i in 1 to cap-1 generate
        d_arr(i) <= q_arr(i-1);     
        regi: Reg
            generic map(n_word)
            port map(
                d_arr(i),
                q_arr(i),
		        (others => '0'),
                clk, load, reset
            );
        parallel_out((i+1)*n_word-1 downto i*n_word) <= q_arr(i);
    end generate gen_regs;
end Dataflow;
