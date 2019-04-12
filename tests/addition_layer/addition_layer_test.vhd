library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AdditionLayerTest is
end AdditionLayerTest;

architecture Test of AdditionLayerTest is
    constant period : time := 100 ps;
    signal d_arr : wordarr_t(0 to 24);
    constant initial_value : wordarr_t(0 to 24) := (
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
    signal q_arr : wordarr_t(0 to 24);
    signal clk : std_logic;
begin
    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

    process is
    begin
        q_arr <= initial_value;
        for i in 0 to 3 loop
            wait for period / 2;
            q_arr <= d_arr;
            wait for period / 2;
        end loop;
        assert d_arr(0) = std_logic_vector(to_unsigned(36, n_word));
        assert d_arr(9) = std_logic_vector(to_unsigned(117, n_word));
        assert d_arr(18) = std_logic_vector(to_unsigned(147, n_word));
    end process;

    gen_addition_layer: entity dcnn.AdditionLayer
        port map(d_arr, q_arr);
end Test;