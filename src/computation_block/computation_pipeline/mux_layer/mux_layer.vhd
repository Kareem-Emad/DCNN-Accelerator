library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity MuxLayer is
    port(
        img_data : in wordarr_t(0 to 24) := (others => (others => '0'));
        filter_data : in wordarr_t(0 to 24) := (others => (others => '0'));
        filter_size : in filtersize_t := filter5x5;
        ordered_img_data : out wordarr_t(0 to 24) := (others => (others => '0'));
        ordered_filter_data : out wordarr_t(0 to 24) := (others => (others => '0'))
    );
end MuxLayer;

architecture Structural of MuxLayer is
    type natarr_t is array (0 to 8) of natural;
    constant indices : natarr_t := (
        3, 8, 13,
        4, 9, 14,
        15, 16, 17
    );
begin
    window3x3_x: for i in 0 to 2 generate
        window3x3_y: for j in 0 to 2 generate
            ordered_img_data(i*3+j) <= img_data(i*5+j);
            ordered_filter_data(i*3+j) <= filter_data(i*5+j); 

            ordered_img_data(i*3+j+9) <= 
                img_data(i*5+j+1) when filter_size=filter3x3 else
                img_data(indices(i*3 + j));
            ordered_filter_data(i*3+j+9) <= 
                filter_data(i*5+j+1) when filter_size=filter3x3 else
                filter_data(indices(i*3 + j));
        end generate;
    end generate;

    last7: for i in 18 to 24 generate
        ordered_img_data(i) <= img_data(i);
        ordered_filter_data(i) <= filter_data(i);
    end generate;
end Structural;