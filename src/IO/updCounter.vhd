library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UpdCounter is
    Port ( clk,rst,en : in  STD_LOGIC;      
           dir : in  STD_LOGIC;     -- direction of counter (up or down)
           count : out  STD_LOGIC_VECTOR (6 downto 0));   
end entity;

architecture ArchUpdCounter of UpdCounter is
    signal cnt   : STD_LOGIC_VECTOR (6 downto 0) := (others=>'0');
begin
    process (rst,clk)
    begin
        if (rst='1') then
            cnt<= (others =>'0');

        elsif (clk'Event and clk = '1') then
            if (en='1') then
                if (dir = '1') then
                    cnt <= cnt + '1';   -- counting up
                elsif (dir = '0') then
                    cnt <= cnt - '1';   -- counting down
                end if;
            end if;
        end if;
    end process;

    count <= cnt;
    
end architecture;