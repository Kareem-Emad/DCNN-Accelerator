library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MergeLayerTest is
end MergeLayerTest;

architecture Test of MergeLayerTest is
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
    signal filter_size : filtersize_t;
begin
    process is
    begin
        q_arr <= initial_value;
        filter_size <= filter5x5;
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_unsigned(10+9+18, n_word));
        filter_size <= filter3x3;
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_unsigned(10, n_word));
        assert d_arr(1) = std_logic_vector(to_unsigned(9, n_word));
    end process;

    gen_merge_layer: entity dcnn.MergeLayer  
        port map(
            d_arr, q_arr, filter_size
        );
end Test;
