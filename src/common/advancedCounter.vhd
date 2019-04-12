library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library dcnn;

entity AdvancedCounter is -- NOTE: COUNTER VALUE SHOULD BE RESET ON THE OUTSIDE FOR COMPUTATIONAL REASONS
    generic (
        N : natural := 5 --to be set otherwise
    );

    port (
        clk             : in std_logic;
        reset           : in std_logic;
        enable          : in std_logic;
        mode_in         : in std_logic_vector(1 downto 0); -- 00 if +1, 01 if -1, 10 if +2, 11 if -2
        max_val_in      : in std_logic_vector (N-1 downto 0);
        max_reached_out : out std_logic; -- signals that counter maximum was reached. Will be used for further processing.
        counter_out     : out std_logic_vector(N-1 downto 0)
    );
end AdvancedCounter;

architecture behavioural of AdvancedCounter is
    signal counter_data : unsigned(N-1 downto 0);
    signal counter_data_v : std_logic_vector (N-1 downto 0);
begin
    process(reset, enable, clk)
    begin
        if reset ='1' then
            counter_data <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                if mode_in = "00" then
                    counter_data <= counter_data + 1;
                elsif mode_in = "01" then
                    counter_data <= counter_data - 1;
                elsif mode_in = "10" then
                    counter_data <= counter_data + 2;
                else
                    counter_data <= counter_data - 2;
                end if;
            end if;
        end if;
    end process;

    counter_data_v <= std_logic_vector(counter_data);
    counter_out <= counter_data_v when enable = '1' else (others => '0');
    max_reached_out <= '1' when counter_data_v = max_val_in else '0';
end behavioural;
  