library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- Queue_5 entity is an implementation of FIFO structure. Parallel output is
-- also supported.
-------------------------------------------------------------------------------

entity Queue_5 is
    port(
        -- word to be pushed
        d : in word_t := (others => '0');
        -- parallel output of the whole stored data 
        q : out wordarr_t(0 to 5-1) := (others => (others => '0'));
        clk : in std_logic := '0';
        -- pushes d into the Queue_5 thus evicting the word #5acity-1
        -- the next clock cycle we get q[0:n_word] = d
        load : in std_logic := '0';
        reset : in std_logic := '0'
    );
end Queue_5;

architecture Structural of Queue_5 is

signal d_arr : wordarr_t(0 to 5-1);
signal q_arr : wordarr_t(0 to 5-1);
begin
    d_arr(0) <= d;
    reg0: entity dcnn.Reg_16
        port map(
            d => d_arr(0),
            q => q_arr(0),
            clk => clk,
            load => load,
            reset => reset
        );
    q(0) <= q_arr(0);
    gen_regs: for i in 1 to 5-1 generate
        d_arr(i) <= q_arr(i-1);     
        regi: entity dcnn.Reg_16
            port map(
                d => d_arr(i),
                q => q_arr(i),
                clk => clk,
                load => load,
                reset => reset
            );
        q(i) <= q_arr(i);
    end generate gen_regs;
end Structural;
