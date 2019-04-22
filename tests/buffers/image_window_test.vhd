library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ImageWindowTest is
end ImageWindowTest;

architecture Test of ImageWindowTest is
    constant period : time := 100 ps;
    signal data : wordarr_t(0 to 24) := (
        std_logic_vector(to_signed(0, n_word)),
        std_logic_vector(to_signed(1, n_word)),
        std_logic_vector(to_signed(2, n_word)),
        std_logic_vector(to_signed(3, n_word)),
        std_logic_vector(to_signed(4, n_word)),
        std_logic_vector(to_signed(5, n_word)),
        std_logic_vector(to_signed(6, n_word)),
        std_logic_vector(to_signed(7, n_word)),
        std_logic_vector(to_signed(8, n_word)),
        std_logic_vector(to_signed(9, n_word)),
        std_logic_vector(to_signed(10, n_word)),
        std_logic_vector(to_signed(11, n_word)),
        std_logic_vector(to_signed(12, n_word)),
        std_logic_vector(to_signed(13, n_word)),
        std_logic_vector(to_signed(14, n_word)),
        std_logic_vector(to_signed(15, n_word)),
        std_logic_vector(to_signed(16, n_word)),
        std_logic_vector(to_signed(17, n_word)),
        std_logic_vector(to_signed(18, n_word)),
        std_logic_vector(to_signed(19, n_word)),
        std_logic_vector(to_signed(20, n_word)),
        std_logic_vector(to_signed(21, n_word)),
        std_logic_vector(to_signed(22, n_word)),
        std_logic_vector(to_signed(23, n_word)),
        std_logic_vector(to_signed(24, n_word))
    );
    signal d_arr : wordarr_t(0 to 4);
    signal q_arr : wordarr_t(0 to 24);
    
    signal load : std_logic := '1';
    signal reset : std_logic := '1';
    signal clk : std_logic;
begin
    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

    process
    begin
        load <= '1';
        reset <= '0';
        for i in 0 to 4 loop
            d_arr(0) <= data(4 - i);
            d_arr(1) <= data(9 - i);
            d_arr(2) <= data(14 - i);
            d_arr(3) <= data(19 - i);
            d_arr(4) <= data(24 - i);
            wait for period;
        end loop;
        assert q_arr = data;
    end process;

    gen_image_window: entity dcnn.ImageWindow
        port map(
            d => d_arr,
            q => q_arr,
            clk => clk,
            load => load,
            reset => reset
        );
end Test;