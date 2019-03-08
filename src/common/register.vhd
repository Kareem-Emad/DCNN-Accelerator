library ieee;
use ieee.std_logic_1164.all;

entity Reg is
    generic(n : natural := 16);
    port(
        d : in std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel input
        q : out std_logic_vector(n-1 downto 0) := (others => '0'); -- parallel output
        clk, ld, rst : in std_logic := '0' -- clock, load, and reset
    );
end Reg;

architecture Behavioural of Reg is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioural;