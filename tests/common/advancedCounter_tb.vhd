
library ieee;
use ieee.std_logic_1164.all;

entity AdvancedCounterTB is
end AdvancedCounterTB;

architecture TB of AdvancedCounterTB is

    constant N: integer := 4;

 

    signal clk         : std_logic;
    signal reset         : std_logic;
    signal en          : std_logic;
    signal mode        : std_logic_vector (1 downto 0);
    signal max_val     : std_logic_vector (n-1 downto 0);
    signal max_reached : std_logic;
    signal counter_out : std_logic_vector (n-1 downto 0);

begin

    dut : entity work.AdvancedCounter generic map(N=>N)
    port map (clk               => clk,
              reset             => reset,
              enable            => en,
              mode_in           => mode,
              max_val_in        => max_val,
              max_reached_out   => max_reached,
              counter_out       => counter_out);

    stimuli : process
    begin
        clk <= '0';
        mode <= "00";
        en<='1';
        max_val <= "0101";
        reset <= '1';
        wait for 10 ps;
        reset<= '0';

        for i in 0 to 4 loop
            clk<='0';
            wait for 10 ps;
            clk<='1';
            wait for 10 ps;
        end loop;
        Assert(counter_out=max_val and max_reached='1');

        reset <= '1';
        wait for 10 ps;
        reset<= '0';
        Assert(max_reached='0');

        mode<="01";
        max_val <= "0000";
        for i in 0 to 15 loop
            clk<='0';
            wait for 10 ps;
            clk<='1';
            wait for 10 ps;
        end loop;
        Assert(counter_out="0000" and max_reached='1');
       

        mode<="10";
        max_val <= "1000";
        for i in 0 to 3 loop
            clk<='0';
            wait for 10 ps;
            clk<='1';
            wait for 10 ps;
        end loop;
        Assert(counter_out=max_val and max_reached='1');


        mode<="11";
        max_val <= "0000";
        for i in 0 to 3 loop
            clk<='0';
            wait for 10 ps;
            clk<='1';
            wait for 10 ps;
        end loop;
        Assert(counter_out=max_val and max_reached='1');


        wait;
    end process;

end TB;
