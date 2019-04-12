-----------------------------------------------------------------------
--  ASIC Design Kit (ADK) Component Package                        
--
-- 3.0 Includes new library cells
--
-----------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package adk_components is
   component PadBidirHE
      port (
         DataIn : OUT std_logic ;
         DataInB : OUT std_logic ;
         Pad : INOUT std_logic ;
         DataOut : IN std_logic ;
         EN : IN std_logic) ;
   end component ;
   component PadInC
      port (
         DataIn : OUT std_logic ;
         DataInB : OUT std_logic ;
         Pad : IN std_logic) ;
   end component ;
   component PadOut
      port (
         Pad : OUT std_logic ;
         DataOut : IN std_logic) ;
   end component ;
   component and02
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component and03
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic) ;
   end component ;
   component and04
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic) ;
   end component ;
   component ao21
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic) ;
   end component ;
   component ao22
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic) ;
   end component ;
   component ao221
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic) ;
   end component ;
   component ao32
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic) ;
   end component ;
   component aoi21
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic) ;
   end component ;
   component aoi22
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic) ;
   end component ;
   component aoi221
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic) ;
   end component ;
   component aoi222
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component aoi32
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic) ;
   end component ;
   component aoi321
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic) ;
   end component ;
   component aoi322
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component aoi33
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic) ;
   end component ;
   component aoi332
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component aoi333
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic ;
         C2 : IN std_logic) ;
   end component ;
   component aoi422
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component aoi43
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic) ;
   end component ;
   component aoi44
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic ;
         B3 : IN std_logic) ;
   end component ;
   component buf02
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component buf04
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component buf08
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component buf12
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component buf16
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component dff
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic) ;
   end component ;
   component dffr
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component dffs
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic) ;
   end component ;
   component dffs_ni
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic) ;
   end component ;
   component dffsr
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component dffsr_ni
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component fadd1
      port (
         S : OUT std_logic ;
         CO : OUT std_logic ;
         A : IN std_logic ;
         B : IN std_logic ;
         CI : IN std_logic) ;
   end component ;
   component hadd1
      port (
         S : OUT std_logic ;
         CO : OUT std_logic ;
         A : IN std_logic ;
         B : IN std_logic) ;
   end component ;
   component inv01
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component inv02
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component inv04
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component inv08
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component inv12
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component inv16
      port (
         Y : OUT std_logic ;
         A : IN std_logic) ;
   end component ;
   component latch
      port (
         Q : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic) ;
   end component ;
   component latchr
      port (
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component latchs
      port (
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic) ;
   end component ;
   component latchs_ni
      port (
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic) ;
   end component ;
   component latchsr
      port (
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component latchsr_ni
      port (
         QB : OUT std_logic ;
         D : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component mux21
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         S0 : IN std_logic) ;
   end component ;
   component mux21_ni
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         S0 : IN std_logic) ;
   end component ;
   component nand02
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component nand02_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component nand03
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic) ;
   end component ;
   component nand03_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic) ;
   end component ;
   component nand04
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic) ;
   end component ;
   component nand04_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic) ;
   end component ;
   component nor02
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component nor02_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component nor02ii
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component nor03
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic) ;
   end component ;
   component nor03_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic) ;
   end component ;
   component nor04
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic) ;
   end component ;
   component nor04_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic) ;
   end component ;
   component oai21
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic) ;
   end component ;
   component oai22
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic) ;
   end component ;
   component oai221
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic) ;
   end component ;
   component oai222
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component oai32
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic) ;
   end component ;
   component oai321
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic) ;
   end component ;
   component oai322
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component oai33
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic) ;
   end component ;
   component oai332
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component oai333
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic ;
         C2 : IN std_logic) ;
   end component ;
   component oai422
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         C0 : IN std_logic ;
         C1 : IN std_logic) ;
   end component ;
   component oai43
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic) ;
   end component ;
   component oai44
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic ;
         B0 : IN std_logic ;
         B1 : IN std_logic ;
         B2 : IN std_logic ;
         B3 : IN std_logic) ;
   end component ;
   component or02
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component or03
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic) ;
   end component ;
   component or04
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic ;
         A2 : IN std_logic ;
         A3 : IN std_logic) ;
   end component ;
   component sff
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         SI : IN std_logic ;
         SE : IN std_logic ;
         CLK : IN std_logic) ;
   end component ;
   component sffr
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         SI : IN std_logic ;
         SE : IN std_logic ;
         CLK : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component sffr_ni
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         SI : IN std_logic ;
         SE : IN std_logic ;
         CLK : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component sffs
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         SI : IN std_logic ;
         SE : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic) ;
   end component ;
   component sffsr
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         SI : IN std_logic ;
         SE : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component sffsr_ni
      port (
         Q : OUT std_logic ;
         QB : OUT std_logic ;
         D : IN std_logic ;
         SI : IN std_logic ;
         SE : IN std_logic ;
         CLK : IN std_logic ;
         S : IN std_logic ;
         R : IN std_logic) ;
   end component ;
   component tri01
      port (
         Y : OUT std_logic ;
         A : IN std_logic ;
         E : IN std_logic) ;
   end component ;
   component trib04
      port (
         Y : OUT std_logic ;
         A : IN std_logic ;
         E : IN std_logic) ;
   end component ;
   component trib08
      port (
         Y : OUT std_logic ;
         A : IN std_logic ;
         E : IN std_logic) ;
   end component ;
   component xnor2
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component xnor2_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component xor2
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component xor2_2x
      port (
         Y : OUT std_logic ;
         A0 : IN std_logic ;
         A1 : IN std_logic) ;
   end component ;
   component fake_gnd
      port (
         Y : OUT std_logic) ;
   end component ;
   component fake_vcc
      port (
         Y : OUT std_logic) ;
   end component ;
end adk_components ;


package body adk_components is
end adk_components ;


