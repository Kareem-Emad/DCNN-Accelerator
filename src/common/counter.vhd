library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use IEEE.std_logic_unsigned.all;
library dcnn;

entity Counter is -- NOTE: Counter VALUE SHOULD BE RESET ON THE OUTSIDE FOR COMPUTATIONAL REASONS
    generic (
        N : natural := 5 --to be set otherwise
    );
    port (
        clk             : in std_logic;
        reset           : in std_logic;
        enable          : in std_logic;
        mode_in         : in std_logic; -- 0 if +1, 1 if -1
        max_val_in      : in std_logic_vector (N-1 downto 0);
        max_reached_out : out std_logic; -- signals that Counter maximum was reached. Will be used for further processing.
        counter_out     : out std_logic_vector(N-1 downto 0)
    );
end Counter;

architecture behavioural of Counter is
    signal counter_data : unsigned(N-1 downto 0) := (others => '0');
    signal counter_data_v : std_logic_vector (N-1 downto 0);
begin
    process(clk, reset, mode_in, enable)
    begin
        if reset = '1' then
            counter_data <= (others => '0');
        elsif rising_edge(clk) then  
            if enable = '1' then
                if mode_in = '0' then 
                    counter_data <= counter_data + 1;
                else
                    counter_data <= counter_data - 1;
                end if;
            end if;
        end if;
    end process;

    counter_data_v <= std_logic_vector(counter_data);
    counter_out <= counter_data_v;-- when enable = '1' else (others => '0');
    max_reached_out <= '1' when counter_data_v = max_val_in else '0';
end behavioural;
  