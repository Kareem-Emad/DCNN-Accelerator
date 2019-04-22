library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MuxLayerTest is
end MuxLayerTest;

architecture Test of MuxLayerTest is
    signal img_data : wordarr_t(0 to 24) := (
        std_logic_vector(to_unsigned(0, n_word)),
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
    signal filter_data : wordarr_t(0 to 24) := img_data;
    signal ordered_img_data : wordarr_t(0 to 24);
    signal ordered_filter_data : wordarr_t(0 to 24);
    signal filter_size : filtersize_t := filter5x5;

    type natarr_t is array (0 to 24) of natural;
    constant indices5x5 : natarr_t := (
        0, 1, 2, 5, 6, 7, 10, 11, 12,
        3, 8, 13, 4, 9, 14, 15, 16, 17,
        18, 19, 20, 21, 22, 23, 24
    );
    constant indices3x3 : natarr_t := (
        0, 1, 2, 5, 6, 7, 10, 11, 12,
        1, 2, 3, 6, 7, 8, 11, 12, 13,
        18, 19, 20, 21, 22, 23, 24
    );
begin
    muxlayer_gen: entity dcnn.MuxLayer
        port map(
            img_data, filter_data, filter_size,
            ordered_img_data, ordered_filter_data
        );

    process is
    begin
        filter_size <= filter5x5;
        wait for 100 ps;
        for i in 0 to 24 loop
            assert ordered_img_data(i) = img_data(indices5x5(i));
            assert ordered_filter_data(i) = filter_data(indices5x5(i));
        end loop;
        filter_size <= filter3x3;
        wait for 100 ps;
        for i in 0 to 24 loop
            assert ordered_img_data(i) = img_data(indices3x3(i));
        end loop;
        for i in 0 to 8 loop
            assert ordered_filter_data(i) = filter_data(i);
            assert ordered_filter_data(i+9) = filter_data(i);
        end loop;
    end process;
end Test;


    