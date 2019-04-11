
-- 
-- Definition of  Counter
-- 
--      Thu Apr 11 17:27:33 2019
--      
--      LeonardoSpectrum Level 3, 2018a.2
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library adk;
use adk.adk_components.all;

entity Counter is
   port (
      clk : IN std_logic ;
      reset : IN std_logic ;
      enable : IN std_logic ;
      mode_in : IN std_logic ;
      max_val_in : IN std_logic_vector (4 DOWNTO 0) ;
      max_reached_out : OUT std_logic ;
      counter_out : OUT std_logic_vector (4 DOWNTO 0)) ;
end Counter ;

architecture behavioural of Counter is
   signal nx6, nx20, counter_data_4, counter_data_3, nx30, nx40, nx186, 
      nx240, nx242, nx251, nx255, nx257, nx274, nx277, nx283, nx286, nx290, 
      nx292, nx309, nx319, nx320, nx322, nx324, nx326, nx346, nx350, nx352, 
      nx354, nx360, nx362, counter_data_1, nx249, nx196, 
      counter_data_1_XX0_XREP1, nx249_XX0_XREP1, counter_data_0, nx248, 
      counter_data_0_XX0_XREP3, nx248_XX0_XREP3, counter_data_2, nx271, 
      nx206, counter_data_2_XX0_XREP5, nx271_XX0_XREP5, nx367, nx368, nx369, 
      nx370, nx371, nx372, nx373, nx374, nx340, nx375, nx376, nx377, nx226, 
      nx288, nx378, nx379, nx298, nx338, nx264, nx380, nx381, nx382, nx383, 
      nx216: std_logic ;

