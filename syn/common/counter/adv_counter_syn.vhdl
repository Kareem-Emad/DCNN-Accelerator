
-- 
-- Definition of  AdvancedCounter
-- 
--      Thu Apr 11 17:40:46 2019
--      
--      LeonardoSpectrum Level 3, 2018a.2
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library adk;
use adk.adk_components.all;

entity AdvancedCounter is
   port (
      clk : IN std_logic ;
      reset : IN std_logic ;
      enable : IN std_logic ;
      mode_in : IN std_logic_vector (1 DOWNTO 0) ;
      max_val_in : IN std_logic_vector (4 DOWNTO 0) ;
      max_reached_out : OUT std_logic ;
      counter_out : OUT std_logic_vector (4 DOWNTO 0)) ;
end AdvancedCounter ;

architecture behavioural of AdvancedCounter is
   signal counter_data_1, nx0, counter_data_0, nx24, counter_data_4, 
      counter_data_3, counter_data_2, nx46, nx184, nx62, nx191, nx201, nx211, 
      nx221, nx245, nx252, nx255, nx259, nx262, nx264, nx266, nx269, nx271, 
      nx278, nx282, nx289, nx295, nx297, nx298, nx301, nx303, nx308, nx313, 
      nx314, nx316, nx318, nx320, nx332, nx336, nx344, nx346, nx348, nx350, 
      nx250, nx355, nx356, nx357, nx358, nx359, nx360, nx361, nx362, nx363, 
      nx364, nx365, nx304, nx285, nx291, nx366, nx2, nx16, nx334, nx367, 
      nx368, nx369, nx370, nx371, nx372, nx231: std_logic ;

