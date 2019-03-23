library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
        out_column : out std_logic_vector(n_word*cap-1 downto 0) := (others => '0');

        clk : in std_logic := '0';
        -- control signals
        reset : in std_logic := '0'
    );
end Cache;

architecture Dataflow of Cache is
    component Queue is
        generic(
            cap : natural := 5; -- Queue's capacity (number of words it can store). 
            n_word : natural := 16 -- number of bits in a word
        );
        port(
            input_word : in std_logic_vector(n_word-1 downto 0) := (others => '0');
            parallel_out : out std_logic_vector(n_word*cap-1 downto 0) := (others => '0');
            clk : in std_logic := '0';
            load : in std_logic := '0';
            reset : in std_logic := '0'
        );
    end component;
    component Decoder is
        generic ( 
            Nsel : natural;
            Nout : natural );
        port (
            enable : in std_logic;
            A : in std_logic_vector(Nsel-1 downto 0);
            F : out std_logic_vector(Nout-1 downto 0));
    end component;


    type array2d is array (0 to num_queues-1) of std_logic_vector(n_word*cap-1 downto 0);
    signal que_out : array2d ;
    signal sel_que : std_logic_vector(num_queues-1 downto 0);
    signal temp: std_logic_vector(sel-1 downto 0);
   
    begin
        in_decoder : Decoder
            generic map (sel,num_queues)
            port map(
                decoder_enable,
                cache_in_sel,
                sel_que
            );
        
            
        gen_queues: for i in 0 to num_queues-1 generate   
            que : Queue
                generic map(cap,n_word)
                port map(
                    in_word,
                    que_out(i),
                    clk,
                    sel_que(i),--enable
                    reset
                );
        end generate gen_queues;
                  


        out_column <= que_out(to_integer(unsigned(cache_out_sel)));
   

end Dataflow;
