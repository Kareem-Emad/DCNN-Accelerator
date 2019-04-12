library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use dcnn.config.all;

-------------------------------------------------------------------------------
-- Queue entity is an implementation of FIFO structure. Parallel output is
-- also supported.
-------------------------------------------------------------------------------

entity Queue is
    generic(
        cap : natural := 5 -- Queue's capacity (number of words it can store). 
    );
    port(
        -- word to be pushed
        d : in word_t := (others => '0');
        -- parallel output of the whole stored data 
        q : out wordarr_t(0 to cap-1) := (others => (others => '0'));
        clk : in std_logic := '0';
        -- pushes d into the queue thus evicting the word #capacity-1
        -- the next clock cycle we get q[0:n_word] = d
        load : in std_logic := '0';
        reset : in std_logic := '0'
    );
end Queue;

architecture Dataflow of Queue is

signal d_arr : wordarr_t(0 to cap-1);
signal q_arr : wordarr_t(0 to cap-1);
begin
    d_arr(0) <= d;
    reg0: entity dcnn.Reg
        generic map(n_word)
        port map(
            d => d_arr(0),
            q => q_arr(0),
            clk => clk,
            load => load,
            reset => reset
        );
    q(0) <= q_arr(0);
    gen_regs: for i in 1 to cap-1 generate
        d_arr(i) <= q_arr(i-1);     
        regi: entity dcnn.Reg
            generic map(n_word)
            port map(
                d => d_arr(i),
                q => q_arr(i),
                clk => clk,
                load => load,
                reset => reset
            );
        q(i) <= q_arr(i);
    end generate gen_regs;
end Dataflow;
