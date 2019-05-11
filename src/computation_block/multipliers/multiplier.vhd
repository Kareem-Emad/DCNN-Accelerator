library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity Multiplier is
    port(
        a : in dword_t := (others => '0');
        b : in dword_t := (others => '0');
        product : out dword_t := (others => '0');
        en : in std_logic;
        clk : in std_logic        
    );
end entity Multiplier;

architecture Structural of Multiplier is
    signal a_tmp : word_t;
    signal b_tmp : word_t;
    signal long_product : signed(31 downto 0);
    -- constant shift : integer := op1_exp + op2_exp - out_exp;
    -- constant shift : integer := image_exp + filter_exp - image_exp;
begin
    a_tmp <= a(n_word-1 downto 0);
    b_tmp <= b(n_word-1 downto 0);
    mul_gen: entity dcnn.ModifiedBoothMultiplier
        port map(
            signed(a_tmp),
            signed(b_tmp),
            en,
            long_product,
            clk
        );
    product <= std_logic_vector(long_product);
    -- product <= std_logic_vector(long_product(15+shift downto shift));
end architecture Structural;