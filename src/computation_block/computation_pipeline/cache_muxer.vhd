library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use dcnn.config.all;

entity CacheMuxer is
    port(
        d_arr_mux : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr_mul : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr_add : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr_merge1 : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr_merge2 : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr_relu : in wordarr_t(0 to 24) := (others => (others => '0'));
        sel_mux : in std_logic;
        sel_mul : in std_logic;
        sel_add : in std_logic;
        sel_merge1 : in std_logic;
        sel_merge2 : in std_logic;
        sel_relu : in std_logic;
        d_arr : out wordarr_t(0 to 24)
    );
end CacheMuxer;

architecture Behavioral of CacheMuxer is
    signal img_data_reordered : wordarr_t(0 to 24);
    signal filter_data_reordered : wordarr_t(0 to 24);
begin
    d_arr <= d_arr_mux when sel_mux = '1' else 
            d_arr_mul when sel_mul = '1' else
            d_arr_add when sel_add = '1' else
            d_arr_merge1 when sel_merge1 = '1' else
            d_arr_merge2 when sel_merge2 = '1' else
            d_arr_relu when sel_relu = '1';
end Behavioral;
