library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- This entity extends a 2 input operation to 9 input operation
-- Assumptions:
--  1 - Operation takes 1 clock cycle
--  2 - There exists 9 registers to hold the operands and intermediate results
--  3 - There exists 4 operators which will be used
--  4 - The result will be ready in 4 clock-cycles and stored in the first reg
-------------------------------------------------------------------------------

entity Op9Router is
    port(
        d_arr : out wordarr_t(0 to 8);   -- input to operand registers
        q_arr : in wordarr_t(0 to 8);    -- output of operand registers
        a_arr : out wordarr_t(0 to 3);   -- first operand input to the 4 operators
        b_arr : out wordarr_t(0 to 3);   -- second operand input to the 4 operators
        s_arr : in wordarr_t(0 to 3)    -- result of the operators
    );
end Op9Router;

architecture Dataflow of Op9Router is
begin
    wire_gen: for i in 0 to 3 generate
        a_arr(i) <= q_arr(i*2);
        b_arr(i) <= q_arr(i*2+1);
        d_arr(i) <= s_arr(i);
    end generate;
    d_arr(4) <= q_arr(8);
    d_arr(5) <= (others => '0');
    d_arr(6) <= (others => '0');
    d_arr(7) <= (others => '0');
    d_arr(8) <= (others => '0');
end Dataflow;