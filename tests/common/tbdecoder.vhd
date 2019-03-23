--Test bench for Decoder 5 bit input, 28 bit output

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_Decoder is
end tb_Decoder;

architecture tb of tb_Decoder is

    component Decoder is
        generic ( 
            Nsel : natural;
            Nout : natural );
        port (
            enable : in std_logic;
            A : in std_logic_vector(Nsel-1 downto 0);
            F : out std_logic_vector(Nout-1 downto 0));
    end component;

    signal enable : std_logic;
    signal A      : std_logic_vector (4 downto 0);
    signal F      : std_logic_vector (27 downto 0);
    signal result: std_logic_vector (27 downto 0);

begin

    dut : Decoder generic map (5,28)
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

end tb;