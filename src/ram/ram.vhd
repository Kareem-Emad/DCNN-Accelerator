library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity Ram is
	port (
		clk 										: in std_logic; -- the clock
		read_in									: in std_logic; -- 
		write_in 								: in std_logic;
		address_in              : in std_logic_vector(7 downto 0); -- 256 addresses.
		data_in                 : in std_logic_vector(15 downto 0);
		data_out                : out std_logic_vector(15 downto 0));
end entity Ram;

architecture Behavioral of Ram is
	type ram_type is array (0 to 255) of std_logic_vector(15 downto 0);
	signal ram : ram_type := (
		--R0=0,...,R5=5
		0 => X"0000",
		1 => X"0015",
		2 => X"0011",
		others => X"0000"
	);
	begin
		-- Inputs data into the RAM on the falling edge of the clock.
		process(clk) is
			begin
				if falling_edge(clk) then  
					if read_in = '1' then
						ram(to_integer(unsigned(address_in))) <= data_in;
					end if;
				end if;
		end process;

		-- Outputs data asynchronously when the output is applied.
		data_out <= ram(to_integer(unsigned(address_in))) when (write_in = '1') else (15 downto 0 => '0');
end Behavioral;