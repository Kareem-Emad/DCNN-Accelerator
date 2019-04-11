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
    generic(
        op_type : natural := adder_id
    );
    port(
        d_arr : out wordarr_t(6 downto 0);
        q_arr : in wordarr_t(6 downto 0)
    );
end Op7Tree;

architecture Structural of Op7Tree is
    signal a_arr : wordarr_t(2 downto 0);
    signal b_arr : wordarr_t(2 downto 0);
    signal s_arr : wordarr_t(2 downto 0);
    signal dummy : std_logic;
begin
    router_gen: entity dcnn.Op7Router 
        port map(
            d_arr, q_arr, a_arr,
            b_arr, s_arr
        );
    gen_loop: for i in 0 to 2 generate
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
