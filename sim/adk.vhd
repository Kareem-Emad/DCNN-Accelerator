-----------------------------------------------------------------------
--  VITAL library for ASIC Design Kit (ADK)                         
--
-- NOTE: This VHDL file should be compiled into the "adk" library.
--
-- 3.0 Includes new component package
--
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library adk;

entity fake_gnd is
  port (Y: out std_logic);
end fake_gnd;

ARCHITECTURE rtl OF fake_gnd IS
BEGIN
  Y <= '0';
END rtl;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity fake_vcc is
  port (Y: out std_logic);
end fake_vcc;
 
ARCHITECTURE rtl OF fake_vcc IS
BEGIN
  Y <= '1';
END rtl;

--%BEGIN and02

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity and02 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of and02 : entity is TRUE;
end and02;

architecture and02_arch of and02 is
	attribute VITAL_LEVEL1 of and02_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end and02_arch;

--%END and02

--%BEGIN and03

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity and03 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of and03 : entity is TRUE;
end and03;

architecture and03_arch of and03 is
	attribute VITAL_LEVEL1 of and03_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end and03_arch;

--%END and03

--%BEGIN and04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity and04 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of and04 : entity is TRUE;
end and04;

architecture and04_arch of and04 is
	attribute VITAL_LEVEL1 of and04_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end and04_arch;

--%END and04

--%BEGIN ao21

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity ao21 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of ao21 : entity is TRUE;
end ao21;

