library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity Multiplier is
    -- generic(
    --    op1_exp : integer := 0;
    --    op2_exp : integer := 0;
    --    out_exp : integer := 0
    -- );
    port(
        a : in word_t := (others => '0');
        b : in word_t := (others => '0');
        product : out word_t := (others => '0');
        en : in std_logic;
        clk : in std_logic        
    );
end entity Multiplier;

architecture Structural of Multiplier is
    signal long_product : signed(31 downto 0);
    -- constant shift : integer := op1_exp + op2_exp - out_exp;
    constant shift : integer := image_exp + filter_exp - image_exp;
begin
    mul_gen: entity dcnn.ModifiedBoothMultiplier
        port map(
            signed(a),
            signed(b),
            en,
            long_product,
            clk
        );
    product <= std_logic_vector(long_product(15+shift downto shift));
end architecture Structural;