library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MultiplicationLayer is
    port(
        img_data : in dwordarr_t(0 to 24) := (others => (others => '0'));
        filter_data : in dwordarr_t(0 to 24) := (others => (others => '0'));
        d_arr : out dwordarr_t(0 to 24) := (others => (others => '0'));
        clk : in std_logic;
        en : in std_logic
    );
end MultiplicationLayer;

architecture Structural of MultiplicationLayer is
begin
    multipliers_gen: for i in 0 to 24 generate
        mul_gen: entity dcnn.Multiplier
            port map(
                a => img_data(i),
                b => filter_data(i),
                product => d_arr(i),
                en => en,
                clk => clk
            );
    end generate multipliers_gen;
end Structural;