begin
   ix97 : nor03_2x port map ( Y=>max_reached_out, A0=>nx24, A1=>nx269, A2=>
      nx316);
   reg_counter_data_1 : dffr port map ( Q=>counter_data_1, QB=>nx266, D=>
      nx201, CLK=>clk, R=>reset);
   ix202 : oai21 port map ( Y=>nx201, A0=>nx245, A1=>nx332, B0=>nx264);
   ix246 : xnor2 port map ( Y=>nx245, A0=>nx2, A1=>nx16);
   ix1 : xnor2 port map ( Y=>nx0, A0=>mode_in(0), A1=>mode_in(1));
   ix192 : oai21 port map ( Y=>nx191, A0=>nx255, A1=>nx332, B0=>nx259);
   ix256 : xnor2 port map ( Y=>nx255, A0=>mode_in(1), A1=>nx252);
   ix260 : nand02 port map ( Y=>nx259, A0=>counter_data_0, A1=>nx332);
   reg_counter_data_0 : dffr port map ( Q=>counter_data_0, QB=>nx252, D=>
      nx191, CLK=>clk, R=>reset);
   ix263 : inv01 port map ( Y=>nx262, A=>mode_in(1));
   ix265 : nand02 port map ( Y=>nx264, A0=>counter_data_1, A1=>nx332);
   ix270 : nand02 port map ( Y=>nx269, A0=>nx271, A1=>nx314);
   reg_counter_data_4 : dffr port map ( Q=>counter_data_4, QB=>nx313, D=>
      nx231, CLK=>clk, R=>reset);
   ix63 : oai21 port map ( Y=>nx62, A0=>nx278, A1=>nx304, B0=>nx308);
   reg_counter_data_3 : dffr port map ( Q=>counter_data_3, QB=>nx303, D=>
      nx221, CLK=>clk, R=>reset);
   ix222 : oai21 port map ( Y=>nx221, A0=>nx282, A1=>nx332, B0=>nx301);
   ix283 : xnor2 port map ( Y=>nx282, A0=>nx46, A1=>nx184);
   ix47 : oai21 port map ( Y=>nx46, A0=>nx285, A1=>nx291, B0=>nx298);
   reg_counter_data_2 : dffr port map ( Q=>counter_data_2, QB=>nx297, D=>
      nx211, CLK=>clk, R=>reset);
   ix212 : oai21 port map ( Y=>nx211, A0=>nx289, A1=>nx332, B0=>nx295);
   ix290 : xnor2 port map ( Y=>nx289, A0=>nx285, A1=>nx366);
   ix296 : nand02 port map ( Y=>nx295, A0=>counter_data_2, A1=>nx332);
   ix299 : nand02 port map ( Y=>nx298, A0=>mode_in(0), A1=>counter_data_2);
   ix302 : nand02 port map ( Y=>nx301, A0=>counter_data_3, A1=>nx334);
   ix309 : nand02 port map ( Y=>nx308, A0=>counter_data_3, A1=>mode_in(0));
   ix317 : nand02 port map ( Y=>nx316, A0=>nx318, A1=>nx320);
   ix99 : nor02_2x port map ( Y=>counter_out(0), A0=>nx334, A1=>nx252);
   ix101 : nor02_2x port map ( Y=>counter_out(1), A0=>nx334, A1=>nx266);
   ix103 : nor02_2x port map ( Y=>counter_out(2), A0=>nx334, A1=>nx297);
   ix105 : nor02_2x port map ( Y=>counter_out(3), A0=>nx334, A1=>nx303);
   ix107 : nor02_2x port map ( Y=>counter_out(4), A0=>nx336, A1=>nx313);
   ix331 : inv02 port map ( Y=>nx332, A=>enable);
   ix335 : inv02 port map ( Y=>nx336, A=>enable);
   ix25 : xnor2 port map ( Y=>nx24, A0=>nx266, A1=>max_val_in(1));
   ix272 : xnor2 port map ( Y=>nx271, A0=>nx313, A1=>nx344);
   ix343 : inv01 port map ( Y=>nx344, A=>max_val_in(4));
   ix279 : xnor2 port map ( Y=>nx278, A0=>nx303, A1=>nx250);
   ix55 : xnor2 port map ( Y=>nx184, A0=>nx303, A1=>mode_in(0));
   ix315 : xnor2 port map ( Y=>nx314, A0=>nx252, A1=>nx346);
   ix345 : inv01 port map ( Y=>nx346, A=>max_val_in(0));
   ix319 : xnor2 port map ( Y=>nx318, A0=>nx297, A1=>nx348);
   ix347 : inv01 port map ( Y=>nx348, A=>max_val_in(2));
   ix321 : xnor2 port map ( Y=>nx320, A0=>nx303, A1=>nx350);
   ix349 : inv01 port map ( Y=>nx350, A=>max_val_in(3));
   reg_nx250 : inv02 port map ( Y=>nx250, A=>mode_in(0));
   ix373 : inv02 port map ( Y=>nx355, A=>nx262);
   ix374 : oai221 port map ( Y=>nx356, A0=>nx250, A1=>nx262, B0=>nx355, B1=>
      mode_in(0), C0=>counter_data_1);
   ix375 : inv02 port map ( Y=>nx357, A=>nx266);
   ix376 : inv02 port map ( Y=>nx358, A=>nx0);
   ix377 : aoi22 port map ( Y=>nx359, A0=>nx0, A1=>nx357, B0=>nx266, B1=>
      nx358);
   ix378 : inv02 port map ( Y=>nx360, A=>nx252);
   ix379 : inv02 port map ( Y=>nx361, A=>mode_in(1));
   ix380 : aoi22 port map ( Y=>nx362, A0=>mode_in(0), A1=>mode_in(1), B0=>
      nx360, B1=>nx361);
   ix381 : aoi22 port map ( Y=>nx363, A0=>nx356, A1=>nx359, B0=>nx356, B1=>
      nx362);
   ix382 : nor02ii port map ( Y=>nx364, A0=>nx297, A1=>mode_in(0));
   ix383 : inv02 port map ( Y=>nx365, A=>nx297);
   reg_nx304 : oai22 port map ( Y=>nx304, A0=>nx363, A1=>nx364, B0=>nx365, 
      B1=>mode_in(0));
   reg_nx285 : oai22 port map ( Y=>nx285, A0=>nx250, A1=>nx297, B0=>nx365, 
      B1=>mode_in(0));
   reg_nx291 : inv02 port map ( Y=>nx291, A=>nx363);
   ix384 : inv02 port map ( Y=>nx366, A=>nx363);
   reg_nx2 : oai22 port map ( Y=>nx2, A0=>nx358, A1=>nx266, B0=>nx357, B1=>
      nx0);
   reg_nx16 : oai22 port map ( Y=>nx16, A0=>nx250, A1=>nx361, B0=>nx252, B1
      =>mode_in(1));
   reg_nx334 : inv02 port map ( Y=>nx334, A=>enable);
   ix385 : inv02 port map ( Y=>nx367, A=>nx313);
   ix386 : inv02 port map ( Y=>nx368, A=>mode_in(0));
   ix387 : aoi22 port map ( Y=>nx369, A0=>nx313, A1=>mode_in(0), B0=>nx367, 
      B1=>nx368);
   ix388 : oai22 port map ( Y=>nx370, A0=>nx368, A1=>nx313, B0=>nx367, B1=>
      mode_in(0));
   ix389 : nand02_2x port map ( Y=>nx371, A0=>nx62, A1=>nx370);
   ix390 : nand02_2x port map ( Y=>nx372, A0=>nx334, A1=>counter_data_4);
   reg_nx231 : oai321 port map ( Y=>nx231, A0=>nx334, A1=>nx369, A2=>nx62, 
      B0=>nx334, B1=>nx371, C0=>nx372);
end behavioural ;

