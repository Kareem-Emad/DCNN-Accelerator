library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MergeLayer2 is
    port(
        d_arr : out dwordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in dwordarr_t(0 to 24) := (others => (others => '0'));
        output1_init : in dword_t := (others => '0');
        output2_init : in dword_t := (others => '0')
    );
end MergeLayer2;

architecture Structural of MergeLayer2 is
signal dummy1 : std_logic;
signal dummy2 : std_logic;
signal q_0_tmp : unsigned(n_dword-1 downto 0);
signal q_1_tmp : unsigned(n_dword-1 downto 0);
signal q_0 : dword_t;
signal q_1 : dword_t;
constant shift : integer := image_exp + filter_exp - image_exp;
begin
    q_0_tmp <= unsigned(q_arr(0));
    q_1_tmp <= unsigned(q_arr(1));
    q_0 <= std_logic_vector(shift_right(q_0_tmp, shift));
    q_1 <= std_logic_vector(shift_right(q_1_tmp, shift));
    adder1_gen: entity dcnn.NAdder
        generic map(n_dword)
        port map(
            q_0, output1_init, '0', d_arr(0), dummy1
        );
    
    adder2_gen: entity dcnn.NAdder
        generic map(n_dword)
        port map(
            q_1, output2_init, '0', d_arr(1), dummy2
        );
    
    reset_regs_gen: for i in 2 to 24 generate
        d_arr(i) <= (others => '0');
    end generate;
end Structural;