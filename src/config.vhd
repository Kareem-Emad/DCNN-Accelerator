library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package config is
    constant n_word : natural := 16;
    constant n_dword : natural := 32;
    constant adder_id : natural := 0;
    constant comparator_id : natural := 1;
    constant image_exp : integer := 0;
    constant filter_exp : integer := 0;

    subtype filtersize_t is std_logic;
    constant filter5x5 : std_logic := '0';
    constant filter3x3 : std_logic := '1';

    subtype operation_t is std_logic;
    constant convolution : std_logic := '0';
    constant pooling : std_logic := '1';
    
    subtype word_t is std_logic_vector(n_word-1 downto 0);
    subtype dword_t is std_logic_vector(n_dword-1 downto 0);
    type wordarr_t is array(integer range <>) of word_t;
    type dwordarr_t is array(integer range <>) of dword_t;
end package;
