library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity AdditionLayer is
    port(
        d_arr : out wordarr_t(24 downto 0) := (others => (others => '0'));
        q_arr : in wordarr_t(24 downto 0) := (others => (others => '0'))
    );
end AdditionLayer;

architecture Structural of AdditionLayer is
begin
    op9tree1: entity dcnn.Op9Tree
        port map(
            d_arr(8 downto 0),
            q_arr(8 downto 0)
        );
    op9tree2: entity dcnn.Op9Tree
        port map(
            d_arr(17 downto 9),
            q_arr(17 downto 9)
        );
    op7tree: entity dcnn.Op7Tree
        port map(
            d_arr(24 downto 18),
            q_arr(24 downto 18)
        );
end Structural;
