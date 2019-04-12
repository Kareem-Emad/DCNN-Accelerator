library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CacheTB is
end CacheTB;

architecture TB of CacheTB is

    constant n_word : integer := 16;
    constant cap : integer := 5;
    constant num_queues : integer := 28;
    constant sel : integer := 5;

    signal in_word        : std_logic_vector (n_word-1 downto 0) := (others => '0');
    signal cache_in_sel   : std_logic_vector (sel-1 downto 0) := (others => '0');
    signal cache_out_sel  : std_logic_vector (sel-1 downto 0) := (others => '0');
    signal decoder_enable : std_logic;
    signal out_column     : std_logic_vector (n_word*cap-1 downto 0) := (others => '0');
    signal clk            : std_logic;
    signal reset          : std_logic;
    signal result         : std_logic_vector(n_word*cap-1 downto 0):= (others => '0');

begin

    dut : entity dcnn.Cache 
    generic map(
        cap => cap,
        n_word => n_word,
        num_queues => num_queues,
        sel => sel
    )
    port map (
        in_word        => in_word,
        cache_in_sel   => cache_in_sel,
        cache_out_sel  => cache_out_sel,
        decoder_enable => decoder_enable,
        out_column     => out_column,
        clk            => clk,
        reset          => reset
    );

    stimuli : process
    begin

        in_word <= (others => '0');
        cache_in_sel <= (others => '0');
        cache_out_sel <= (others => '0');
        decoder_enable <= '1';
        clk <= '0';

        For j in 0 to num_queues-1 loop
            cache_in_sel<= std_logic_vector(to_signed(j, sel));
            cache_out_sel<=std_logic_vector(to_signed(j, sel));

        
            For i in 0 to cap-1 Loop
                clk<='0';
                in_word<= std_logic_vector(to_signed(j, n_word));
                WAIT FOR 10 ps;
                clk<='1';
                WAIT FOR 10 ps;
                result((i+1)*n_word-1 downto i*n_word)<=std_logic_vector(to_signed(j, n_word));
            end loop;
            wait for 10 ps;
            ASSERT(out_column=result) ;

        end loop;
        
        WAIT;

    end process;

end TB;
