library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity QueueTest is
end QueueTest;

architecture Test of QueueTest is
constant cap : integer := 5;
constant period : time := 100 ps;
signal clk, reset, load : std_logic := '0';
signal input_word : std_logic_vector(n_word-1 downto 0);
signal result : wordarr_t(cap-1 downto 0);
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
                assert result(j) = 
                    std_logic_vector(to_unsigned(tmp-i+j, n_word));
            end loop;
        end loop;
    end process;

    gen_queue: entity dcnn.Queue    
        generic map(cap) 
        port map(
            input_word, result, clk, load, reset
        );
end Test;