architecture ao21_arch of ao21 is
	attribute VITAL_LEVEL1 of ao21_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalOr2 (INT_RES_0, B0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end ao21_arch;

--%END ao21

--%BEGIN ao22

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity ao22 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of ao22 : entity is TRUE;
end ao22;

architecture ao22_arch of ao22 is
	attribute VITAL_LEVEL1 of ao22_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalOr2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end ao22_arch;

--%END ao22

--%BEGIN ao221

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity ao221 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of ao221 : entity is TRUE;
end ao221;

architecture ao221_arch of ao221 is
	attribute VITAL_LEVEL1 of ao221_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd, 
				C0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalOr3 (INT_RES_0, INT_RES_1, C0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end ao221_arch;

--%END ao221

--%BEGIN ao32

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity ao32 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of ao32 : entity is TRUE;
end ao32;

architecture ao32_arch of ao32 is
	attribute VITAL_LEVEL1 of ao32_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalOr2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end ao32_arch;

--%END ao32

--%BEGIN aoi21

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi21 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi21 : entity is TRUE;
end aoi21;

architecture aoi21_arch of aoi21 is
	attribute VITAL_LEVEL1 of aoi21_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalNor2 (INT_RES_0, B0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi21_arch;

--%END aoi21

--%BEGIN aoi22

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi22 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi22 : entity is TRUE;
end aoi22;

architecture aoi22_arch of aoi22 is
	attribute VITAL_LEVEL1 of aoi22_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNor2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi22_arch;

--%END aoi22

--%BEGIN aoi221

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi221 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi221 : entity is TRUE;
end aoi221;

architecture aoi221_arch of aoi221 is
	attribute VITAL_LEVEL1 of aoi221_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd, 
				C0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNor3 (INT_RES_0, INT_RES_1, C0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi221_arch;

--%END aoi221

--%BEGIN aoi222

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi222 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi222 : entity is TRUE;
end aoi222;

architecture aoi222_arch of aoi222 is
	attribute VITAL_LEVEL1 of aoi222_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd, 
				C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalAnd2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNor3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi222_arch;

--%END aoi222

--%BEGIN aoi32

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi32 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi32 : entity is TRUE;
end aoi32;

architecture aoi32_arch of aoi32 is
	attribute VITAL_LEVEL1 of aoi32_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNor2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi32_arch;

--%END aoi32

--%BEGIN aoi321

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi321 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi321 : entity is TRUE;
end aoi321;

architecture aoi321_arch of aoi321 is
	attribute VITAL_LEVEL1 of aoi321_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, C0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNor3 (INT_RES_0, INT_RES_1, C0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi321_arch;

--%END aoi321

--%BEGIN aoi322

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi322 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi322 : entity is TRUE;
end aoi322;

architecture aoi322_arch of aoi322 is
	attribute VITAL_LEVEL1 of aoi322_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalAnd2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNor3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi322_arch;

--%END aoi322

--%BEGIN aoi33

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi33 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi33 : entity is TRUE;
end aoi33;

architecture aoi33_arch of aoi33 is
	attribute VITAL_LEVEL1 of aoi33_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, B2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalNor2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi33_arch;

--%END aoi33

--%BEGIN aoi332

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi332 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi332 : entity is TRUE;
end aoi332;

architecture aoi332_arch of aoi332 is
	attribute VITAL_LEVEL1 of aoi332_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, B2_ipd, C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalAnd2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNor3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi332_arch;

--%END aoi332

--%BEGIN aoi333

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi333 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		C2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi333 : entity is TRUE;
end aoi333;

architecture aoi333_arch of aoi333 is
	attribute VITAL_LEVEL1 of aoi333_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
	signal C2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
		VitalWireDelay (C2_ipd, C2, tipd_C2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, B2_ipd, C0_ipd, C1_ipd, 
				C2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalAnd3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalAnd3 (C0_ipd, C1_ipd, C2_ipd);
		INT_RES_3 := VitalNor3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				),
				8 => (
					InputChangeTime => C2_ipd'LAST_EVENT,
					PathDelay => tpd_C2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi333_arch;

--%END aoi333

--%BEGIN aoi422

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi422 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi422 : entity is TRUE;
end aoi422;

architecture aoi422_arch of aoi422 is
	attribute VITAL_LEVEL1 of aoi422_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd, 
				B0_ipd, B1_ipd, C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);
		INT_RES_1 := VitalAnd2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalAnd2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNor3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi422_arch;

--%END aoi422

--%BEGIN aoi43

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi43 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi43 : entity is TRUE;
end aoi43;

architecture aoi43_arch of aoi43 is
	attribute VITAL_LEVEL1 of aoi43_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd, 
				B0_ipd, B1_ipd, B2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);
		INT_RES_1 := VitalAnd3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalNor2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi43_arch;

--%END aoi43

--%BEGIN aoi44

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity aoi44 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		B3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of aoi44 : entity is TRUE;
end aoi44;

architecture aoi44_arch of aoi44 is
	attribute VITAL_LEVEL1 of aoi44_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
	signal B3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
		VitalWireDelay (B3_ipd, B3, tipd_B3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd, 
				B0_ipd, B1_ipd, B2_ipd, B3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalAnd4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);
		INT_RES_1 := VitalAnd4 (B0_ipd, B1_ipd, B2_ipd, B3_ipd);
		INT_RES_2 := VitalNor2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => B3_ipd'LAST_EVENT,
					PathDelay => tpd_B3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end aoi44_arch;

--%END aoi44

--%BEGIN buf02

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity buf02 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of buf02 : entity is TRUE;
end buf02;

architecture buf02_arch of buf02 is
	attribute VITAL_LEVEL1 of buf02_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBuf (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end buf02_arch;

--%END buf02

--%BEGIN buf04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity buf04 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of buf04 : entity is TRUE;
end buf04;

architecture buf04_arch of buf04 is
	attribute VITAL_LEVEL1 of buf04_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBuf (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end buf04_arch;

--%END buf04

--%BEGIN buf08

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity buf08 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of buf08 : entity is TRUE;
end buf08;

architecture buf08_arch of buf08 is
	attribute VITAL_LEVEL1 of buf08_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBuf (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end buf08_arch;

--%END buf08

--%BEGIN buf12

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity buf12 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of buf12 : entity is TRUE;
end buf12;

architecture buf12_arch of buf12 is
	attribute VITAL_LEVEL1 of buf12_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBuf (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end buf12_arch;

--%END buf12

--%BEGIN buf16

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity buf16 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of buf16 : entity is TRUE;
end buf16;

architecture buf16_arch of buf16 is
	attribute VITAL_LEVEL1 of buf16_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBuf (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end buf16_arch;

--%END buf16

--%BEGIN dff

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity dff is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_posedge : VitalDelayType := 0 ns;
		tpw_CLK_negedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of dff : entity is TRUE;
end dff;

architecture dff_arch of dff is
	attribute VITAL_LEVEL1 of dff_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 2);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_table : VitalStateTableType := (
			('X','-','-','-','-','X','X','X'),
			('-','^','0','0','-','X','0','1'),
			('-','^','1','0','-','X','1','0'),
			('-','^','0','1','0','X','0','1'),
			('-','^','1','1','1','X','1','0'),
			('-','f','0','-','0','1','S','S'),
			('-','f','0','-','1','1','X','X'),
			('-','f','1','-','1','1','S','S'),
			('-','f','1','-','0','1','X','X'),
			('-','v','B','B','-','X','S','S'),
			('-','r','0','-','0','0','S','S'),
			('-','r','0','-','-','0','X','X'),
			('-','r','1','-','1','0','S','S'),
			('-','r','1','-','-','0','X','X'),
			('-','/','0','-','-','X','0','1'),
			('-','/','1','-','-','X','1','0'),
			('-','\','-','-','-','X','S','S'),
			('-','*','-','-','-','X','X','X'),
			('-','B','*','-','-','X','S','S'),
			('-','-','*','-','-','X','S','S'),
			('-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dff",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_posedge,
				PulseWidthLow => tpw_CLK_negedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dff",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Pviol_0;
		VitalStateTable (
			StateTable => DFF_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end dff_arch;

--%END dff

--%BEGIN dffr

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity dffr is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_negedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_0_negedge : VitalDelayType := 0 ns;
		tpw_R_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of dffr : entity is TRUE;
end dffr;

architecture dffr_arch of dffr is
	attribute VITAL_LEVEL1 of dffr_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_R_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X','X'),
			('-','-','-','1','-','-','S','0','1'),
			('-','B','-','n','-','0','X','S','S'),
			('-','X','0','n','-','0','0','S','S'),
			('-','X','-','n','-','-','X','X','X'),
			('-','-','0','v','-','-','S','S','S'),
			('-','B','-','v','-','-','X','S','S'),
			('-','-','0','r','-','0','S','S','S'),
			('-','B','-','r','-','0','X','S','S'),
			('-','-','0','r','-','-','S','X','X'),
			('-','-','-','*','-','-','X','X','X'),
			('-','^','0','-','0','-','X','0','1'),
			('-','^','1','0','0','-','X','1','0'),
			('-','^','0','-','1','0','X','0','1'),
			('-','^','1','0','1','1','X','1','0'),
			('-','f','0','-','-','0','1','S','S'),
			('-','f','0','-','-','1','1','X','X'),
			('-','f','1','0','-','1','1','S','S'),
			('-','f','1','0','-','0','1','X','X'),
			('-','v','0','-','B','-','X','S','S'),
			('-','v','1','0','B','-','X','S','S'),
			('-','r','0','-','-','0','0','S','S'),
			('-','r','0','-','-','-','0','X','X'),
			('-','r','1','0','-','1','0','S','S'),
			('-','r','1','0','-','-','0','X','X'),
			('-','/','0','-','-','-','X','0','1'),
			('-','/','1','0','-','-','X','1','0'),
			('-','\','-','-','-','-','X','S','S'),
			('-','*','-','-','-','-','X','X','X'),
			('-','B','*','-','-','-','X','S','S'),
			('-','-','*','0','-','-','X','S','S'),
			('-','-','*','-','-','0','X','S','S'),
			('-','-','*','-','-','-','X','X','X'),
			('-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffr",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_negedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => FALSE,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffr",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_R_EQ_0_posedge,
				PulseWidthLow => tpw_CLK_R_EQ_0_negedge,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffr",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => tpw_R_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffr",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Rviol_0 or Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => DFF_R_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, R_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end dffr_arch;

--%END dffr

--%BEGIN dffs

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity dffs is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_posedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_1_posedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_1_negedge : VitalDelayType := 0 ns;
		tpw_S_negedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of dffs : entity is TRUE;
end dffs;

architecture dffs_arch of dffs is
	attribute VITAL_LEVEL1 of dffs_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_S_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X','X'),
			('-','-','-','1','-','-','S','1','0'),
			('-','B','-','n','-','1','X','S','S'),
			('-','X','1','n','-','1','0','S','S'),
			('-','X','-','n','-','-','X','X','X'),
			('-','-','1','v','-','-','S','S','S'),
			('-','B','-','v','-','-','X','S','S'),
			('-','-','1','r','-','1','S','S','S'),
			('-','B','-','r','-','1','X','S','S'),
			('-','-','1','r','-','-','S','X','X'),
			('-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','0','-','X','0','1'),
			('-','^','1','-','0','-','X','1','0'),
			('-','^','0','0','1','0','X','0','1'),
			('-','^','1','-','1','1','X','1','0'),
			('-','f','0','0','-','0','1','S','S'),
			('-','f','0','0','-','1','1','X','X'),
			('-','f','1','-','-','1','1','S','S'),
			('-','f','1','-','-','0','1','X','X'),
			('-','v','0','0','B','-','X','S','S'),
			('-','v','1','-','B','-','X','S','S'),
			('-','r','0','0','-','0','0','S','S'),
			('-','r','0','0','-','-','0','X','X'),
			('-','r','1','-','-','1','0','S','S'),
			('-','r','1','-','-','-','0','X','X'),
			('-','/','0','0','-','-','X','0','1'),
			('-','/','1','-','-','-','X','1','0'),
			('-','\','-','-','-','-','X','S','S'),
			('-','*','-','-','-','-','X','X','X'),
			('-','B','*','-','-','-','X','S','S'),
			('-','-','*','0','-','-','X','S','S'),
			('-','-','*','-','-','1','X','S','S'),
			('-','-','*','-','-','-','X','X','X'),
			('-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => (S_ipd = '1'),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_posedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_S_EQ_1_posedge,
				PulseWidthLow => tpw_CLK_S_EQ_1_negedge,
				CheckEnabled => (S_ipd = '1'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_negedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (S_ipd);
		Violation_0 := Tviol_0 or Rviol_0 or Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => DFF_S_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, INT_RES_0
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end dffs_arch;

--%END dffs

--%BEGIN dffs_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity dffs_ni is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_negedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_0_negedge : VitalDelayType := 0 ns;
		tpw_S_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of dffs_ni : entity is TRUE;
end dffs_ni;

architecture dffs_ni_arch of dffs_ni is
	attribute VITAL_LEVEL1 of dffs_ni_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_S_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X','X'),
			('-','-','-','1','-','-','S','1','0'),
			('-','B','-','n','-','1','X','S','S'),
			('-','X','1','n','-','1','0','S','S'),
			('-','X','-','n','-','-','X','X','X'),
			('-','-','1','v','-','-','S','S','S'),
			('-','B','-','v','-','-','X','S','S'),
			('-','-','1','r','-','1','S','S','S'),
			('-','B','-','r','-','1','X','S','S'),
			('-','-','1','r','-','-','S','X','X'),
			('-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','0','-','X','0','1'),
			('-','^','1','-','0','-','X','1','0'),
			('-','^','0','0','1','0','X','0','1'),
			('-','^','1','-','1','1','X','1','0'),
			('-','f','0','0','-','0','1','S','S'),
			('-','f','0','0','-','1','1','X','X'),
			('-','f','1','-','-','1','1','S','S'),
			('-','f','1','-','-','0','1','X','X'),
			('-','v','0','0','B','-','X','S','S'),
			('-','v','1','-','B','-','X','S','S'),
			('-','r','0','0','-','0','0','S','S'),
			('-','r','0','0','-','-','0','X','X'),
			('-','r','1','-','-','1','0','S','S'),
			('-','r','1','-','-','-','0','X','X'),
			('-','/','0','0','-','-','X','0','1'),
			('-','/','1','-','-','-','X','1','0'),
			('-','\','-','-','-','-','X','S','S'),
			('-','*','-','-','-','-','X','X','X'),
			('-','B','*','-','-','-','X','S','S'),
			('-','-','*','0','-','-','X','S','S'),
			('-','-','*','-','-','1','X','S','S'),
			('-','-','*','-','-','-','X','X','X'),
			('-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => (S_ipd = '0'),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs_ni",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_negedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs_ni",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_S_EQ_0_posedge,
				PulseWidthLow => tpw_CLK_S_EQ_0_negedge,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs_ni",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_posedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffs_ni",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Rviol_0 or Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => DFF_S_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, S_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end dffs_ni_arch;

--%END dffs_ni

--%BEGIN dffsr

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity dffsr is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_R_EQ_0_posedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_S_EQ_1_negedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond0_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond0_negedge : VitalDelayType := 0 ns;
		tpw_S_R_EQ_0_negedge : VitalDelayType := 0 ns;
		tpw_R_S_EQ_1_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of dffsr : entity is TRUE;
end dffsr;

architecture dffsr_arch of dffsr is
	attribute VITAL_LEVEL1 of dffsr_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_1 : X01 := '0';
		VARIABLE RecoRemoInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_2 : X01 := '0';
		VARIABLE PeriodDataInfo_2 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 4);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_SR_10_table : VitalStateTableType := (
			('X','-','-','-','-','-','-','X','X','X'),
			('-','-','-','0','1','-','-','X','0','1'),
			('-','-','-','1','-','-','-','X','1','0'),
			('-','B','-','n','0','-','1','X','S','S'),
			('-','X','1','n','0','-','1','0','S','S'),
			('-','-','1','v','0','-','-','S','S','S'),
			('-','B','-','v','0','-','-','X','S','S'),
			('-','-','1','r','0','-','1','S','S','S'),
			('-','B','-','r','0','-','1','X','S','S'),
			('-','-','1','r','0','-','-','S','X','X'),
			('-','-','-','*','-','-','-','X','X','X'),
			('-','B','-','0','n','-','0','X','S','S'),
			('-','X','0','0','n','-','0','0','S','S'),
			('-','-','0','0','v','-','-','S','S','S'),
			('-','B','-','0','v','-','-','X','S','S'),
			('-','-','0','0','r','-','0','S','S','S'),
			('-','B','-','0','r','-','0','X','S','S'),
			('-','-','0','0','r','-','-','S','X','X'),
			('-','-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','-','0','-','X','0','1'),
			('-','^','1','-','0','0','-','X','1','0'),
			('-','^','0','0','-','1','0','X','0','1'),
			('-','^','1','-','0','1','1','X','1','0'),
			('-','f','0','0','-','-','0','1','S','S'),
			('-','f','0','0','-','-','1','1','X','X'),
			('-','f','1','-','0','-','1','1','S','S'),
			('-','f','1','-','0','-','0','1','X','X'),
			('-','v','0','0','-','B','-','X','S','S'),
			('-','v','1','-','0','B','-','X','S','S'),
			('-','r','0','0','-','-','0','0','S','S'),
			('-','r','0','0','-','-','-','0','X','X'),
			('-','r','1','-','0','-','1','0','S','S'),
			('-','r','1','-','0','-','-','0','X','X'),
			('-','/','0','0','-','-','-','X','0','1'),
			('-','/','1','-','0','-','-','X','1','0'),
			('-','\','-','-','0','-','-','X','S','S'),
			('-','\','-','0','-','-','-','X','S','S'),
			('-','*','-','-','-','-','-','X','X','X'),
			('-','B','*','0','-','-','-','X','S','S'),
			('-','B','*','-','0','-','-','X','S','S'),
			('-','-','*','0','0','-','-','X','S','S'),
			('-','-','*','0','-','-','0','X','S','S'),
			('-','-','*','-','0','-','1','X','S','S'),
			('-','-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((S_ipd = '1') AND 
					(R_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_R_EQ_0_posedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_S_EQ_1_negedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => FALSE,
				CheckEnabled => (S_ipd = '1'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr",
				Violation => Rviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_cond0_posedge,
				PulseWidthLow => tpw_CLK_cond0_negedge,
				CheckEnabled => ((S_ipd = '1') AND 
					(R_ipd = '0')),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_R_EQ_0_negedge,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => tpw_R_S_EQ_1_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (S_ipd = '1'),
				PeriodData => PeriodDataInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr",
				Violation => Pviol_2,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (S_ipd);
		Violation_0 := Tviol_0 or Rviol_0 or Rviol_1 or Pviol_0 or 
				Pviol_1 or Pviol_2;
		VitalStateTable (
			StateTable => DFF_SR_10_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, INT_RES_0, R_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end dffsr_arch;

--%END dffsr

--%BEGIN dffsr_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity dffsr_ni is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_R_EQ_0_negedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_S_EQ_0_negedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond0_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond0_negedge : VitalDelayType := 0 ns;
		tpw_S_R_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_R_S_EQ_0_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of dffsr_ni : entity is TRUE;
end dffsr_ni;

architecture dffsr_ni_arch of dffsr_ni is
	attribute VITAL_LEVEL1 of dffsr_ni_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_1 : X01 := '0';
		VARIABLE RecoRemoInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_2 : X01 := '0';
		VARIABLE PeriodDataInfo_2 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 4);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_SR_10_table : VitalStateTableType := (
			('X','-','-','-','-','-','-','X','X','X'),
			('-','-','-','0','1','-','-','X','0','1'),
			('-','-','-','1','-','-','-','X','1','0'),
			('-','B','-','n','0','-','1','X','S','S'),
			('-','X','1','n','0','-','1','0','S','S'),
			('-','-','1','v','0','-','-','S','S','S'),
			('-','B','-','v','0','-','-','X','S','S'),
			('-','-','1','r','0','-','1','S','S','S'),
			('-','B','-','r','0','-','1','X','S','S'),
			('-','-','1','r','0','-','-','S','X','X'),
			('-','-','-','*','-','-','-','X','X','X'),
			('-','B','-','0','n','-','0','X','S','S'),
			('-','X','0','0','n','-','0','0','S','S'),
			('-','-','0','0','v','-','-','S','S','S'),
			('-','B','-','0','v','-','-','X','S','S'),
			('-','-','0','0','r','-','0','S','S','S'),
			('-','B','-','0','r','-','0','X','S','S'),
			('-','-','0','0','r','-','-','S','X','X'),
			('-','-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','-','0','-','X','0','1'),
			('-','^','1','-','0','0','-','X','1','0'),
			('-','^','0','0','-','1','0','X','0','1'),
			('-','^','1','-','0','1','1','X','1','0'),
			('-','f','0','0','-','-','0','1','S','S'),
			('-','f','0','0','-','-','1','1','X','X'),
			('-','f','1','-','0','-','1','1','S','S'),
			('-','f','1','-','0','-','0','1','X','X'),
			('-','v','0','0','-','B','-','X','S','S'),
			('-','v','1','-','0','B','-','X','S','S'),
			('-','r','0','0','-','-','0','0','S','S'),
			('-','r','0','0','-','-','-','0','X','X'),
			('-','r','1','-','0','-','1','0','S','S'),
			('-','r','1','-','0','-','-','0','X','X'),
			('-','/','0','0','-','-','-','X','0','1'),
			('-','/','1','-','0','-','-','X','1','0'),
			('-','\','-','-','0','-','-','X','S','S'),
			('-','\','-','0','-','-','-','X','S','S'),
			('-','*','-','-','-','-','-','X','X','X'),
			('-','B','*','0','-','-','-','X','S','S'),
			('-','B','*','-','0','-','-','X','S','S'),
			('-','-','*','0','0','-','-','X','S','S'),
			('-','-','*','0','-','-','0','X','S','S'),
			('-','-','*','-','0','-','1','X','S','S'),
			('-','-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((S_ipd = '0') AND 
					(R_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr_ni",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_R_EQ_0_negedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr_ni",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_S_EQ_0_negedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => FALSE,
				CheckEnabled => (S_ipd = '0'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr_ni",
				Violation => Rviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_cond0_posedge,
				PulseWidthLow => tpw_CLK_cond0_negedge,
				CheckEnabled => ((S_ipd = '0') AND 
					(R_ipd = '0')),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr_ni",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_R_EQ_0_posedge,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr_ni",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => tpw_R_S_EQ_0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/dffsr_ni",
				Violation => Pviol_2,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Rviol_0 or Rviol_1 or Pviol_0 or 
				Pviol_1 or Pviol_2;
		VitalStateTable (
			StateTable => DFF_SR_10_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, S_ipd, R_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end dffsr_ni_arch;

--%END dffsr_ni

--%BEGIN fadd1

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity fadd1 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_CI : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CI_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_CO : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B_CO : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CI_CO : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		B : in STD_LOGIC;
		CI : in STD_LOGIC;
		S : out STD_LOGIC;
		CO : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of fadd1 : entity is TRUE;
end fadd1;

architecture fadd1_arch of fadd1 is
	attribute VITAL_LEVEL1 of fadd1_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
	signal B_ipd : STD_LOGIC := 'X';
	signal CI_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
		VitalWireDelay (B_ipd, B, tipd_B);
		VitalWireDelay (CI_ipd, CI, tipd_CI);
	end Block;

	VitalBehavior : Process (A_ipd, B_ipd, CI_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE INT_RES_4 : STD_LOGIC := 'X';
		VARIABLE GlitchData_S : VitalGlitchDataType;
		VARIABLE GlitchData_CO : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalXor3 (A_ipd, B_ipd, CI_ipd);
		INT_RES_1 := VitalAnd2 (A_ipd, B_ipd);
		INT_RES_2 := VitalAnd2 (A_ipd, CI_ipd);
		INT_RES_3 := VitalAnd2 (B_ipd, CI_ipd);
		INT_RES_4 := VitalOr3 (INT_RES_1, INT_RES_2, INT_RES_3);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => S,
			OutSignalName => "S",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_S,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => B_ipd'LAST_EVENT,
					PathDelay => tpd_B_S,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => CI_ipd'LAST_EVENT,
					PathDelay => tpd_CI_S,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_S,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => CO,
			OutSignalName => "CO",
			OutTemp => INT_RES_4,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_CO,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => B_ipd'LAST_EVENT,
					PathDelay => tpd_B_CO,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => CI_ipd'LAST_EVENT,
					PathDelay => tpd_CI_CO,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_CO,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end fadd1_arch;

--%END fadd1

--%BEGIN hadd1

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity hadd1 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_CO : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B_CO : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		B : in STD_LOGIC;
		S : out STD_LOGIC;
		CO : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of hadd1 : entity is TRUE;
end hadd1;

architecture hadd1_arch of hadd1 is
	attribute VITAL_LEVEL1 of hadd1_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
	signal B_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
		VitalWireDelay (B_ipd, B, tipd_B);
	end Block;

	VitalBehavior : Process (A_ipd, B_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_S : VitalGlitchDataType;
		VARIABLE GlitchData_CO : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalXor2 (A_ipd, B_ipd);
		INT_RES_1 := VitalAnd2 (A_ipd, B_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => S,
			OutSignalName => "S",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_S,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => B_ipd'LAST_EVENT,
					PathDelay => tpd_B_S,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_S,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => CO,
			OutSignalName => "CO",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_CO,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => B_ipd'LAST_EVENT,
					PathDelay => tpd_B_CO,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_CO,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end hadd1_arch;

--%END hadd1

--%BEGIN inv01

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity inv01 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of inv01 : entity is TRUE;
end inv01;

architecture inv01_arch of inv01 is
	attribute VITAL_LEVEL1 of inv01_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end inv01_arch;

--%END inv01

--%BEGIN inv02

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity inv02 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of inv02 : entity is TRUE;
end inv02;

architecture inv02_arch of inv02 is
	attribute VITAL_LEVEL1 of inv02_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end inv02_arch;

--%END inv02

--%BEGIN inv04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity inv04 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of inv04 : entity is TRUE;
end inv04;

architecture inv04_arch of inv04 is
	attribute VITAL_LEVEL1 of inv04_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end inv04_arch;

--%END inv04

--%BEGIN inv08

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity inv08 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of inv08 : entity is TRUE;
end inv08;

architecture inv08_arch of inv08 is
	attribute VITAL_LEVEL1 of inv08_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end inv08_arch;

--%END inv08

--%BEGIN inv12

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity inv12 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of inv12 : entity is TRUE;
end inv12;

architecture inv12_arch of inv12 is
	attribute VITAL_LEVEL1 of inv12_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end inv12_arch;

--%END inv12

--%BEGIN inv16

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity inv16 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of inv16 : entity is TRUE;
end inv16;

architecture inv16_arch of inv16 is
	attribute VITAL_LEVEL1 of inv16_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
	end Block;

	VitalBehavior : Process (A_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end inv16_arch;

--%END inv16

--%BEGIN latch

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity latch is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_D_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		tpw_CLK_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		Q : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of latch : entity is TRUE;
end latch;

architecture latch_arch of latch is
	attribute VITAL_LEVEL1 of latch_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 2);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 1);
		CONSTANT LATCH_table : VitalStateTableType := (
			('X','-','-','-','X','X'),
			('-','0','-','-','S','S'),
			('-','1','0','-','0','1'),
			('-','1','1','-','1','0'),
			('-','X','0','0','S','S'),
			('-','X','1','1','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(0);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_negedge,
				SetupLow => tsetup_D_CLK_noedge_negedge,
				HoldHigh => thold_D_CLK_noedge_negedge,
				HoldLow => thold_D_CLK_noedge_negedge,
				CheckEnabled => TRUE,
				RefTransition => 'F',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latch",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latch",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Pviol_0;
		VitalStateTable (
			StateTable => LATCH_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd
			),
			NumStates => 1,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => D_ipd'LAST_EVENT,
					PathDelay => tpd_D_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end latch_arch;

--%END latch

--%BEGIN latchr

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity latchr is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_D_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_negedge_negedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_negedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_R_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		R : in STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of latchr : entity is TRUE;
end latchr;

architecture latchr_arch of latchr is
	attribute VITAL_LEVEL1 of latchr_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 1);
		CONSTANT LATCH_R_table : VitalStateTableType := (
			('X','-','-','-','-','X','X'),
			('-','-','-','1','-','0','1'),
			('-','0','-','0','-','S','S'),
			('-','0','-','X','0','S','S'),
			('-','1','0','0','-','0','1'),
			('-','1','0','X','-','0','1'),
			('-','1','1','0','-','1','0'),
			('-','X','0','0','0','S','S'),
			('-','X','0','X','0','S','S'),
			('-','X','1','0','1','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_negedge,
				SetupLow => tsetup_D_CLK_noedge_negedge,
				HoldHigh => thold_D_CLK_noedge_negedge,
				HoldLow => thold_D_CLK_noedge_negedge,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'F',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchr",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_negedge_negedge,
				Removal => thold_R_CLK_noedge_negedge,
				ActiveLow => FALSE,
				CheckEnabled => TRUE,
				RefTransition => 'F',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchr",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_R_EQ_0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchr",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => tpw_R_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchr",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Rviol_0 or Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => LATCH_R_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, R_ipd
			),
			NumStates => 1,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => D_ipd'LAST_EVENT,
					PathDelay => tpd_D_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end latchr_arch;

--%END latchr

--%BEGIN latchs

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity latchs is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_D_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_posedge_negedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_negedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_1_posedge : VitalDelayType := 0 ns;
		tpw_S_negedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of latchs : entity is TRUE;
end latchs;

architecture latchs_arch of latchs is
	attribute VITAL_LEVEL1 of latchs_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 1);
		CONSTANT LATCH_S_table : VitalStateTableType := (
			('X','-','-','-','-','X','X'),
			('-','-','-','1','-','1','0'),
			('-','0','-','0','-','S','S'),
			('-','0','-','X','1','S','S'),
			('-','1','1','0','-','1','0'),
			('-','1','1','X','-','1','0'),
			('-','1','0','0','-','0','1'),
			('-','X','1','0','1','S','S'),
			('-','X','1','X','1','S','S'),
			('-','X','0','0','0','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_negedge,
				SetupLow => tsetup_D_CLK_noedge_negedge,
				HoldHigh => thold_D_CLK_noedge_negedge,
				HoldLow => thold_D_CLK_noedge_negedge,
				CheckEnabled => (S_ipd = '1'),
				RefTransition => 'F',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_posedge_negedge,
				Removal => thold_S_CLK_noedge_negedge,
				ActiveLow => TRUE,
				CheckEnabled => TRUE,
				RefTransition => 'F',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_S_EQ_1_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (S_ipd = '1'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_negedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (S_ipd);
		Violation_0 := Tviol_0 or Rviol_0 or Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => LATCH_S_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, INT_RES_0
			),
			NumStates => 1,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => D_ipd'LAST_EVENT,
					PathDelay => tpd_D_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end latchs_arch;

--%END latchs

--%BEGIN latchs_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity latchs_ni is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_D_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_negedge_negedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_negedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_S_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of latchs_ni : entity is TRUE;
end latchs_ni;

architecture latchs_ni_arch of latchs_ni is
	attribute VITAL_LEVEL1 of latchs_ni_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 1);
		CONSTANT LATCH_S_table : VitalStateTableType := (
			('X','-','-','-','-','X','X'),
			('-','-','-','1','-','1','0'),
			('-','0','-','0','-','S','S'),
			('-','0','-','X','1','S','S'),
			('-','1','1','0','-','1','0'),
			('-','1','1','X','-','1','0'),
			('-','1','0','0','-','0','1'),
			('-','X','1','0','1','S','S'),
			('-','X','1','X','1','S','S'),
			('-','X','0','0','0','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_negedge,
				SetupLow => tsetup_D_CLK_noedge_negedge,
				HoldHigh => thold_D_CLK_noedge_negedge,
				HoldLow => thold_D_CLK_noedge_negedge,
				CheckEnabled => (S_ipd = '0'),
				RefTransition => 'F',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs_ni",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_negedge_negedge,
				Removal => thold_S_CLK_noedge_negedge,
				ActiveLow => TRUE,
				CheckEnabled => TRUE,
				RefTransition => 'F',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs_ni",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_S_EQ_0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs_ni",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_posedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchs_ni",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Rviol_0 or Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => LATCH_S_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, S_ipd
			),
			NumStates => 1,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => D_ipd'LAST_EVENT,
					PathDelay => tpd_D_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end latchs_ni_arch;

--%END latchs_ni

--%BEGIN latchsr

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity latchsr is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_D_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_R_EQ_0_posedge_negedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_S_EQ_1_negedge_negedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_negedge : VitalDelayType := 0 ns;
		tpw_CLK_cond0_posedge : VitalDelayType := 0 ns;
		tpw_S_R_EQ_0_negedge : VitalDelayType := 0 ns;
		tpw_R_S_EQ_1_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		R : in STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of latchsr : entity is TRUE;
end latchsr;

architecture latchsr_arch of latchsr is
	attribute VITAL_LEVEL1 of latchsr_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_1 : X01 := '0';
		VARIABLE RecoRemoInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_2 : X01 := '0';
		VARIABLE PeriodDataInfo_2 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 4);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 1);
		CONSTANT LATCH_SR_X0_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X'),
			('-','-','-','0','1','-','0','1'),
			('-','-','-','1','0','-','1','0'),
			('-','-','-','1','1','-','X','0'),
			('X','-','-','-','-','-','X','X'),
			('-','-','-','1','0','-','1','0'),
			('-','-','-','-','1','-','0','1'),
			('-','0','-','0','0','-','S','S'),
			('-','0','-','X','0','1','S','S'),
			('-','0','-','0','X','0','S','S'),
			('-','1','0','0','0','-','0','1'),
			('-','1','0','0','X','-','0','1'),
			('-','1','1','X','0','-','1','0'),
			('-','1','1','0','0','-','1','0'),
			('-','X','0','0','0','0','S','S'),
			('-','X','0','0','X','0','S','S'),
			('-','X','1','0','0','1','S','S'),
			('-','X','1','X','0','1','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_negedge,
				SetupLow => tsetup_D_CLK_noedge_negedge,
				HoldHigh => thold_D_CLK_noedge_negedge,
				HoldLow => thold_D_CLK_noedge_negedge,
				CheckEnabled => ((S_ipd = '1') AND 
					(R_ipd = '0')),
				RefTransition => 'F',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_R_EQ_0_posedge_negedge,
				Removal => thold_S_CLK_noedge_negedge,
				ActiveLow => TRUE,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'F',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_S_EQ_1_negedge_negedge,
				Removal => thold_R_CLK_noedge_negedge,
				ActiveLow => FALSE,
				CheckEnabled => (S_ipd = '1'),
				RefTransition => 'F',
				TimingData => RecoRemoInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr",
				Violation => Rviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_cond0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => ((S_ipd = '1') AND 
					(R_ipd = '0')),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_R_EQ_0_negedge,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => tpw_R_S_EQ_1_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (S_ipd = '1'),
				PeriodData => PeriodDataInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr",
				Violation => Pviol_2,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (S_ipd);
		Violation_0 := Tviol_0 or Rviol_0 or Rviol_1 or Pviol_0 or 
				Pviol_1 or Pviol_2;
		VitalStateTable (
			StateTable => LATCH_SR_X0_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, INT_RES_0, R_ipd
			),
			NumStates => 1,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => D_ipd'LAST_EVENT,
					PathDelay => tpd_D_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end latchsr_arch;

--%END latchsr

--%BEGIN latchsr_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity latchsr_ni is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_D_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_negedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_R_EQ_0_negedge_negedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_S_EQ_0_negedge_negedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_negedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_negedge : VitalDelayType := 0 ns;
		tpw_CLK_cond0_posedge : VitalDelayType := 0 ns;
		tpw_S_R_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_R_S_EQ_0_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		R : in STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of latchsr_ni : entity is TRUE;
end latchsr_ni;

architecture latchsr_ni_arch of latchsr_ni is
	attribute VITAL_LEVEL1 of latchsr_ni_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (S_ipd, S, tipd_S);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, D_ipd, S_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_1 : X01 := '0';
		VARIABLE RecoRemoInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_2 : X01 := '0';
		VARIABLE PeriodDataInfo_2 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 4);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 1);
		CONSTANT LATCH_SR_X0_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X'),
			('-','-','-','0','1','-','0','1'),
			('-','-','-','1','0','-','1','0'),
			('-','-','-','1','1','-','X','0'),
			('X','-','-','-','-','-','X','X'),
			('-','-','-','1','0','-','1','0'),
			('-','-','-','-','1','-','0','1'),
			('-','0','-','0','0','-','S','S'),
			('-','0','-','X','0','1','S','S'),
			('-','0','-','0','X','0','S','S'),
			('-','1','0','0','0','-','0','1'),
			('-','1','0','0','X','-','0','1'),
			('-','1','1','X','0','-','1','0'),
			('-','1','1','0','0','-','1','0'),
			('-','X','0','0','0','0','S','S'),
			('-','X','0','0','X','0','S','S'),
			('-','X','1','0','0','1','S','S'),
			('-','X','1','X','0','1','S','S')
		);
		ALIAS INT_RES_0 : STD_LOGIC is Results_0(1);
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_negedge,
				SetupLow => tsetup_D_CLK_noedge_negedge,
				HoldHigh => thold_D_CLK_noedge_negedge,
				HoldLow => thold_D_CLK_noedge_negedge,
				CheckEnabled => ((S_ipd = '0') AND 
					(R_ipd = '0')),
				RefTransition => 'F',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr_ni",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_R_EQ_0_negedge_negedge,
				Removal => thold_S_CLK_noedge_negedge,
				ActiveLow => TRUE,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'F',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr_ni",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_S_EQ_0_negedge_negedge,
				Removal => thold_R_CLK_noedge_negedge,
				ActiveLow => FALSE,
				CheckEnabled => (S_ipd = '0'),
				RefTransition => 'F',
				TimingData => RecoRemoInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr_ni",
				Violation => Rviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_cond0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => ((S_ipd = '0') AND 
					(R_ipd = '0')),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr_ni",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_S_R_EQ_0_posedge,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr_ni",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => tpw_R_S_EQ_0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/latchsr_ni",
				Violation => Pviol_2,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		Violation_0 := Tviol_0 or Rviol_0 or Rviol_1 or Pviol_0 or 
				Pviol_1 or Pviol_2;
		VitalStateTable (
			StateTable => LATCH_SR_X0_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, D_ipd, S_ipd, R_ipd
			),
			NumStates => 1,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => D_ipd'LAST_EVENT,
					PathDelay => tpd_D_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end latchsr_ni_arch;

--%END latchsr_ni

--%BEGIN mux21

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity mux21 is
 	generic (
		tipd_S0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		S0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of mux21 : entity is TRUE;
end mux21;

architecture mux21_arch of mux21 is
	attribute VITAL_LEVEL1 of mux21_arch : architecture is TRUE;
	signal S0_ipd : STD_LOGIC := 'X';
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (S0_ipd, S0, tipd_S0);
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (S0_ipd, A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (A1_ipd, A0_ipd, S0_ipd);
		INT_RES_1 := VitalInv (INT_RES_0);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => S0_ipd'LAST_EVENT,
					PathDelay => tpd_S0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end mux21_arch;

--%END mux21

--%BEGIN mux21_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity mux21_ni is
 	generic (
		tipd_S0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		S0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of mux21_ni : entity is TRUE;
end mux21_ni;

architecture mux21_ni_arch of mux21_ni is
	attribute VITAL_LEVEL1 of mux21_ni_arch : architecture is TRUE;
	signal S0_ipd : STD_LOGIC := 'X';
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (S0_ipd, S0, tipd_S0);
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (S0_ipd, A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (A1_ipd, A0_ipd, S0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => S0_ipd'LAST_EVENT,
					PathDelay => tpd_S0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end mux21_ni_arch;

--%END mux21_ni

--%BEGIN nand02

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nand02 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nand02 : entity is TRUE;
end nand02;

architecture nand02_arch of nand02 is
	attribute VITAL_LEVEL1 of nand02_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNand2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nand02_arch;

--%END nand02

--%BEGIN nand02_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nand02_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nand02_2x : entity is TRUE;
end nand02_2x;

architecture nand02_2x_arch of nand02_2x is
	attribute VITAL_LEVEL1 of nand02_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNand2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nand02_2x_arch;

--%END nand02_2x

--%BEGIN nand03

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nand03 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nand03 : entity is TRUE;
end nand03;

architecture nand03_arch of nand03 is
	attribute VITAL_LEVEL1 of nand03_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNand3 (A0_ipd, A1_ipd, A2_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nand03_arch;

--%END nand03

--%BEGIN nand03_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nand03_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nand03_2x : entity is TRUE;
end nand03_2x;

architecture nand03_2x_arch of nand03_2x is
	attribute VITAL_LEVEL1 of nand03_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNand3 (A0_ipd, A1_ipd, A2_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nand03_2x_arch;

--%END nand03_2x

--%BEGIN nand04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nand04 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nand04 : entity is TRUE;
end nand04;

architecture nand04_arch of nand04 is
	attribute VITAL_LEVEL1 of nand04_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNand4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nand04_arch;

--%END nand04

--%BEGIN nand04_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nand04_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nand04_2x : entity is TRUE;
end nand04_2x;

architecture nand04_2x_arch of nand04_2x is
	attribute VITAL_LEVEL1 of nand04_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNand4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nand04_2x_arch;

--%END nand04_2x

--%BEGIN nor02

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor02 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor02 : entity is TRUE;
end nor02;

architecture nor02_arch of nor02 is
	attribute VITAL_LEVEL1 of nor02_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNor2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor02_arch;

--%END nor02

--%BEGIN nor02_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor02_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor02_2x : entity is TRUE;
end nor02_2x;

architecture nor02_2x_arch of nor02_2x is
	attribute VITAL_LEVEL1 of nor02_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNor2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor02_2x_arch;

--%END nor02_2x

--%BEGIN nor02ii

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor02ii is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor02ii : entity is TRUE;
end nor02ii;

architecture nor02ii_arch of nor02ii is
	attribute VITAL_LEVEL1 of nor02ii_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A1_ipd);
		INT_RES_1 := VitalNor2 (A0_ipd, INT_RES_0);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor02ii_arch;

--%END nor02ii

--%BEGIN nor03

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor03 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor03 : entity is TRUE;
end nor03;

architecture nor03_arch of nor03 is
	attribute VITAL_LEVEL1 of nor03_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNor3 (A0_ipd, A1_ipd, A2_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor03_arch;

--%END nor03

--%BEGIN nor03_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor03_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor03_2x : entity is TRUE;
end nor03_2x;

architecture nor03_2x_arch of nor03_2x is
	attribute VITAL_LEVEL1 of nor03_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNor3 (A0_ipd, A1_ipd, A2_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor03_2x_arch;

--%END nor03_2x

--%BEGIN nor04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor04 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor04 : entity is TRUE;
end nor04;

architecture nor04_arch of nor04 is
	attribute VITAL_LEVEL1 of nor04_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNor4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor04_arch;

--%END nor04

--%BEGIN nor04_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity nor04_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of nor04_2x : entity is TRUE;
end nor04_2x;

architecture nor04_2x_arch of nor04_2x is
	attribute VITAL_LEVEL1 of nor04_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalNor4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end nor04_2x_arch;

--%END nor04_2x

--%BEGIN oai21

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai21 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai21 : entity is TRUE;
end oai21;

architecture oai21_arch of oai21 is
	attribute VITAL_LEVEL1 of oai21_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalNand2 (INT_RES_0, B0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai21_arch;

--%END oai21

--%BEGIN oai22

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai22 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai22 : entity is TRUE;
end oai22;

architecture oai22_arch of oai22 is
	attribute VITAL_LEVEL1 of oai22_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNand2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai22_arch;

--%END oai22

--%BEGIN oai221

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai221 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai221 : entity is TRUE;
end oai221;

architecture oai221_arch of oai221 is
	attribute VITAL_LEVEL1 of oai221_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd, 
				C0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNand3 (INT_RES_0, INT_RES_1, C0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai221_arch;

--%END oai221

--%BEGIN oai222

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai222 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai222 : entity is TRUE;
end oai222;

architecture oai222_arch of oai222 is
	attribute VITAL_LEVEL1 of oai222_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, B0_ipd, B1_ipd, 
				C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr2 (A0_ipd, A1_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalOr2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNand3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai222_arch;

--%END oai222

--%BEGIN oai32

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai32 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai32 : entity is TRUE;
end oai32;

architecture oai32_arch of oai32 is
	attribute VITAL_LEVEL1 of oai32_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNand2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai32_arch;

--%END oai32

--%BEGIN oai321

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai321 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai321 : entity is TRUE;
end oai321;

architecture oai321_arch of oai321 is
	attribute VITAL_LEVEL1 of oai321_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, C0_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalNand3 (INT_RES_0, INT_RES_1, C0_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai321_arch;

--%END oai321

--%BEGIN oai322

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai322 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai322 : entity is TRUE;
end oai322;

architecture oai322_arch of oai322 is
	attribute VITAL_LEVEL1 of oai322_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalOr2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNand3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai322_arch;

--%END oai322

--%BEGIN oai33

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai33 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai33 : entity is TRUE;
end oai33;

architecture oai33_arch of oai33 is
	attribute VITAL_LEVEL1 of oai33_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, B2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalOr3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalNand2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai33_arch;

--%END oai33

--%BEGIN oai332

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai332 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai332 : entity is TRUE;
end oai332;

architecture oai332_arch of oai332 is
	attribute VITAL_LEVEL1 of oai332_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, B2_ipd, C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalOr3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalOr2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNand3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai332_arch;

--%END oai332

--%BEGIN oai333

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai333 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		C2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai333 : entity is TRUE;
end oai333;

architecture oai333_arch of oai333 is
	attribute VITAL_LEVEL1 of oai333_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
	signal C2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
		VitalWireDelay (C2_ipd, C2, tipd_C2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, B0_ipd, 
				B1_ipd, B2_ipd, C0_ipd, C1_ipd, 
				C2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);
		INT_RES_1 := VitalOr3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalOr3 (C0_ipd, C1_ipd, C2_ipd);
		INT_RES_3 := VitalNand3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				),
				8 => (
					InputChangeTime => C2_ipd'LAST_EVENT,
					PathDelay => tpd_C2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai333_arch;

--%END oai333

--%BEGIN oai422

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai422 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_C1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_C1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		C0 : in STD_LOGIC;
		C1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai422 : entity is TRUE;
end oai422;

architecture oai422_arch of oai422 is
	attribute VITAL_LEVEL1 of oai422_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal C0_ipd : STD_LOGIC := 'X';
	signal C1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (C0_ipd, C0, tipd_C0);
		VitalWireDelay (C1_ipd, C1, tipd_C1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd, 
				B0_ipd, B1_ipd, C0_ipd, C1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE INT_RES_3 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);
		INT_RES_1 := VitalOr2 (B0_ipd, B1_ipd);
		INT_RES_2 := VitalOr2 (C0_ipd, C1_ipd);
		INT_RES_3 := VitalNand3 (INT_RES_0, INT_RES_1, INT_RES_2);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => C0_ipd'LAST_EVENT,
					PathDelay => tpd_C0_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => C1_ipd'LAST_EVENT,
					PathDelay => tpd_C1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai422_arch;

--%END oai422

--%BEGIN oai43

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai43 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai43 : entity is TRUE;
end oai43;

architecture oai43_arch of oai43 is
	attribute VITAL_LEVEL1 of oai43_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd, 
				B0_ipd, B1_ipd, B2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);
		INT_RES_1 := VitalOr3 (B0_ipd, B1_ipd, B2_ipd);
		INT_RES_2 := VitalNand2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai43_arch;

--%END oai43

--%BEGIN oai44

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity oai44 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_B3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_B3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		B0 : in STD_LOGIC;
		B1 : in STD_LOGIC;
		B2 : in STD_LOGIC;
		B3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of oai44 : entity is TRUE;
end oai44;

architecture oai44_arch of oai44 is
	attribute VITAL_LEVEL1 of oai44_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
	signal B0_ipd : STD_LOGIC := 'X';
	signal B1_ipd : STD_LOGIC := 'X';
	signal B2_ipd : STD_LOGIC := 'X';
	signal B3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
		VitalWireDelay (B0_ipd, B0, tipd_B0);
		VitalWireDelay (B1_ipd, B1, tipd_B1);
		VitalWireDelay (B2_ipd, B2, tipd_B2);
		VitalWireDelay (B3_ipd, B3, tipd_B3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd, 
				B0_ipd, B1_ipd, B2_ipd, B3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE INT_RES_2 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);
		INT_RES_1 := VitalOr4 (B0_ipd, B1_ipd, B2_ipd, B3_ipd);
		INT_RES_2 := VitalNand2 (INT_RES_0, INT_RES_1);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				),
				4 => (
					InputChangeTime => B0_ipd'LAST_EVENT,
					PathDelay => tpd_B0_Y,
					PathCondition => TRUE
				),
				5 => (
					InputChangeTime => B1_ipd'LAST_EVENT,
					PathDelay => tpd_B1_Y,
					PathCondition => TRUE
				),
				6 => (
					InputChangeTime => B2_ipd'LAST_EVENT,
					PathDelay => tpd_B2_Y,
					PathCondition => TRUE
				),
				7 => (
					InputChangeTime => B3_ipd'LAST_EVENT,
					PathDelay => tpd_B3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end oai44_arch;

--%END oai44

--%BEGIN or02

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity or02 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of or02 : entity is TRUE;
end or02;

architecture or02_arch of or02 is
	attribute VITAL_LEVEL1 of or02_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end or02_arch;

--%END or02

--%BEGIN or03

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity or03 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of or03 : entity is TRUE;
end or03;

architecture or03_arch of or03 is
	attribute VITAL_LEVEL1 of or03_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr3 (A0_ipd, A1_ipd, A2_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end or03_arch;

--%END or03

--%BEGIN or04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity or04 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A2 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A3 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A2_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A3_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		A2 : in STD_LOGIC;
		A3 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of or04 : entity is TRUE;
end or04;

architecture or04_arch of or04 is
	attribute VITAL_LEVEL1 of or04_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
	signal A2_ipd : STD_LOGIC := 'X';
	signal A3_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
		VitalWireDelay (A2_ipd, A2, tipd_A2);
		VitalWireDelay (A3_ipd, A3, tipd_A3);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd, A2_ipd, A3_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalOr4 (A0_ipd, A1_ipd, A2_ipd, A3_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => A2_ipd'LAST_EVENT,
					PathDelay => tpd_A2_Y,
					PathCondition => TRUE
				),
				3 => (
					InputChangeTime => A3_ipd'LAST_EVENT,
					PathDelay => tpd_A3_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end or04_arch;

--%END or04

--%BEGIN sff

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity sff is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SE : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SI : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_posedge : VitalDelayType := 0 ns;
		tpw_CLK_negedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		SI : in STD_LOGIC;
		SE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of sff : entity is TRUE;
end sff;

architecture sff_arch of sff is
	attribute VITAL_LEVEL1 of sff_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal SE_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal SI_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (SE_ipd, SE, tipd_SE);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (SI_ipd, SI, tipd_SI);
	end Block;

	VitalBehavior : Process (CLK_ipd, SE_ipd, D_ipd, SI_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_1 : X01 := '0';
		VARIABLE SetupHoldInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_2 : X01 := '0';
		VARIABLE SetupHoldInfo_2 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 2);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_table : VitalStateTableType := (
			('X','-','-','-','-','X','X','X'),
			('-','^','0','0','-','X','0','1'),
			('-','^','1','0','-','X','1','0'),
			('-','^','0','1','0','X','0','1'),
			('-','^','1','1','1','X','1','0'),
			('-','f','0','-','0','1','S','S'),
			('-','f','0','-','1','1','X','X'),
			('-','f','1','-','1','1','S','S'),
			('-','f','1','-','0','1','X','X'),
			('-','v','B','B','-','X','S','S'),
			('-','r','0','-','0','0','S','S'),
			('-','r','0','-','-','0','X','X'),
			('-','r','1','-','1','0','S','S'),
			('-','r','1','-','-','0','X','X'),
			('-','/','0','-','-','X','0','1'),
			('-','/','1','-','-','X','1','0'),
			('-','\','-','-','-','X','S','S'),
			('-','*','-','-','-','X','X','X'),
			('-','B','*','-','-','X','S','S'),
			('-','-','*','-','-','X','S','S'),
			('-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => SE_ipd, TestSignalName => "SE",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SE_CLK_noedge_posedge,
				SetupLow => tsetup_SE_CLK_noedge_posedge,
				HoldHigh => thold_SE_CLK_noedge_posedge,
				HoldLow => thold_SE_CLK_noedge_posedge,
				CheckEnabled => (((SI_ipd = '1') AND 
					(D_ipd = '0')) OR 
					((SI_ipd = '0') AND 
					(D_ipd = '1'))),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sff",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => (SE_ipd = '0'),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sff",
				Violation => Tviol_1,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => SI_ipd, TestSignalName => "SI",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SI_CLK_noedge_posedge,
				SetupLow => tsetup_SI_CLK_noedge_posedge,
				HoldHigh => thold_SI_CLK_noedge_posedge,
				HoldLow => thold_SI_CLK_noedge_posedge,
				CheckEnabled => (SE_ipd = '1'),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sff",
				Violation => Tviol_2,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_posedge,
				PulseWidthLow => tpw_CLK_negedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sff",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (SI_ipd, D_ipd, SE_ipd);
		Violation_0 := Tviol_0 or Tviol_1 or Tviol_2 or Pviol_0;
		VitalStateTable (
			StateTable => DFF_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, INT_RES_0
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end sff_arch;

--%END sff

--%BEGIN sffr

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity sffr is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SE : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SI : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_posedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_1_posedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_1_negedge : VitalDelayType := 0 ns;
		tpw_R_negedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		SI : in STD_LOGIC;
		SE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of sffr : entity is TRUE;
end sffr;

architecture sffr_arch of sffr is
	attribute VITAL_LEVEL1 of sffr_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal SE_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal SI_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (SE_ipd, SE, tipd_SE);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (SI_ipd, SI, tipd_SI);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, SE_ipd, D_ipd, SI_ipd, 
				R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_1 : X01 := '0';
		VARIABLE SetupHoldInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_2 : X01 := '0';
		VARIABLE SetupHoldInfo_2 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_R_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X','X'),
			('-','-','-','1','-','-','S','0','1'),
			('-','B','-','n','-','0','X','S','S'),
			('-','X','0','n','-','0','0','S','S'),
			('-','X','-','n','-','-','X','X','X'),
			('-','-','0','v','-','-','S','S','S'),
			('-','B','-','v','-','-','X','S','S'),
			('-','-','0','r','-','0','S','S','S'),
			('-','B','-','r','-','0','X','S','S'),
			('-','-','0','r','-','-','S','X','X'),
			('-','-','-','*','-','-','X','X','X'),
			('-','^','0','-','0','-','X','0','1'),
			('-','^','1','0','0','-','X','1','0'),
			('-','^','0','-','1','0','X','0','1'),
			('-','^','1','0','1','1','X','1','0'),
			('-','f','0','-','-','0','1','S','S'),
			('-','f','0','-','-','1','1','X','X'),
			('-','f','1','0','-','1','1','S','S'),
			('-','f','1','0','-','0','1','X','X'),
			('-','v','0','-','B','-','X','S','S'),
			('-','v','1','0','B','-','X','S','S'),
			('-','r','0','-','-','0','0','S','S'),
			('-','r','0','-','-','-','0','X','X'),
			('-','r','1','0','-','1','0','S','S'),
			('-','r','1','0','-','-','0','X','X'),
			('-','/','0','-','-','-','X','0','1'),
			('-','/','1','0','-','-','X','1','0'),
			('-','\','-','-','-','-','X','S','S'),
			('-','*','-','-','-','-','X','X','X'),
			('-','B','*','-','-','-','X','S','S'),
			('-','-','*','0','-','-','X','S','S'),
			('-','-','*','-','-','0','X','S','S'),
			('-','-','*','-','-','-','X','X','X'),
			('-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_3 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => SE_ipd, TestSignalName => "SE",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SE_CLK_noedge_posedge,
				SetupLow => tsetup_SE_CLK_noedge_posedge,
				HoldHigh => thold_SE_CLK_noedge_posedge,
				HoldLow => thold_SE_CLK_noedge_posedge,
				CheckEnabled => (((SI_ipd = '1') AND 
					(D_ipd = '0') AND 
					(R_ipd = '1')) OR 
					((SI_ipd = '0') AND 
					(D_ipd = '1') AND 
					(R_ipd = '1'))),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '0') AND 
					(R_ipd = '1')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr",
				Violation => Tviol_1,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => SI_ipd, TestSignalName => "SI",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SI_CLK_noedge_posedge,
				SetupLow => tsetup_SI_CLK_noedge_posedge,
				HoldHigh => thold_SI_CLK_noedge_posedge,
				HoldLow => thold_SI_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '1') AND 
					(R_ipd = '1')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr",
				Violation => Tviol_2,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_posedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_R_EQ_1_posedge,
				PulseWidthLow => tpw_CLK_R_EQ_1_negedge,
				CheckEnabled => (R_ipd = '1'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_R_negedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (SI_ipd, D_ipd, SE_ipd);
		INT_RES_1 := VitalInv (R_ipd);
		Violation_0 := Tviol_0 or Tviol_1 or Tviol_2 or Rviol_0 or 
				Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => DFF_R_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, INT_RES_0, INT_RES_1
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end sffr_arch;

--%END sffr

--%BEGIN sffr_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity sffr_ni is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SE : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SI : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_negedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_CLK_R_EQ_0_negedge : VitalDelayType := 0 ns;
		tpw_R_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		SI : in STD_LOGIC;
		SE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of sffr_ni : entity is TRUE;
end sffr_ni;

architecture sffr_ni_arch of sffr_ni is
	attribute VITAL_LEVEL1 of sffr_ni_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal SE_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal SI_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (SE_ipd, SE, tipd_SE);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (SI_ipd, SI, tipd_SI);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, SE_ipd, D_ipd, SI_ipd, 
				R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_1 : X01 := '0';
		VARIABLE SetupHoldInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_2 : X01 := '0';
		VARIABLE SetupHoldInfo_2 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_R_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X','X'),
			('-','-','-','1','-','-','S','0','1'),
			('-','B','-','n','-','0','X','S','S'),
			('-','X','0','n','-','0','0','S','S'),
			('-','X','-','n','-','-','X','X','X'),
			('-','-','0','v','-','-','S','S','S'),
			('-','B','-','v','-','-','X','S','S'),
			('-','-','0','r','-','0','S','S','S'),
			('-','B','-','r','-','0','X','S','S'),
			('-','-','0','r','-','-','S','X','X'),
			('-','-','-','*','-','-','X','X','X'),
			('-','^','0','-','0','-','X','0','1'),
			('-','^','1','0','0','-','X','1','0'),
			('-','^','0','-','1','0','X','0','1'),
			('-','^','1','0','1','1','X','1','0'),
			('-','f','0','-','-','0','1','S','S'),
			('-','f','0','-','-','1','1','X','X'),
			('-','f','1','0','-','1','1','S','S'),
			('-','f','1','0','-','0','1','X','X'),
			('-','v','0','-','B','-','X','S','S'),
			('-','v','1','0','B','-','X','S','S'),
			('-','r','0','-','-','0','0','S','S'),
			('-','r','0','-','-','-','0','X','X'),
			('-','r','1','0','-','1','0','S','S'),
			('-','r','1','0','-','-','0','X','X'),
			('-','/','0','-','-','-','X','0','1'),
			('-','/','1','0','-','-','X','1','0'),
			('-','\','-','-','-','-','X','S','S'),
			('-','*','-','-','-','-','X','X','X'),
			('-','B','*','-','-','-','X','S','S'),
			('-','-','*','0','-','-','X','S','S'),
			('-','-','*','-','-','0','X','S','S'),
			('-','-','*','-','-','-','X','X','X'),
			('-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => SE_ipd, TestSignalName => "SE",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SE_CLK_noedge_posedge,
				SetupLow => tsetup_SE_CLK_noedge_posedge,
				HoldHigh => thold_SE_CLK_noedge_posedge,
				HoldLow => thold_SE_CLK_noedge_posedge,
				CheckEnabled => (((SI_ipd = '1') AND 
					(D_ipd = '0') AND 
					(R_ipd = '0')) OR 
					((SI_ipd = '0') AND 
					(D_ipd = '1') AND 
					(R_ipd = '0'))),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr_ni",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '0') AND 
					(R_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr_ni",
				Violation => Tviol_1,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => SI_ipd, TestSignalName => "SI",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SI_CLK_noedge_posedge,
				SetupLow => tsetup_SI_CLK_noedge_posedge,
				HoldHigh => thold_SI_CLK_noedge_posedge,
				HoldLow => thold_SI_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '1') AND 
					(R_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr_ni",
				Violation => Tviol_2,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_negedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr_ni",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_R_EQ_0_posedge,
				PulseWidthLow => tpw_CLK_R_EQ_0_negedge,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr_ni",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_R_posedge,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffr_ni",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (SI_ipd, D_ipd, SE_ipd);
		Violation_0 := Tviol_0 or Tviol_1 or Tviol_2 or Rviol_0 or 
				Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => DFF_R_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, INT_RES_0, R_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end sffr_ni_arch;

--%END sffr_ni

--%BEGIN sffs

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity sffs is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SE : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SI : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_negedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_CLK_S_EQ_0_negedge : VitalDelayType := 0 ns;
		tpw_S_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		SI : in STD_LOGIC;
		SE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of sffs : entity is TRUE;
end sffs;

architecture sffs_arch of sffs is
	attribute VITAL_LEVEL1 of sffs_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal SE_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal SI_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (SE_ipd, SE, tipd_SE);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (SI_ipd, SI, tipd_SI);
		VitalWireDelay (S_ipd, S, tipd_S);
	end Block;

	VitalBehavior : Process (CLK_ipd, SE_ipd, D_ipd, SI_ipd, 
				S_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_1 : X01 := '0';
		VARIABLE SetupHoldInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_2 : X01 := '0';
		VARIABLE SetupHoldInfo_2 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 3);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_S_table : VitalStateTableType := (
			('X','-','-','-','-','-','X','X','X'),
			('-','-','-','1','-','-','S','1','0'),
			('-','B','-','n','-','1','X','S','S'),
			('-','X','1','n','-','1','0','S','S'),
			('-','X','-','n','-','-','X','X','X'),
			('-','-','1','v','-','-','S','S','S'),
			('-','B','-','v','-','-','X','S','S'),
			('-','-','1','r','-','1','S','S','S'),
			('-','B','-','r','-','1','X','S','S'),
			('-','-','1','r','-','-','S','X','X'),
			('-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','0','-','X','0','1'),
			('-','^','1','-','0','-','X','1','0'),
			('-','^','0','0','1','0','X','0','1'),
			('-','^','1','-','1','1','X','1','0'),
			('-','f','0','0','-','0','1','S','S'),
			('-','f','0','0','-','1','1','X','X'),
			('-','f','1','-','-','1','1','S','S'),
			('-','f','1','-','-','0','1','X','X'),
			('-','v','0','0','B','-','X','S','S'),
			('-','v','1','-','B','-','X','S','S'),
			('-','r','0','0','-','0','0','S','S'),
			('-','r','0','0','-','-','0','X','X'),
			('-','r','1','-','-','1','0','S','S'),
			('-','r','1','-','-','-','0','X','X'),
			('-','/','0','0','-','-','X','0','1'),
			('-','/','1','-','-','-','X','1','0'),
			('-','\','-','-','-','-','X','S','S'),
			('-','*','-','-','-','-','X','X','X'),
			('-','B','*','-','-','-','X','S','S'),
			('-','-','*','0','-','-','X','S','S'),
			('-','-','*','-','-','1','X','S','S'),
			('-','-','*','-','-','-','X','X','X'),
			('-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => SE_ipd, TestSignalName => "SE",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SE_CLK_noedge_posedge,
				SetupLow => tsetup_SE_CLK_noedge_posedge,
				HoldHigh => thold_SE_CLK_noedge_posedge,
				HoldLow => thold_SE_CLK_noedge_posedge,
				CheckEnabled => (((SI_ipd = '1') AND 
					(D_ipd = '0') AND 
					(S_ipd = '0')) OR 
					((SI_ipd = '0') AND 
					(D_ipd = '1') AND 
					(S_ipd = '0'))),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffs",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '0') AND 
					(S_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffs",
				Violation => Tviol_1,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => SI_ipd, TestSignalName => "SI",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SI_CLK_noedge_posedge,
				SetupLow => tsetup_SI_CLK_noedge_posedge,
				HoldHigh => thold_SI_CLK_noedge_posedge,
				HoldLow => thold_SI_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '1') AND 
					(S_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffs",
				Violation => Tviol_2,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_negedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => FALSE,
				CheckEnabled => TRUE,
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffs",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_S_EQ_0_posedge,
				PulseWidthLow => tpw_CLK_S_EQ_0_negedge,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffs",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => tpw_S_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => TRUE,
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffs",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (SI_ipd, D_ipd, SE_ipd);
		Violation_0 := Tviol_0 or Tviol_1 or Tviol_2 or Rviol_0 or 
				Pviol_0 or Pviol_1;
		VitalStateTable (
			StateTable => DFF_S_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, INT_RES_0, S_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end sffs_arch;

--%END sffs

--%BEGIN sffsr

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity sffsr is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SE : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SI : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_R_EQ_1_negedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_S_EQ_0_posedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond3_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond3_negedge : VitalDelayType := 0 ns;
		tpw_S_R_EQ_1_posedge : VitalDelayType := 0 ns;
		tpw_R_S_EQ_0_negedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		SI : in STD_LOGIC;
		SE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of sffsr : entity is TRUE;
end sffsr;

architecture sffsr_arch of sffsr is
	attribute VITAL_LEVEL1 of sffsr_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal SE_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal SI_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (SE_ipd, SE, tipd_SE);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (SI_ipd, SI, tipd_SI);
		VitalWireDelay (S_ipd, S, tipd_S);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, SE_ipd, D_ipd, SI_ipd, 
				S_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_1 : X01 := '0';
		VARIABLE SetupHoldInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_2 : X01 := '0';
		VARIABLE SetupHoldInfo_2 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_1 : X01 := '0';
		VARIABLE RecoRemoInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_2 : X01 := '0';
		VARIABLE PeriodDataInfo_2 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 4);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_SR_01_table : VitalStateTableType := (
			('X','-','-','-','-','-','-','X','X','X'),
			('-','-','-','-','1','-','-','X','0','1'),
			('-','-','-','1','0','-','-','X','1','0'),
			('-','B','-','n','0','-','1','X','S','S'),
			('-','X','1','n','0','-','1','0','S','S'),
			('-','-','1','v','0','-','-','S','S','S'),
			('-','B','-','v','0','-','-','X','S','S'),
			('-','-','1','r','0','-','1','S','S','S'),
			('-','B','-','r','0','-','1','X','S','S'),
			('-','-','1','r','0','-','-','S','X','X'),
			('-','-','-','*','-','-','-','X','X','X'),
			('-','B','-','0','n','-','0','X','S','S'),
			('-','X','0','0','n','-','0','0','S','S'),
			('-','-','0','0','v','-','-','S','S','S'),
			('-','B','-','0','v','-','-','X','S','S'),
			('-','-','0','0','r','-','0','S','S','S'),
			('-','B','-','0','r','-','0','X','S','S'),
			('-','-','0','0','r','-','-','S','X','X'),
			('-','-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','-','0','-','X','0','1'),
			('-','^','1','-','0','0','-','X','1','0'),
			('-','^','0','0','-','1','0','X','0','1'),
			('-','^','1','-','0','1','1','X','1','0'),
			('-','f','0','0','-','-','0','1','S','S'),
			('-','f','0','0','-','-','1','1','X','X'),
			('-','f','1','-','0','-','1','1','S','S'),
			('-','f','1','-','0','-','0','1','X','X'),
			('-','v','0','0','-','B','-','X','S','S'),
			('-','v','1','-','0','B','-','X','S','S'),
			('-','r','0','0','-','-','0','0','S','S'),
			('-','r','0','0','-','-','-','0','X','X'),
			('-','r','1','-','0','-','1','0','S','S'),
			('-','r','1','-','0','-','-','0','X','X'),
			('-','/','0','0','-','-','-','X','0','1'),
			('-','/','1','-','0','-','-','X','1','0'),
			('-','\','-','-','0','-','-','X','S','S'),
			('-','\','-','0','-','-','-','X','S','S'),
			('-','*','-','-','-','-','-','X','X','X'),
			('-','B','*','0','-','-','-','X','S','S'),
			('-','B','*','-','0','-','-','X','S','S'),
			('-','-','*','0','0','-','-','X','S','S'),
			('-','-','*','0','-','-','0','X','S','S'),
			('-','-','*','-','0','-','1','X','S','S'),
			('-','-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_3 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => SE_ipd, TestSignalName => "SE",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SE_CLK_noedge_posedge,
				SetupLow => tsetup_SE_CLK_noedge_posedge,
				HoldHigh => thold_SE_CLK_noedge_posedge,
				HoldLow => thold_SE_CLK_noedge_posedge,
				CheckEnabled => (((SI_ipd = '1') AND 
					(D_ipd = '0') AND 
					(S_ipd = '0') AND 
					(R_ipd = '1')) OR 
					((SI_ipd = '0') AND 
					(D_ipd = '1') AND 
					(S_ipd = '0') AND 
					(R_ipd = '1'))),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '0') AND 
					(S_ipd = '0') AND 
					(R_ipd = '1')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Tviol_1,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => SI_ipd, TestSignalName => "SI",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SI_CLK_noedge_posedge,
				SetupLow => tsetup_SI_CLK_noedge_posedge,
				HoldHigh => thold_SI_CLK_noedge_posedge,
				HoldLow => thold_SI_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '1') AND 
					(S_ipd = '0') AND 
					(R_ipd = '1')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Tviol_2,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_R_EQ_1_negedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => FALSE,
				CheckEnabled => (R_ipd = '1'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_S_EQ_0_posedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => (S_ipd = '0'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Rviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_cond3_posedge,
				PulseWidthLow => tpw_CLK_cond3_negedge,
				CheckEnabled => ((S_ipd = '0') AND 
					(R_ipd = '1')),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => tpw_S_R_EQ_1_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (R_ipd = '1'),
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_R_S_EQ_0_negedge,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr",
				Violation => Pviol_2,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (SI_ipd, D_ipd, SE_ipd);
		INT_RES_1 := VitalInv (R_ipd);
		Violation_0 := Tviol_0 or Tviol_1 or Tviol_2 or Rviol_0 or 
				Rviol_1 or Pviol_0 or Pviol_1 or Pviol_2;
		VitalStateTable (
			StateTable => DFF_SR_01_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, INT_RES_0, S_ipd, INT_RES_1
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_3,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end sffsr_arch;

--%END sffsr

--%BEGIN sffsr_ni

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity sffsr_ni is
 	generic (
		tipd_CLK : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SE : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_D : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_SI : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_S : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_R : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_Q : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_CLK_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_S_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_R_QB : VitalDelayType01Z := VitalZeroDelay01Z;
		tsetup_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tsetup_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SE_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_D_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_SI_CLK_noedge_posedge : VitalDelayType := 0 ns;
		trecovery_S_CLK_R_EQ_0_negedge_posedge : VitalDelayType := 0 ns;
		trecovery_R_CLK_S_EQ_0_negedge_posedge : VitalDelayType := 0 ns;
		thold_S_CLK_noedge_posedge : VitalDelayType := 0 ns;
		thold_R_CLK_noedge_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond3_posedge : VitalDelayType := 0 ns;
		tpw_CLK_cond3_negedge : VitalDelayType := 0 ns;
		tpw_S_R_EQ_0_posedge : VitalDelayType := 0 ns;
		tpw_R_S_EQ_0_posedge : VitalDelayType := 0 ns;
		TimingChecksOn : BOOLEAN := TRUE;
		InstancePath : STRING := "*"
	);
	port (
		D : in STD_LOGIC;
		SI : in STD_LOGIC;
		SE : in STD_LOGIC;
		CLK : in STD_LOGIC;
		S : in STD_LOGIC;
		R : in STD_LOGIC;
		Q : out STD_LOGIC;
		QB : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of sffsr_ni : entity is TRUE;
end sffsr_ni;

architecture sffsr_ni_arch of sffsr_ni is
	attribute VITAL_LEVEL1 of sffsr_ni_arch : architecture is TRUE;
	signal CLK_ipd : STD_LOGIC := 'X';
	signal SE_ipd : STD_LOGIC := 'X';
	signal D_ipd : STD_LOGIC := 'X';
	signal SI_ipd : STD_LOGIC := 'X';
	signal S_ipd : STD_LOGIC := 'X';
	signal R_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
		VitalWireDelay (SE_ipd, SE, tipd_SE);
		VitalWireDelay (D_ipd, D, tipd_D);
		VitalWireDelay (SI_ipd, SI, tipd_SI);
		VitalWireDelay (S_ipd, S, tipd_S);
		VitalWireDelay (R_ipd, R, tipd_R);
	end Block;

	VitalBehavior : Process (CLK_ipd, SE_ipd, D_ipd, SI_ipd, 
				S_ipd, R_ipd)
		VARIABLE Tviol_0 : X01 := '0';
		VARIABLE SetupHoldInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_1 : X01 := '0';
		VARIABLE SetupHoldInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Tviol_2 : X01 := '0';
		VARIABLE SetupHoldInfo_2 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_0 : X01 := '0';
		VARIABLE RecoRemoInfo_0 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Rviol_1 : X01 := '0';
		VARIABLE RecoRemoInfo_1 : VitalTimingDataType := VitalTimingDataInit;
		VARIABLE Pviol_0 : X01 := '0';
		VARIABLE PeriodDataInfo_0 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_1 : X01 := '0';
		VARIABLE PeriodDataInfo_1 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE Pviol_2 : X01 := '0';
		VARIABLE PeriodDataInfo_2 : VitalPeriodDataType := VitalPeriodDataInit;
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE Violation_0 : X01 := '0';
		VARIABLE PrevData_0 : STD_LOGIC_VECTOR(0 to 4);
		VARIABLE Results_0 : STD_LOGIC_VECTOR(0 to 2);
		CONSTANT DFF_SR_01_table : VitalStateTableType := (
			('X','-','-','-','-','-','-','X','X','X'),
			('-','-','-','-','1','-','-','X','0','1'),
			('-','-','-','1','0','-','-','X','1','0'),
			('-','B','-','n','0','-','1','X','S','S'),
			('-','X','1','n','0','-','1','0','S','S'),
			('-','-','1','v','0','-','-','S','S','S'),
			('-','B','-','v','0','-','-','X','S','S'),
			('-','-','1','r','0','-','1','S','S','S'),
			('-','B','-','r','0','-','1','X','S','S'),
			('-','-','1','r','0','-','-','S','X','X'),
			('-','-','-','*','-','-','-','X','X','X'),
			('-','B','-','0','n','-','0','X','S','S'),
			('-','X','0','0','n','-','0','0','S','S'),
			('-','-','0','0','v','-','-','S','S','S'),
			('-','B','-','0','v','-','-','X','S','S'),
			('-','-','0','0','r','-','0','S','S','S'),
			('-','B','-','0','r','-','0','X','S','S'),
			('-','-','0','0','r','-','-','S','X','X'),
			('-','-','-','-','*','-','-','X','X','X'),
			('-','^','0','0','-','0','-','X','0','1'),
			('-','^','1','-','0','0','-','X','1','0'),
			('-','^','0','0','-','1','0','X','0','1'),
			('-','^','1','-','0','1','1','X','1','0'),
			('-','f','0','0','-','-','0','1','S','S'),
			('-','f','0','0','-','-','1','1','X','X'),
			('-','f','1','-','0','-','1','1','S','S'),
			('-','f','1','-','0','-','0','1','X','X'),
			('-','v','0','0','-','B','-','X','S','S'),
			('-','v','1','-','0','B','-','X','S','S'),
			('-','r','0','0','-','-','0','0','S','S'),
			('-','r','0','0','-','-','-','0','X','X'),
			('-','r','1','-','0','-','1','0','S','S'),
			('-','r','1','-','0','-','-','0','X','X'),
			('-','/','0','0','-','-','-','X','0','1'),
			('-','/','1','-','0','-','-','X','1','0'),
			('-','\','-','-','0','-','-','X','S','S'),
			('-','\','-','0','-','-','-','X','S','S'),
			('-','*','-','-','-','-','-','X','X','X'),
			('-','B','*','0','-','-','-','X','S','S'),
			('-','B','*','-','0','-','-','X','S','S'),
			('-','-','*','0','0','-','-','X','S','S'),
			('-','-','*','0','-','-','0','X','S','S'),
			('-','-','*','-','0','-','1','X','S','S'),
			('-','-','-','-','-','-','-','S','S','S')
		);
		ALIAS INT_RES_1 : STD_LOGIC is Results_0(1);
		ALIAS INT_RES_2 : STD_LOGIC is Results_0(2);
		VARIABLE GlitchData_Q : VitalGlitchDataType;
		VARIABLE GlitchData_QB : VitalGlitchDataType;
	begin

		------------------------------------
		--        TIMING SECTION          --
		------------------------------------

		if (TimingChecksOn) then
			VitalSetupHoldCheck (
				TestSignal => SE_ipd, TestSignalName => "SE",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SE_CLK_noedge_posedge,
				SetupLow => tsetup_SE_CLK_noedge_posedge,
				HoldHigh => thold_SE_CLK_noedge_posedge,
				HoldLow => thold_SE_CLK_noedge_posedge,
				CheckEnabled => (((SI_ipd = '1') AND 
					(D_ipd = '0') AND 
					(S_ipd = '0') AND 
					(R_ipd = '0')) OR 
					((SI_ipd = '0') AND 
					(D_ipd = '1') AND 
					(S_ipd = '0') AND 
					(R_ipd = '0'))),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Tviol_0,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => D_ipd, TestSignalName => "D",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_D_CLK_noedge_posedge,
				SetupLow => tsetup_D_CLK_noedge_posedge,
				HoldHigh => thold_D_CLK_noedge_posedge,
				HoldLow => thold_D_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '0') AND 
					(S_ipd = '0') AND 
					(R_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Tviol_1,
				MsgSeverity => ERROR
			);
			VitalSetupHoldCheck (
				TestSignal => SI_ipd, TestSignalName => "SI",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				SetupHigh => tsetup_SI_CLK_noedge_posedge,
				SetupLow => tsetup_SI_CLK_noedge_posedge,
				HoldHigh => thold_SI_CLK_noedge_posedge,
				HoldLow => thold_SI_CLK_noedge_posedge,
				CheckEnabled => ((SE_ipd = '1') AND 
					(S_ipd = '0') AND 
					(R_ipd = '0')),
				RefTransition => 'R',
				TimingData => SetupHoldInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Tviol_2,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_S_CLK_R_EQ_0_negedge_posedge,
				Removal => thold_S_CLK_noedge_posedge,
				ActiveLow => FALSE,
				CheckEnabled => (R_ipd = '0'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Rviol_0,
				MsgSeverity => ERROR
			);
			VitalRecoveryRemovalCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				RefSignal => CLK_ipd, RefSignalName => "CLK",
				Recovery => trecovery_R_CLK_S_EQ_0_negedge_posedge,
				Removal => thold_R_CLK_noedge_posedge,
				ActiveLow => TRUE,
				CheckEnabled => (S_ipd = '0'),
				RefTransition => 'R',
				TimingData => RecoRemoInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Rviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => CLK_ipd, TestSignalName => "CLK",
				Period => 0 ns,
				PulseWidthHigh => tpw_CLK_cond3_posedge,
				PulseWidthLow => tpw_CLK_cond3_negedge,
				CheckEnabled => ((S_ipd = '0') AND 
					(R_ipd = '0')),
				PeriodData => PeriodDataInfo_0,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Pviol_0,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => S_ipd, TestSignalName => "S",
				Period => 0 ns,
				PulseWidthHigh => tpw_S_R_EQ_0_posedge,
				PulseWidthLow => 0 ns,
				CheckEnabled => (R_ipd = '0'),
				PeriodData => PeriodDataInfo_1,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Pviol_1,
				MsgSeverity => ERROR
			);
			VitalPeriodPulseCheck (
				TestSignal => R_ipd, TestSignalName => "R",
				Period => 0 ns,
				PulseWidthHigh => 0 ns,
				PulseWidthLow => tpw_R_S_EQ_0_posedge,
				CheckEnabled => (S_ipd = '0'),
				PeriodData => PeriodDataInfo_2,
				MsgOn => TRUE, XOn => TRUE,
				HeaderMsg => InstancePath & "/sffsr_ni",
				Violation => Pviol_2,
				MsgSeverity => ERROR
			);
		end if;

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalMux2 (SI_ipd, D_ipd, SE_ipd);
		Violation_0 := Tviol_0 or Tviol_1 or Tviol_2 or Rviol_0 or 
				Rviol_1 or Pviol_0 or Pviol_1 or Pviol_2;
		VitalStateTable (
			StateTable => DFF_SR_01_table,
			DataIn => STD_LOGIC_VECTOR'(
				Violation_0, CLK_ipd, INT_RES_0, S_ipd, R_ipd
			),
			NumStates => 2,
			Result => Results_0,
			PreviousDataIn => PrevData_0
		);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Q,
			OutSignalName => "Q",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_Q,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_Q,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_Q,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Q,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
		VitalPathDelay01Z (
			OutSignal => QB,
			OutSignalName => "QB",
			OutTemp => INT_RES_2,
			Paths => (
				0 => (
					InputChangeTime => CLK_ipd'LAST_EVENT,
					PathDelay => tpd_CLK_QB,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => S_ipd'LAST_EVENT,
					PathDelay => tpd_S_QB,
					PathCondition => TRUE
				),
				2 => (
					InputChangeTime => R_ipd'LAST_EVENT,
					PathDelay => tpd_R_QB,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_QB,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end sffsr_ni_arch;

--%END sffsr_ni

--%BEGIN tri01

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity tri01 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_E : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_E_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		E : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of tri01 : entity is TRUE;
end tri01;

architecture tri01_arch of tri01 is
	attribute VITAL_LEVEL1 of tri01_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
	signal E_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
		VitalWireDelay (E_ipd, E, tipd_E);
	end Block;

	VitalBehavior : Process (A_ipd, E_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE INT_RES_1 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalInv (A_ipd);
		INT_RES_1 := VitalBufif1 (INT_RES_0, E_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_1,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => E_ipd'LAST_EVENT,
					PathDelay => tpd_E_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end tri01_arch;

--%END tri01

--%BEGIN trib04

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity trib04 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_E : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_E_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		E : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of trib04 : entity is TRUE;
end trib04;

architecture trib04_arch of trib04 is
	attribute VITAL_LEVEL1 of trib04_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
	signal E_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
		VitalWireDelay (E_ipd, E, tipd_E);
	end Block;

	VitalBehavior : Process (A_ipd, E_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBufif1 (A_ipd, E_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => E_ipd'LAST_EVENT,
					PathDelay => tpd_E_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end trib04_arch;

--%END trib04

--%BEGIN trib08

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity trib08 is
 	generic (
		tipd_A : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_E : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_E_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A : in STD_LOGIC;
		E : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of trib08 : entity is TRUE;
end trib08;

architecture trib08_arch of trib08 is
	attribute VITAL_LEVEL1 of trib08_arch : architecture is TRUE;
	signal A_ipd : STD_LOGIC := 'X';
	signal E_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A_ipd, A, tipd_A);
		VitalWireDelay (E_ipd, E, tipd_E);
	end Block;

	VitalBehavior : Process (A_ipd, E_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalBufif1 (A_ipd, E_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A_ipd'LAST_EVENT,
					PathDelay => tpd_A_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => E_ipd'LAST_EVENT,
					PathDelay => tpd_E_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end trib08_arch;

--%END trib08

--%BEGIN xnor2

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity xnor2 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of xnor2 : entity is TRUE;
end xnor2;

architecture xnor2_arch of xnor2 is
	attribute VITAL_LEVEL1 of xnor2_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalXnor2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end xnor2_arch;

--%END xnor2

--%BEGIN xnor2_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity xnor2_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of xnor2_2x : entity is TRUE;
end xnor2_2x;

architecture xnor2_2x_arch of xnor2_2x is
	attribute VITAL_LEVEL1 of xnor2_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalXnor2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end xnor2_2x_arch;

--%END xnor2_2x

--%BEGIN xor2

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity xor2 is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of xor2 : entity is TRUE;
end xor2;

architecture xor2_arch of xor2 is
	attribute VITAL_LEVEL1 of xor2_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalXor2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end xor2_arch;

--%END xor2

--%BEGIN xor2_2x

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

entity xor2_2x is
 	generic (
		tipd_A0 : VitalDelayType01Z := VitalZeroDelay01Z;
		tipd_A1 : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A0_Y : VitalDelayType01Z := VitalZeroDelay01Z;
		tpd_A1_Y : VitalDelayType01Z := VitalZeroDelay01Z
	);
	port (
		A0 : in STD_LOGIC;
		A1 : in STD_LOGIC;
		Y : out STD_LOGIC
	);
	attribute VITAL_LEVEL0 of xor2_2x : entity is TRUE;
end xor2_2x;

architecture xor2_2x_arch of xor2_2x is
	attribute VITAL_LEVEL1 of xor2_2x_arch : architecture is TRUE;
	signal A0_ipd : STD_LOGIC := 'X';
	signal A1_ipd : STD_LOGIC := 'X';
begin

	WireDelay : Block
	begin
		VitalWireDelay (A0_ipd, A0, tipd_A0);
		VitalWireDelay (A1_ipd, A1, tipd_A1);
	end Block;

	VitalBehavior : Process (A0_ipd, A1_ipd)
		VARIABLE INT_RES_0 : STD_LOGIC := 'X';
		VARIABLE GlitchData_Y : VitalGlitchDataType;
	begin

		------------------------------------
		--     FUNCTIONALITY SECTION      --
		------------------------------------

		INT_RES_0 := VitalXor2 (A0_ipd, A1_ipd);

		------------------------------------
		--       PATH DELAY SECTION       --
		------------------------------------

		VitalPathDelay01Z (
			OutSignal => Y,
			OutSignalName => "Y",
			OutTemp => INT_RES_0,
			Paths => (
				0 => (
					InputChangeTime => A0_ipd'LAST_EVENT,
					PathDelay => tpd_A0_Y,
					PathCondition => TRUE
				),
				1 => (
					InputChangeTime => A1_ipd'LAST_EVENT,
					PathDelay => tpd_A1_Y,
					PathCondition => TRUE
				)
			),
			GlitchData => GlitchData_Y,
			Mode => OnDetect,
			MsgOn => TRUE, Xon => TRUE,
			MsgSeverity => WARNING
		);
	end Process VitalBehavior;

end xor2_2x_arch;

--%END xor2_2x