begin
   ix119 : nor03_2x port map ( Y=>max_reached_out, A0=>nx20, A1=>nx255, A2=>
      nx322);
   ix241 : xnor2 port map ( Y=>nx240, A0=>mode_in, A1=>nx242);
   ix252 : nand02 port map ( Y=>nx251, A0=>counter_data_1, A1=>nx338);
   ix256 : nand02 port map ( Y=>nx255, A0=>nx257, A1=>nx320);
   reg_counter_data_4 : dffr port map ( Q=>counter_data_4, QB=>nx319, D=>
      nx226, CLK=>clk, R=>reset);
   ix275 : nor02_2x port map ( Y=>nx274, A0=>nx40, A1=>nx30);
   ix41 : nor02_2x port map ( Y=>nx40, A0=>nx264, A1=>nx277);
   ix31 : nor02_2x port map ( Y=>nx30, A0=>nx283, A1=>nx286);
   ix7 : nor02_2x port map ( Y=>nx6, A0=>nx249_XX0_XREP1, A1=>
      nx248_XX0_XREP3);
   ix287 : oai21 port map ( Y=>nx286, A0=>nx271_XX0_XREP5, A1=>nx288, B0=>
      nx264);
   ix291 : nand02 port map ( Y=>nx290, A0=>counter_data_2, A1=>nx338);
   reg_counter_data_3 : dffr port map ( Q=>counter_data_3, QB=>nx292, D=>
      nx216, CLK=>clk, R=>reset);
   ix310 : nand03 port map ( Y=>nx309, A0=>counter_data_2_XX0_XREP5, A1=>
      counter_data_1_XX0_XREP1, A2=>counter_data_0_XX0_XREP3);
   ix321 : xnor2 port map ( Y=>nx320, A0=>max_val_in(0), A1=>counter_data_0
   );
   ix323 : nand02 port map ( Y=>nx322, A0=>nx324, A1=>nx326);
   ix121 : nor02_2x port map ( Y=>counter_out(0), A0=>nx340, A1=>nx248);
   ix123 : nor02_2x port map ( Y=>counter_out(1), A0=>nx340, A1=>nx249);
   ix125 : nor02_2x port map ( Y=>counter_out(2), A0=>nx340, A1=>nx271);
   ix127 : nor02_2x port map ( Y=>counter_out(3), A0=>nx340, A1=>nx292);
   ix129 : nor02_2x port map ( Y=>counter_out(4), A0=>nx340, A1=>nx319);
   ix21 : xnor2 port map ( Y=>nx20, A0=>nx249, A1=>max_val_in(1));
   ix243 : xnor2 port map ( Y=>nx242, A0=>nx248_XX0_XREP3, A1=>
      counter_data_1);
   ix187 : xnor2 port map ( Y=>nx186, A0=>nx248, A1=>enable);
   ix258 : xnor2 port map ( Y=>nx257, A0=>nx319, A1=>nx346);
   ix345 : inv01 port map ( Y=>nx346, A=>max_val_in(4));
   ix33 : nor03_2x port map ( Y=>nx350, A0=>counter_data_0_XX0_XREP3, A1=>
      counter_data_1_XX0_XREP1, A2=>counter_data_2_XX0_XREP5);
   ix278 : xnor2 port map ( Y=>nx277, A0=>nx271_XX0_XREP5, A1=>nx352);
   ix281 : nand02 port map ( Y=>nx352, A0=>nx248_XX0_XREP3, A1=>
      nx249_XX0_XREP1);
   ix284 : nor02_2x port map ( Y=>nx283, A0=>nx6, A1=>counter_data_2);
   ix302 : nand03 port map ( Y=>nx354, A0=>nx248_XX0_XREP3, A1=>
      nx249_XX0_XREP1, A2=>nx271_XX0_XREP5);
   ix325 : xnor2 port map ( Y=>nx324, A0=>nx271, A1=>nx360);
   ix359 : inv01 port map ( Y=>nx360, A=>max_val_in(2));
   ix327 : xnor2 port map ( Y=>nx326, A0=>nx292, A1=>nx362);
   ix361 : inv01 port map ( Y=>nx362, A=>max_val_in(3));
   reg_counter_data_1 : dffr port map ( Q=>counter_data_1, QB=>nx249, D=>
      nx196, CLK=>clk, R=>reset);
   ix197 : oai21 port map ( Y=>nx196, A0=>nx240, A1=>nx338, B0=>nx251);
   reg_counter_data_1_0_XREP1 : dffr port map ( Q=>counter_data_1_XX0_XREP1, 
      QB=>nx249_XX0_XREP1, D=>nx196, CLK=>clk, R=>reset);
   reg_counter_data_0 : dffr port map ( Q=>counter_data_0, QB=>nx248, D=>
      nx186, CLK=>clk, R=>reset);
   reg_counter_data_0_0_XREP3 : dffr port map ( Q=>counter_data_0_XX0_XREP3, 
      QB=>nx248_XX0_XREP3, D=>nx186, CLK=>clk, R=>reset);
   reg_counter_data_2 : dffr port map ( Q=>counter_data_2, QB=>nx271, D=>
      nx206, CLK=>clk, R=>reset);
   ix207 : oai21 port map ( Y=>nx206, A0=>nx274, A1=>nx338, B0=>nx290);
   reg_counter_data_2_0_XREP5 : dffr port map ( Q=>counter_data_2_XX0_XREP5, 
      QB=>nx271_XX0_XREP5, D=>nx206, CLK=>clk, R=>reset);
   ix384 : inv02 port map ( Y=>nx367, A=>nx319);
   ix385 : inv02 port map ( Y=>nx368, A=>nx292);
   ix386 : inv02 port map ( Y=>nx369, A=>nx350);
   ix387 : aoi322 port map ( Y=>nx370, A0=>nx350, A1=>nx292, A2=>nx367, B0=>
      nx319, B1=>nx368, C0=>nx319, C1=>nx369);
   ix388 : nand03_2x port map ( Y=>nx371, A0=>nx370, A1=>mode_in, A2=>enable
   );
   ix389 : and02 port map ( Y=>nx372, A0=>counter_data_1_XX0_XREP1, A1=>
      counter_data_0_XX0_XREP3);
   ix390 : and02 port map ( Y=>nx373, A0=>nx319, A1=>
      counter_data_2_XX0_XREP5);
   ix391 : nor02ii port map ( Y=>nx374, A0=>mode_in, A1=>enable);
   reg_nx340 : inv02 port map ( Y=>nx340, A=>enable);
   ix392 : nand04_2x port map ( Y=>nx375, A0=>counter_data_1_XX0_XREP1, A1=>
      counter_data_0_XX0_XREP3, A2=>counter_data_3, A3=>
      counter_data_2_XX0_XREP5);
   ix393 : nor03_2x port map ( Y=>nx376, A0=>nx319, A1=>nx340, A2=>mode_in);
   ix394 : aoi422 port map ( Y=>nx377, A0=>nx372, A1=>nx373, A2=>
      counter_data_3, A3=>nx374, B0=>nx340, B1=>counter_data_4, C0=>nx375, 
      C1=>nx376);
   reg_nx226 : nand02_2x port map ( Y=>nx226, A0=>nx371, A1=>nx377);
   reg_nx288 : nand02_2x port map ( Y=>nx288, A0=>counter_data_1_XX0_XREP1, 
      A1=>counter_data_0_XX0_XREP3);
   ix395 : inv02 port map ( Y=>nx378, A=>nx292);
   ix396 : inv02 port map ( Y=>nx379, A=>nx354);
   reg_nx298 : oai22 port map ( Y=>nx298, A0=>nx378, A1=>nx379, B0=>nx292, 
      B1=>nx354);
   reg_nx338 : inv02 port map ( Y=>nx338, A=>enable);
   reg_nx264 : inv02 port map ( Y=>nx264, A=>mode_in);
   ix397 : nor03_2x port map ( Y=>nx380, A0=>nx288, A1=>mode_in, A2=>
      nx271_XX0_XREP5);
   ix398 : oai21 port map ( Y=>nx381, A0=>nx292, A1=>nx309, B0=>nx380);
   ix399 : inv02 port map ( Y=>nx382, A=>counter_data_3);
   ix400 : aoi221 port map ( Y=>nx383, A0=>nx264, A1=>nx309, B0=>nx264, B1=>
      nx292, C0=>nx338);
   reg_nx216 : oai322 port map ( Y=>nx216, A0=>nx298, A1=>nx338, A2=>nx264, 
      B0=>nx338, B1=>nx381, C0=>nx382, C1=>nx383);
end behavioural ;

