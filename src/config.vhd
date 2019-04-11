library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package config is
    constant n_word : natural := 16;
    constant adder_id : natural := 0;
    constant comparator_id : natural := 1;
    subtype word_t is std_logic_vector(n_word-1 downto 0);
    type wordarr_t is array(integer range <>) of word_t;
end package;
