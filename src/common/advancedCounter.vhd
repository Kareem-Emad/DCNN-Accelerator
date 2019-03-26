library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AdvancedCounter is -- NOTE: COUNTER VALUE SHOULD BE RESET ON THE OUTSIDE FOR COMPUTATIONAL REASONS
    generic (
        N : natural := 16 --to be set otherwise
    );

    port(
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    mode: in std_logic_vector(1 downto 0); -- 00 if +1, 01 if -1, 10 if +2, 11 if -2
    max_val: in std_logic_vector (N downto 0);
    max_reached: out std_logic; -- signals that counter maximum was reached. Will be used for further processing.
    counter_out : out std_logic_vector(N downto 0)
    );
end AdvancedCounter;

architecture behavioural of AdvancedCounter is
    signal counter_in: unsigned(N downto 0);
begin

    process(rst,clk)
    begin
        if rst ='1' then
            counter_in<=(others=>'0');
        elsif rising_edge(clk) and en='1' then
         if mode="00" then 
                counter_in<=counter_in + 1;
            elsif mode="01" then
                counter_in<=counter_in - 1;
            elsif mode="10" then
                counter_in<=counter_in + 2;
            elsif mode="11" then
                counter_in<=counter_in - 2;
            end if;
        end if;

       


    end process;

    max_reached<='1' when counter_in=unsigned(max_val) else '0';
    counter_out<=std_logic_vector(counter_in);

end behavioural;
  