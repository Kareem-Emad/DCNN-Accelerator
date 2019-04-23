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
	type ram_type is array (0 to 65536) of std_logic_vector(15 downto 0);
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
		25 => X"0001",
		26 => X"0002",
		27 => X"0003",
		28 => X"0004",
		29 => X"0005",
		30 => X"0006",
		31 => X"0007",
		32 => X"0008",
		33 => X"0009",
		34 => X"0010",
		35 => X"0001",
		36 => X"0002",
		37 => X"0003",
		38 => X"0004",
		39 => X"0005",
		40 => X"0006",
		41 => X"0007",
		42 => X"0008",
		43 => X"0009",
		44 => X"0010",
		45 => X"0001",
		46 => X"0002",
		47 => X"0003",
		48 => X"0004",
		49 => X"0005",
		50 => X"0006",
		51 => X"0007",
		52 => X"0008",
		53 => X"0009",
		54 => X"0010",
		55 => X"0001",
		56 => X"0002",
		57 => X"0003",
		58 => X"0004",
		59 => X"0005",
		60 => X"0006",
		61 => X"0007",
		62 => X"0008",
		63 => X"0009",
		64 => X"0010",
		65 => X"0001",
		66 => X"0002",
		67 => X"0003",
		68 => X"0004",
		69 => X"0005",
		70 => X"0006",
		71 => X"0007",
		72 => X"0008",
		73 => X"0009",
		74 => X"0010",
		75 => X"0001",
		76 => X"0002",
		77 => X"0003",
		78 => X"0004",
		79 => X"0005",
		80 => X"0006",
		81 => X"0007",
		82 => X"0008",
		83 => X"0009",
		84 => X"0010",
		85 => X"0001",
		86 => X"0002",
		87 => X"0003",
		88 => X"0004",
		89 => X"0005",
		90 => X"0006",
		91 => X"0007",
		92 => X"0008",
		93 => X"0009",
		94 => X"0010",
		95 => X"0001",
		96 => X"0002",
		97 => X"0003",
		98 => X"0004",
		99 => X"0005",
		100 => X"0006",
		101 => X"0007",
		102 => X"0008",
		103 => X"0009",
		104 => X"0010",
		105 => X"0001",
		106 => X"0002",
		107 => X"0003",
		108 => X"0004",
		109 => X"0005",
		110 => X"0006",
		111 => X"0007",
		112 => X"0008",
		113 => X"0009",
		114 => X"0010",
		115 => X"0000",
		116 => X"0000",
		117 => X"0000",
		118 => X"0000",
		119 => X"0000",
		120 => X"0000",
		121 => X"0000",
		122 => X"0000",
		123 => X"0000",
		124 => X"0000",
	-- 256 => X"0008",
	-- 257 => X"0009",
	-- 258 => X"0010",
	-- 259 => X"0011",
	-- 260 => X"0012",
	-- 261 => X"0013",
	-- 262 => X"0014",
	-- 263 => X"0015",
	-- 264 => X"0016",
	-- 265 => X"0017",
	-- 266 => X"0018",
	-- 267 => X"0019",
	-- 268 => X"0020",
	-- 269 => X"0021",
	-- 270 => X"0022",
	-- 271 => X"0023",
	-- 272 => X"0024",
	-- 273 => X"0025",
	-- 274 => X"0026",
	-- 275 => X"0027",
	-- 276 => X"0028",
	-- 277 => X"0001",
	-- 278 => X"0002",
	-- 279 => X"0003",
	-- 280 => X"0004",
	-- 281 => X"0005",
	-- 282 => X"0006",
	-- 283 => X"0007",
	-- 284 => X"0008",
	-- 285 => X"0009",
	-- 286 => X"0010",
	-- 287 => X"0011",
	-- 288 => X"0012",
	-- 289 => X"0013",
	-- 290 => X"0014",
	-- 291 => X"0015",
	-- 292 => X"0016",
	-- 293 => X"0017",
	-- 294 => X"0018",
	-- 295 => X"0019",
	-- 296 => X"0020",
	-- 297 => X"0021",
	-- 298 => X"0022",
	-- 299 => X"0023",
	-- 300 => X"0024",
	-- 301 => X"0025",
	-- 302 => X"0026",
	-- 303 => X"0027",
	-- 304 => X"0028", --7th row
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