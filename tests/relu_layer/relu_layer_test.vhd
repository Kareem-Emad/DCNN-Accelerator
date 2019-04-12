library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ReluLayerTest is
end ReluLayerTest;

architecture Test of ReluLayerTest is
    signal d_arr : wordarr_t(0 to 24);
    signal q_arr : wordarr_t(0 to 24);
    signal output1_init : word_t;
    signal output2_init : word_t;
begin
    process is
    begin
        q_arr(0) <= std_logic_vector(to_signed(-5, n_word));
        q_arr(1) <= std_logic_vector(to_signed(6, n_word));
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_signed(0, n_word));
        assert d_arr(1) = std_logic_vector(to_signed(6, n_word));
        
        q_arr(0) <= std_logic_vector(to_signed(5, n_word));
        q_arr(1) <= std_logic_vector(to_signed(-6, n_word));
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_signed(5, n_word));
        assert d_arr(1) = std_logic_vector(to_signed(0, n_word));
        
        q_arr(0) <= std_logic_vector(to_signed(-5, n_word));
        q_arr(1) <= std_logic_vector(to_signed(-6, n_word));
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_signed(0, n_word));
        assert d_arr(1) = std_logic_vector(to_signed(0, n_word));
        
        q_arr(0) <= std_logic_vector(to_signed(5, n_word));
        q_arr(1) <= std_logic_vector(to_signed(6, n_word));
        wait for 50 ps;
        assert d_arr(0) = std_logic_vector(to_signed(5, n_word));
        assert d_arr(1) = std_logic_vector(to_signed(6, n_word));
    end process;

    gen_merge_layer: entity dcnn.ReluLayer
        port map(
            d_arr, q_arr
        );
end Test;
