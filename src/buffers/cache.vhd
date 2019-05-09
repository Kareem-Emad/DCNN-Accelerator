library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- Image Cache 28*5 words
-------------------------------------------------------------------------------

entity Cache is
    generic(
        cap : natural := 5; -- Queue's capacity (number of words it can store). 
        n_word : in natural := 16; -- number of bits in a word
        num_queues : in natural := 28; -- number of queues
        sel : in natural := 5 -- to choose from 28 -> need 5 bits
    );
    port(
        -- input word from memory at a time 
        in_word : in std_logic_vector(n_word-1 downto 0) := (others => '0');
        -- mux selection lines for input to the cache 
        cache_in_sel,cache_out_sel : in std_logic_vector(sel-1 downto 0) := (others => '0');
        decoder_enable : in std_logic := '0';
        -- output column
        out_column : out wordarr_t(0 to cap-1) := (others => (others => '0'));

        clk : in std_logic := '0';
        -- control signals
        reset : in std_logic := '0'
    );
end Cache;

architecture Dataflow of Cache is
    type array2d is array (0 to num_queues-1) of wordarr_t(0 to cap-1);
    signal que_out : array2d;
    signal sel_que : std_logic_vector(num_queues-1 downto 0);
   
    begin
        in_decoder : entity dcnn.Decoder
            generic map (
                Nsel => sel,
                Nout => num_queues
            )
            port map(
                enable => decoder_enable,
                A => cache_in_sel,
                F => sel_que
            );
        
            
        gen_queues: for i in 0 to num_queues-1 generate   
            que : entity dcnn.Queue
                generic map(
                    cap
                )
                port map(
                    d => in_word,
                    q => que_out(i),
                    clk => clk,
                    load => sel_que(i), --enable
                    reset => reset
                );
        end generate gen_queues;

        out_column <= que_out(to_integer(unsigned(cache_out_sel)));
end Dataflow;
