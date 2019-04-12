--Test bench for Decoder 5 bit input, 28 bit output

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity DecoderTB is
end DecoderTB;

architecture TB of DecoderTB is
    signal enable : std_logic;
    signal A      : std_logic_vector (4 downto 0);
    signal F      : std_logic_vector (27 downto 0);
    signal result: std_logic_vector (27 downto 0);

begin
    dut : entity dcnn.Decoder generic map (5,28)
    port map (enable => enable,
              A      => A,
              F      => F);

    stimuli : process
        begin
        For i in 0 to 27 Loop
            enable <= '1';
            result <= (others => '0');
            result(i) <= '1';		
            A <= std_logic_vector(to_signed(i, 5));
            WAIT FOR 10 ps;
            ASSERT(F = result) REPORT "F is wrong at" &integer'image(i) SEVERITY ERROR;		
        end loop;
        WAIT;

    end process;

end TB;