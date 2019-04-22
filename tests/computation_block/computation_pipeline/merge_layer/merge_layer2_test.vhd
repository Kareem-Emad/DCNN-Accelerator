library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MergeLayer2Test is
end MergeLayer2Test;

architecture Test of MergeLayer2Test is
    constant initial_value : wordarr_t(0 to 24) := (
        std_logic_vector(to_unsigned(10, n_word)),
        std_logic_vector(to_unsigned(1, n_word)),
        std_logic_vector(to_unsigned(2, n_word)),
        std_logic_vector(to_unsigned(3, n_word)),
        std_logic_vector(to_unsigned(4, n_word)),
        std_logic_vector(to_unsigned(5, n_word)),
        std_logic_vector(to_unsigned(6, n_word)),
        std_logic_vector(to_unsigned(7, n_word)),
        std_logic_vector(to_unsigned(8, n_word)),
        std_logic_vector(to_unsigned(9, n_word)),
        std_logic_vector(to_unsigned(10, n_word)),
        std_logic_vector(to_unsigned(11, n_word)),
        std_logic_vector(to_unsigned(12, n_word)),
        std_logic_vector(to_unsigned(13, n_word)),
        std_logic_vector(to_unsigned(14, n_word)),
        std_logic_vector(to_unsigned(15, n_word)),
        std_logic_vector(to_unsigned(16, n_word)),
        std_logic_vector(to_unsigned(17, n_word)),
        std_logic_vector(to_unsigned(18, n_word)),
        std_logic_vector(to_unsigned(19, n_word)),
        std_logic_vector(to_unsigned(20, n_word)),
        std_logic_vector(to_unsigned(21, n_word)),
        std_logic_vector(to_unsigned(22, n_word)),
        std_logic_vector(to_unsigned(23, n_word)),
        std_logic_vector(to_unsigned(24, n_word))
    );
    signal d_arr : wordarr_t(0 to 24);
    signal q_arr : wordarr_t(0 to 24);
    signal output1_init : word_t;
    signal output2_init : word_t;
begin
    process is
    begin
        q_arr <= initial_value;
        output1_init <= std_logic_vector(to_unsigned(7, n_word));
        output2_init <= std_logic_vector(to_unsigned(5, n_word));
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_unsigned(17, n_word));
        assert d_arr(1) = std_logic_vector(to_unsigned(6, n_word));
    end process;

    gen_merge_layer: entity dcnn.MergeLayer2
        port map(
            d_arr, q_arr, output1_init, output2_init
        );
end Test;
