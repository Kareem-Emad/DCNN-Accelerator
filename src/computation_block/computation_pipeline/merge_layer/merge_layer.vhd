library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MergeLayer is
    port(
        d_arr : out wordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in wordarr_t(0 to 24) := (others => (others => '0'));
        filter_size : in filtersize_t := filter5x5
    );
end MergeLayer;

architecture Structural of MergeLayer is
signal q9_1 : word_t;
signal q9_2 : word_t;
signal q7 : word_t;
signal s1 : word_t;
signal s2 : word_t;
signal dummy1 : std_logic;
signal dummy2 : std_logic;
begin
    q9_1 <= q_arr(0);
    q9_2 <= q_arr(9);
    q7 <= q_arr(18);

    adder1_gen: entity dcnn.NAdder
        generic map(n_word)
        port map(
            q9_2, q7, '0', '1', s1, dummy1
        );
    
    adder2_gen: entity dcnn.NAdder
        generic map(n_word)
        port map(
            q9_1, s1, '0', '1', s2, dummy2
        );
    d_arr(0) <= s2 when filter_size = filter5x5 else q9_1;
    d_arr(1) <= q9_2;
    
    reset_regs_gen: for i in 2 to 24 generate
        d_arr(i) <= (others => '0');
    end generate;
end Structural;