library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;

entity Decoder is
    generic ( 
        Nsel : natural := 5;
        Nout : natural := 28
        );
    port (
        enable : in std_logic;
        A : in std_logic_vector(Nsel-1 downto 0);
        F : out std_logic_vector(Nout-1 downto 0));
end Decoder;

architecture behavioral of Decoder is
begin
    process(enable, A)
    begin
        F <= (others => '0');
        if enable = '1' then
            F(to_integer(unsigned(A))) <= '1';
        end if;
    end process;
end behavioral;

        
    