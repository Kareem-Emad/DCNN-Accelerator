library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- A 7 operand comparator/adder (depending on op_type)
-- Requires 7 registers to hold the operands, and finishes in 3 cycles
-------------------------------------------------------------------------------

entity Op7Tree is
    port(
        d_arr : out dwordarr_t(0 to 6);
        q_arr : in dwordarr_t(0 to 6)
    );
end Op7Tree;

architecture Structural of Op7Tree is
    signal a_arr : dwordarr_t(0 to 2);
    signal b_arr : dwordarr_t(0 to 2);
    signal s_arr : dwordarr_t(0 to 2);
begin
    router_gen: entity dcnn.Op7Router 
        port map(
            d_arr, q_arr, a_arr,
            b_arr, s_arr
        );
    gen_loop: for i in 0 to 2 generate
        adder_gen: entity dcnn.NAdder
            generic map(n_dword)
            port map(
                a_arr(i), b_arr(i), '0',
                s_arr(i)
            );
    end generate;
end Structural;
