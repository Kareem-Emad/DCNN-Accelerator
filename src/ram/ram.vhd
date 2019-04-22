library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;

entity Ram is
	port (
		clk 					: in std_logic; -- the clock
		read_in					: in std_logic;
		write_in 				: in std_logic;
		address_in              : in std_logic_vector(15 downto 0); -- 256 addresses.
		data_in                 : in std_logic_vector(15 downto 0);
		data_out                : out std_logic_vector(15 downto 0));
end entity Ram;

architecture Behavioral of Ram is
	type ram_type is array (0 to 255) of std_logic_vector(15 downto 0);
	signal ram : ram_type := (
		--R0=0,...,R5=5
		0 => X"0001", -- number of layers
		-- Start of Layer 1
		1 => X"0000", -- layer type (0: Conv, 1: Pool, 2: FC)
		2 => X"0002", -- Number of filters in layer
		3 => X"0003", -- Filter size
		4 => X"001A", -- New Layer Width
		5 => X"02A4", -- (New Layer Width)^2
		6 => X"0548", -- (New Layer Width)^2 * Number of filters in layer
		7 => X"0001", -- start of filter 1
		8 => X"0002", 
		9 => X"0003",
		10 => X"0004",
		11 => X"0005",
		12 => X"0006",
		13 => X"0007",
		14 => X"0008",
		15 => X"0009", -- end of filter 1
		16 => X"000A", -- start of filter 2
		17 => X"000B",
		18 => X"000C",
		19 => X"000D",
		20 => X"000E",
		21 => X"000F",
		22 => X"0010",
		23 => X"0011",
		24 => X"0012", -- end of filter 2
		
		others => X"BBBB"
	);
	begin
		-- Inputs data into the RAM on the falling edge of the clock.
		process(clk) is
			begin
				if falling_edge(clk) then  
					if write_in = '1' then
						ram(to_integer(unsigned(address_in))) <= data_in;
					end if;
				end if;
		end process;

		-- Outputs data asynchronously when the output is applied.
		data_out <= ram(to_integer(unsigned(address_in))) when (read_in = '1') else (15 downto 0 => '0');
end Behavioral;