library ieee;
use ieee.std_logic_1164.all;
library dcnn;

entity Reg_16 is
    port (        
        d  : in std_logic_vector(16-1 downto 0) := (others => '0'); -- parallel input
        q  : out std_logic_vector(16-1 downto 0) := (others => '0'); -- parallel output
	    rst_data: std_logic_vector(16-1 downto 0) := (others => '0'); -- data to reset to
        clk, load, reset : in std_logic := '0' -- clock, load, and reset
    );
end Reg_16;

architecture Behavioral of Reg_16 is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= rst_data;
        elsif rising_edge(clk) then
            if load = '1' then
                q <= d;
            end if;
        end if;
    end process;
end Behavioral;
