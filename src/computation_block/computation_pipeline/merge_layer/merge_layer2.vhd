library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MergeLayer2 is
    port(
        d_arr : out wordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in wordarr_t(0 to 24) := (others => (others => '0'));
        output1_init : in word_t := (others => '0');
        output2_init : in word_t := (others => '0')
    );
end MergeLayer2;

architecture Structural of MergeLayer2 is
signal dummy1 : std_logic;
signal dummy2 : std_logic;
begin
    adder1_gen: entity dcnn.NAdder
        generic map(n_word)
        port map(
            q_arr(0), output1_init, '0', '1', d_arr(0), dummy1
        );
    
    adder2_gen: entity dcnn.NAdder
        generic map(n_word)
        port map(
            q_arr(1), output2_init, '0', '1', d_arr(1), dummy2
        );
    
    reset_regs_gen: for i in 2 to 24 generate
        d_arr(i) <= (others => '0');
    end generate;
end Structural;