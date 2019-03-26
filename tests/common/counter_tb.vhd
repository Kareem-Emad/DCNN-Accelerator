

library ieee;
use ieee.std_logic_1164.all;

entity tb_Counter is
end tb_Counter;

architecture tb of tb_Counter is

    constant n: integer :=3;


    signal clk         : std_logic;
    signal rst         : std_logic;
    signal en          : std_logic;
    signal mode        : std_logic;
    signal max_val     : std_logic_vector (n downto 0);
    signal max_reached : std_logic;
    signal counter_out : std_logic_vector (n downto 0);

begin

    dut :entity work.Counter generic map(N=>n)
    port map (clk         => clk,
              rst         => rst,
              en          => en,
              mode        => mode,
              max_val     => max_val,
              max_reached => max_reached,
              counter_out => counter_out);

    stimuli : process
    begin

        clk <= '0';
        mode <= '0';
        max_val <= "0101";
        en<='1';
        rst <= '1';
        wait for 10 ps;
        rst<= '0';

        for i in 0 to 4 loop
            clk<='0';
            wait for 10 ps;
            clk<='1';
            wait for 10 ps;
        end loop;
        Assert(counter_out=max_val and max_reached='1');

        rst <= '1';
        wait for 10 ps;
        rst<= '0';
        Assert(max_reached='0');

        mode<='1';
        max_val <= "0000";
        for i in 0 to 15 loop
            clk<='0';
            wait for 10 ps;
            clk<='1';
            wait for 10 ps;
        end loop;
        Assert(counter_out="0000" and max_reached='1');

        wait;
    end process;

end tb;
