library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity AdditionLayer is
    port(
        d_arr : out wordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in wordarr_t(0 to 24) := (others => (others => '0'))
    );
end AdditionLayer;

architecture Structural of AdditionLayer is
begin
    op9tree1: entity dcnn.Op9Tree
        port map(
            d_arr(0 to 8),
            q_arr(0 to 8)
        );
    op9tree2: entity dcnn.Op9Tree
        port map(
            d_arr(9 to 17),
            q_arr(9 to 17)
        );
    op7tree1: entity dcnn.Op7Tree
        port map(
            d_arr(18 to 24),
            q_arr(18 to 24)
        );
end Structural;
