library ieee;
use ieee.std_logic_1164.all;
library work;

entity reg is
    generic (
        N       : natural := 16 -- number of bits
    ); 
    port (
        d_in    : in std_logic_vector(N - 1 downto 0); -- parallel input
        load_in : in std_logic; -- load in data.
        q_out   : out std_logic_vector(N - 1 downto 0) := (others => '0'); -- parallel output
        clk     : in std_logic; -- clock
        reset   : in std_logic -- reset
    );
end reg;


architecture Behavioral of reg is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_out <= (others => '0');
        elsif rising_edge(clk) then
            if load_in = '1' then
                q_out <= d_in;
            end if;
        end if;
    end process;
end Behavioral;
