library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MultiplicationLayerTest is
end MultiplicationLayerTest;

architecture Test of MultiplicationLayerTest is
    constant period : time := 100 ps;
    signal img_data : wordarr_t(0 to 24) := (
        std_logic_vector(to_signed(752, n_word)),
        std_logic_vector(to_signed(842, n_word)),
        std_logic_vector(to_signed(919, n_word)),
        std_logic_vector(to_signed(954, n_word)),
        std_logic_vector(to_signed(425, n_word)),
        std_logic_vector(to_signed(478, n_word)),
        std_logic_vector(to_signed(201, n_word)),
        std_logic_vector(to_signed(-426, n_word)),
        std_logic_vector(to_signed(-992, n_word)),
        std_logic_vector(to_signed(785, n_word)),
        std_logic_vector(to_signed(-130, n_word)),
        std_logic_vector(to_signed(-42, n_word)),
        std_logic_vector(to_signed(-210, n_word)),
        std_logic_vector(to_signed(-525, n_word)),
        std_logic_vector(to_signed(-852, n_word)),
        std_logic_vector(to_signed(604, n_word)),
        std_logic_vector(to_signed(537, n_word)),
        std_logic_vector(to_signed(123, n_word)),
        std_logic_vector(to_signed(456, n_word)),
        std_logic_vector(to_signed(-789, n_word)),
        std_logic_vector(to_signed(20, n_word)),
        std_logic_vector(to_signed(21, n_word)),
        std_logic_vector(to_signed(22, n_word)),
        std_logic_vector(to_signed(23, n_word)),
        std_logic_vector(to_signed(24, n_word))
    );
    signal filter_data : wordarr_t(0 to 24) := img_data;
    signal result_arr : wordarr_t(0 to 24) := (
        std_logic_vector(to_signed(752*752, n_word)),
        std_logic_vector(to_signed(842*842, n_word)),
        std_logic_vector(to_signed(919*919, n_word)),
        std_logic_vector(to_signed(954*954, n_word)),
        std_logic_vector(to_signed(425*425, n_word)),
        std_logic_vector(to_signed(478*478, n_word)),
        std_logic_vector(to_signed(201*201, n_word)),
        std_logic_vector(to_signed(426*426, n_word)),
        std_logic_vector(to_signed(992*992, n_word)),
        std_logic_vector(to_signed(785*785, n_word)),
        std_logic_vector(to_signed(130*130, n_word)),
        std_logic_vector(to_signed(42*42, n_word)),
        std_logic_vector(to_signed(210*210, n_word)),
        std_logic_vector(to_signed(525*525, n_word)),
        std_logic_vector(to_signed(852*852, n_word)),
        std_logic_vector(to_signed(604*604, n_word)),
        std_logic_vector(to_signed(537*537, n_word)),
        std_logic_vector(to_signed(123*123, n_word)),
        std_logic_vector(to_signed(456*456, n_word)),
        std_logic_vector(to_signed(789*789, n_word)),
        std_logic_vector(to_signed(20*20, n_word)),
        std_logic_vector(to_signed(21*21, n_word)),
        std_logic_vector(to_signed(22*22, n_word)),
        std_logic_vector(to_signed(23*23, n_word)),
        std_logic_vector(to_signed(24*24, n_word))
    );
    signal d_arr : wordarr_t(0 to 24);
    signal clk : std_logic;
    signal en : std_logic;
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
        en <= '0';
        wait for period*3;
        en <= '1';
        wait for period*8;
        for i in 0 to 24 loop
            assert d_arr(i) = result_arr(i);
        end loop;
    end process;

    mullayer_gen: entity dcnn.MultiplicationLayer
    port map(
        img_data, filter_data,
        d_arr, clk, en
    );
end Test;


    