library ieee;
-- library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity QueueTest is
end QueueTest;

architecture Test of QueueTest is
constant n_word : integer := 16;
constant cap : integer := 5;
constant period : time := 100 ps;
signal clk, reset, load : std_logic := '0';
signal input_word : std_logic_vector(n_word-1 downto 0);
signal result : std_logic_vector(n_word*cap-1 downto 0);
component Queue is
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
end component;
begin
    process is
        begin
            clk <= '0';
            wait for period / 2;
            clk <= '1';
            wait for period / 2;
        end process;

    process is
        variable tmp: integer := 16#F0F0#;
    begin
        load <= '1';
        for i in 0 to cap-1 loop
            input_word <= std_logic_vector(to_unsigned(tmp-i, n_word));
            wait for period;
            for j in 0 to i loop
                assert result(n_word*(j+1)-1 downto n_word*j) = 
                    std_logic_vector(to_unsigned(tmp-i+j, n_word));	
            end loop;
        end loop;
    end process;

    gen_queue: Queue    
        generic map(cap, n_word) 
        port map(
            input_word, result, clk, load, reset
        );
end Test;
