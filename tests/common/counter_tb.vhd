

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.std_logic_unsigned.all;
library dcnn;

entity CounterTB is
end CounterTB;

architecture TB of CounterTB is
    constant n: integer := 5;
    signal clk         : std_logic;
    signal rst         : std_logic;
    signal en          : std_logic;
    signal mode        : std_logic;
    signal max_val     : std_logic_vector (n-1 downto 0);
    signal max_reached : std_logic;
    signal counter_out : std_logic_vector (n-1 downto 0);
    constant period : time := 1 ns;
    
begin
    counter_inst : entity dcnn.Counter 
    port map (clk               => clk,
              reset             => rst,
              enable            => en,
              mode_in           => mode,
              max_val_in        => max_val,
              max_reached_out   => max_reached,
              counter_out       => counter_out
    );

    stimuli : process
    begin
        mode <= '0';
        max_val <= "00101";
        en<='1';
        rst <= '1';
        wait for period;
        rst<= '0';
        wait for 5 * period;
        Assert (counter_out=max_val and max_reached='1') report "Counting up from 0 to 5 failed!";

        rst <= '1';
        wait for period;
        rst<= '0';
        Assert(max_reached='0');

        mode <= '1';
        max_val <= (others => '0');
        wait for 32 * period;
        Assert (counter_out = X"00000" and max_reached='1') report "Counting down from 32 to 0 failed!";
        wait for period;
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

end TB;
