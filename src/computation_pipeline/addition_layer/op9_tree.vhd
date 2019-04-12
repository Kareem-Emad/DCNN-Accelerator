library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- A 9 operand comparator/adder (depending on op_type)
-- Requires 9 registers to hold the operands, and finishes in 4 cycles
-------------------------------------------------------------------------------

entity Op9Tree is
    generic(
        op_type : natural := adder_id -- operation type
    );
    port(
        d_arr : out wordarr_t(0 to 8);
        q_arr : in wordarr_t(0 to 8)
    );
end Op9Tree;

architecture Structural of Op9Tree is
    signal a_arr : wordarr_t(0 to 3);
    signal b_arr : wordarr_t(0 to 3);    
    signal s_arr : wordarr_t(0 to 3);
    signal dummy : std_logic;
begin
    router_gen: entity dcnn.Op9Router 
        port map(
            d_arr, q_arr, a_arr,
            b_arr, s_arr
        );

    gen_loop: for i in 0 to 3 generate
        adders_gen: if op_type = adder_id generate 
        adder_gen: entity dcnn.NAdder
            generic map(n_word)
            port map(
                a_arr(i), b_arr(i), '0',
                '1', s_arr(i), dummy
            );
        end generate adders_gen;
        
        comps_gen: if op_type = comparator_id generate 
        comp_gen: entity dcnn.NComparator
            generic map(n_word)
            port map(
                a_arr(i), b_arr(i),
                '1', s_arr(i)
            );
        end generate comps_gen;
    end generate;
end Structural;
