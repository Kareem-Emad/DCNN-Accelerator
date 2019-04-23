library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MultiplicationLayer is
    port(
        img_data : in wordarr_t(0 to 24) := (others => (others => '0'));
        filter_data : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr : out wordarr_t(0 to 24) := (others => (others => '0'));
        clk : in std_logic;
        en : in std_logic
    );
end MultiplicationLayer;

architecture Structural of MultiplicationLayer is
begin
    multipliers_gen: for i in 0 to 24 generate
        mul_gen: entity dcnn.Multiplier
            generic map(
                op1_exp => image_exp,
                op2_exp => filter_exp,
                out_exp => image_exp
            )
            port map(
                a => img_data(i),
                b => filter_data(i),
                product => d_arr(i),
                en => en,
                clk => clk
            );
    end generate multipliers_gen;
end Structural;
