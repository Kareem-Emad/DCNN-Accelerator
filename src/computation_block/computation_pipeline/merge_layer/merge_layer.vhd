library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MergeLayer is
    port(
        d_arr : out wordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in wordarr_t(0 to 24) := (others => (others => '0'));
        operation : in operation_t := convolution;
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
signal no_normalization: std_logic;
signal normalize3 : std_logic;
signal d_arr0_tmp : word_t;
signal d_arr1_tmp : word_t;

begin
    no_normalization <= '1' when operation = convolution else '0';
    normalize3 <= '1' when filter_size = filter3x3 else '0';
    
    q9_1 <= q_arr(0);
    q9_2 <= q_arr(9);
    q7 <= q_arr(18);

    adder1_gen: entity dcnn.NAdder
        generic map(n_word)
        port map(
            q9_2, q7, '0', s1, dummy1
        );
    
    adder2_gen: entity dcnn.NAdder
        generic map(n_word)
        port map(
            q9_1, s1, '0', s2, dummy2
        );
    d_arr0_tmp <= s2 when filter_size = filter5x5 else q9_1;
    d_arr1_tmp <= q9_2;

    d_arr(0) <= d_arr0_tmp when no_normalization = '1' else
            "000" & d_arr0_tmp(15 downto 3)  when normalize3 = '1' else
            "00000" & d_arr0_tmp(15 downto 5);

    d_arr(1) <= d_arr1_tmp when no_normalization = '1' else
        "000" & d_arr1_tmp(15 downto 3)  when normalize3 = '1' else
        "00000" & d_arr1_tmp(15 downto 5);

    reset_regs_gen: for i in 2 to 24 generate
        d_arr(i) <= (others => '0');
    end generate;
end Structural;