library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;
use dcnn.config.all;

entity ComputationCache is
    port(
        d : in wordarr_t(0 to 24); 
        q : out wordarr_t(0 to 24);
        clk : in std_logic;
        load : in std_logic;
        reset : in std_logic
    );
end ComputationCache;

architecture Structural of ComputationCache is
begin
    gen_regs: for i in 0 to 24 generate
        gen_regi: entity dcnn.Reg_16
            port map(
                d => d(i),
                q => q(i),
                clk => clk,
                load => load,
                reset => reset
            );
    end generate;
end Structural;
