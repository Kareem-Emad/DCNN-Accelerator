library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity ReluLayer is
    port(
        d_arr : out dwordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in dwordarr_t(0 to 24) := (others => (others => '0'))
    );
end ReluLayer;

architecture Structural of ReluLayer is
    signal sign1 : dword_t;
    signal sign2 : dword_t;
begin
    sign1 <= (others => not(q_arr(0)(n_word-1)));
    sign2 <= (others => not(q_arr(1)(n_word-1)));
    d_arr(0) <= q_arr(0) and sign1;
    d_arr(1) <= q_arr(1) and sign2;

    reset_regs_gen: for i in 2 to 24 generate
        d_arr(i) <= (others => '0');
    end generate;
end Structural;