library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_unsigned.all;

entity Counter is -- NOTE: Counter VALUE SHOULD BE RESET ON THE OUTSIDE FOR COMPUTATIONAL REASONS
    generic (
        N : natural :=16--to be set otherwise
    );

    port(
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    mode: in std_logic; -- 0 if +1, 1 if -1
    max_val: in std_logic_vector (N downto 0);
    max_reached: out std_logic; -- signals that Counter maximum was reached. Will be used for further processing.
    counter_out : out std_logic_vector(N downto 0)
    );
end Counter;

architecture behavioural of Counter is
    signal counter_in: unsigned(N downto 0);
begin


    process(rst,clk)
    begin
        
        if rst ='1' then
            counter_in<=(others=>'0');
        elsif rising_edge(clk) and en='1' then
           if mode='0' then 
                counter_in<=counter_in + 1;
            elsif mode='1' then
                counter_in<=counter_in - 1;
            end if;

        end if;
     



    end process;

    max_reached<='1' when counter_in=unsigned(max_val) else '0';
   
    counter_out<=std_logic_vector(counter_in);


end behavioural;
  