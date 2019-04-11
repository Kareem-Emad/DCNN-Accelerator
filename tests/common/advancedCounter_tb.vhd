
library ieee;
use ieee.std_logic_1164.all;

entity AdvancedCounterTB is
end AdvancedCounterTB;

architecture TB of AdvancedCounterTB is

    constant N: integer := 5;

    signal clk         : std_logic;
    signal reset         : std_logic;
    signal en          : std_logic;
    signal mode        : std_logic_vector (1 downto 0);
    signal max_val     : std_logic_vector (n-1 downto 0);
    signal max_reached : std_logic;
    signal counter_out : std_logic_vector (n-1 downto 0);
    constant period : time := 1 ns;

begin

    AdvancedCounter_inst : entity work.AdvancedCounter
    port map (clk               => clk,
              reset             => reset,
              enable            => en,
              mode_in           => mode,
              max_val_in        => max_val,
              max_reached_out   => max_reached,
              counter_out       => counter_out);

    stimuli : process
    begin
        mode <= "00";
        en<='1';
        max_val <= "00101";
        reset <= '1';
        wait for period;
        reset<= '0';

        wait for 5 * period;
        Assert(counter_out=max_val and max_reached='1');

        reset <= '1';
        wait for period;
        reset<= '0';
        Assert(max_reached='0');

        mode<="01";
        max_val <= "00000";
        wait for period * 16;
        Assert(counter_out="00000" and max_reached='1');
       

        mode<="10";
        max_val <= "01000";
        wait for period * 4;
        Assert(counter_out=max_val and max_reached='1');


        mode<="11";
        max_val <= "00000";
        wait for period * 4;
        Assert(counter_out=max_val and max_reached='1');


        wait;
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;
end TB;
