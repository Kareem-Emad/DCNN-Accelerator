library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- This entity extends a 2 input operation to 7 input operation
-- Assumptions:
--  1 - Operation takes 1 clock cycle
--  2 - There exists 7 registers to hold the operands and intermediate results
--  3 - There exists 3 operators which will be used
--  4 - The result will be ready in 3 clock-cycles and stored in the first reg
--  5 - The registers are trigerred in the rising edge
--  6 - It should take control of the registers on the falling edge
-------------------------------------------------------------------------------

entity Op7Router is
    port(
        d_arr : out dwordarr_t(0 to 6);   -- input to operand registers
        q_arr : in dwordarr_t(0 to 6);    -- output of operand registers
        a_arr : out dwordarr_t(0 to 2);   -- first operand input to the 4 operators
        b_arr : out dwordarr_t(0 to 2);   -- second operand input to the 4 operators
        s_arr : in dwordarr_t(0 to 2)    -- result of the operators
    );
end Op7Router;

architecture Dataflow of Op7Router is
begin
    wire_gen: for i in 0 to 2 generate
        a_arr(i) <= q_arr(i*2);
        b_arr(i) <= q_arr(i*2+1);
        d_arr(i) <= s_arr(i);
    end generate;
    d_arr(3) <= q_arr(6);
    wire2_gen: for i in 4 to 6 generate
        d_arr(i) <= (others => '0');
    end generate;
end Dataflow;