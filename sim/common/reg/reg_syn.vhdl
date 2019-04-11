
-- 
-- Definition of  reg
-- 
--      Thu Apr 11 16:17:55 2019
--      
--      LeonardoSpectrum Level 3, 2018a.2
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity reg is
   port (
      d_in : IN std_logic_vector (15 DOWNTO 0) ;
      load_in : IN std_logic ;
      q_out : OUT std_logic_vector (15 DOWNTO 0) ;
      clk : IN std_logic ;
      reset : IN std_logic) ;
end reg ;

architecture Behavioral of reg is
   signal q_out_15_EXMPLR, q_out_14_EXMPLR, q_out_13_EXMPLR, q_out_12_EXMPLR, 
      q_out_11_EXMPLR, q_out_10_EXMPLR, q_out_9_EXMPLR, q_out_8_EXMPLR, 
      q_out_7_EXMPLR, q_out_6_EXMPLR, q_out_5_EXMPLR, q_out_4_EXMPLR, 
      q_out_3_EXMPLR, q_out_2_EXMPLR, q_out_1_EXMPLR, q_out_0_EXMPLR, nx230, 
      nx240, nx250, nx260, nx270, nx280, nx290, nx300, nx310, nx320, nx330, 
      nx340, nx350, nx360, nx370, nx380, nx392, nx396, nx401, nx403, nx408, 
      nx410, nx415, nx417, nx422, nx424, nx429, nx431, nx436, nx438, nx443, 
      nx445, nx450, nx452, nx457, nx459, nx464, nx466, nx471, nx473, nx478, 
      nx480, nx485, nx487, nx492, nx494, nx499, nx501, nx509, nx511, nx513: 
   std_logic ;

begin
   q_out(15) <= q_out_15_EXMPLR ;
   q_out(14) <= q_out_14_EXMPLR ;
   q_out(13) <= q_out_13_EXMPLR ;
   q_out(12) <= q_out_12_EXMPLR ;
   q_out(11) <= q_out_11_EXMPLR ;
   q_out(10) <= q_out_10_EXMPLR ;
   q_out(9) <= q_out_9_EXMPLR ;
   q_out(8) <= q_out_8_EXMPLR ;
   q_out(7) <= q_out_7_EXMPLR ;
   q_out(6) <= q_out_6_EXMPLR ;
   q_out(5) <= q_out_5_EXMPLR ;
   q_out(4) <= q_out_4_EXMPLR ;
   q_out(3) <= q_out_3_EXMPLR ;
   q_out(2) <= q_out_2_EXMPLR ;
   q_out(1) <= q_out_1_EXMPLR ;
   q_out(0) <= q_out_0_EXMPLR ;
   reg_q_out_0 : dffr port map ( Q=>q_out_0_EXMPLR, QB=>OPEN, D=>nx230, CLK
      =>clk, R=>reset);
   ix231 : nand02 port map ( Y=>nx230, A0=>nx392, A1=>nx396);
   ix393 : nand02 port map ( Y=>nx392, A0=>q_out_0_EXMPLR, A1=>nx509);
   ix397 : nand02 port map ( Y=>nx396, A0=>d_in(0), A1=>load_in);
   reg_q_out_1 : dffr port map ( Q=>q_out_1_EXMPLR, QB=>OPEN, D=>nx240, CLK
      =>clk, R=>reset);
   ix241 : nand02 port map ( Y=>nx240, A0=>nx401, A1=>nx403);
   ix402 : nand02 port map ( Y=>nx401, A0=>q_out_1_EXMPLR, A1=>nx509);
   ix404 : nand02 port map ( Y=>nx403, A0=>d_in(1), A1=>load_in);
   reg_q_out_2 : dffr port map ( Q=>q_out_2_EXMPLR, QB=>OPEN, D=>nx250, CLK
      =>clk, R=>reset);
   ix251 : nand02 port map ( Y=>nx250, A0=>nx408, A1=>nx410);
   ix409 : nand02 port map ( Y=>nx408, A0=>q_out_2_EXMPLR, A1=>nx509);
   ix411 : nand02 port map ( Y=>nx410, A0=>d_in(2), A1=>load_in);
   reg_q_out_3 : dffr port map ( Q=>q_out_3_EXMPLR, QB=>OPEN, D=>nx260, CLK
      =>clk, R=>reset);
   ix261 : nand02 port map ( Y=>nx260, A0=>nx415, A1=>nx417);
   ix416 : nand02 port map ( Y=>nx415, A0=>q_out_3_EXMPLR, A1=>nx509);
   ix418 : nand02 port map ( Y=>nx417, A0=>d_in(3), A1=>load_in);
   reg_q_out_4 : dffr port map ( Q=>q_out_4_EXMPLR, QB=>OPEN, D=>nx270, CLK
      =>clk, R=>reset);
   ix271 : nand02 port map ( Y=>nx270, A0=>nx422, A1=>nx424);
   ix423 : nand02 port map ( Y=>nx422, A0=>q_out_4_EXMPLR, A1=>nx509);
   ix425 : nand02 port map ( Y=>nx424, A0=>d_in(4), A1=>load_in);
   reg_q_out_5 : dffr port map ( Q=>q_out_5_EXMPLR, QB=>OPEN, D=>nx280, CLK
      =>clk, R=>reset);
   ix281 : nand02 port map ( Y=>nx280, A0=>nx429, A1=>nx431);
   ix430 : nand02 port map ( Y=>nx429, A0=>q_out_5_EXMPLR, A1=>nx509);
   ix432 : nand02 port map ( Y=>nx431, A0=>d_in(5), A1=>load_in);
   reg_q_out_6 : dffr port map ( Q=>q_out_6_EXMPLR, QB=>OPEN, D=>nx290, CLK
      =>clk, R=>reset);
   ix291 : nand02 port map ( Y=>nx290, A0=>nx436, A1=>nx438);
   ix437 : nand02 port map ( Y=>nx436, A0=>q_out_6_EXMPLR, A1=>nx509);
   ix439 : nand02 port map ( Y=>nx438, A0=>d_in(6), A1=>load_in);
   reg_q_out_7 : dffr port map ( Q=>q_out_7_EXMPLR, QB=>OPEN, D=>nx300, CLK
      =>clk, R=>reset);
   ix301 : nand02 port map ( Y=>nx300, A0=>nx443, A1=>nx445);
   ix444 : nand02 port map ( Y=>nx443, A0=>q_out_7_EXMPLR, A1=>nx511);
   ix446 : nand02 port map ( Y=>nx445, A0=>d_in(7), A1=>load_in);
   reg_q_out_8 : dffr port map ( Q=>q_out_8_EXMPLR, QB=>OPEN, D=>nx310, CLK
      =>clk, R=>reset);
   ix311 : nand02 port map ( Y=>nx310, A0=>nx450, A1=>nx452);
   ix451 : nand02 port map ( Y=>nx450, A0=>q_out_8_EXMPLR, A1=>nx511);
   ix453 : nand02 port map ( Y=>nx452, A0=>d_in(8), A1=>load_in);
   reg_q_out_9 : dffr port map ( Q=>q_out_9_EXMPLR, QB=>OPEN, D=>nx320, CLK
      =>clk, R=>reset);
   ix321 : nand02 port map ( Y=>nx320, A0=>nx457, A1=>nx459);
   ix458 : nand02 port map ( Y=>nx457, A0=>q_out_9_EXMPLR, A1=>nx511);
   ix460 : nand02 port map ( Y=>nx459, A0=>d_in(9), A1=>load_in);
   reg_q_out_10 : dffr port map ( Q=>q_out_10_EXMPLR, QB=>OPEN, D=>nx330, 
      CLK=>clk, R=>reset);
   ix331 : nand02 port map ( Y=>nx330, A0=>nx464, A1=>nx466);
   ix465 : nand02 port map ( Y=>nx464, A0=>q_out_10_EXMPLR, A1=>nx511);
   ix467 : nand02 port map ( Y=>nx466, A0=>d_in(10), A1=>load_in);
   reg_q_out_11 : dffr port map ( Q=>q_out_11_EXMPLR, QB=>OPEN, D=>nx340, 
      CLK=>clk, R=>reset);
   ix341 : nand02 port map ( Y=>nx340, A0=>nx471, A1=>nx473);
   ix472 : nand02 port map ( Y=>nx471, A0=>q_out_11_EXMPLR, A1=>nx511);
   ix474 : nand02 port map ( Y=>nx473, A0=>d_in(11), A1=>load_in);
   reg_q_out_12 : dffr port map ( Q=>q_out_12_EXMPLR, QB=>OPEN, D=>nx350, 
      CLK=>clk, R=>reset);
   ix351 : nand02 port map ( Y=>nx350, A0=>nx478, A1=>nx480);
   ix479 : nand02 port map ( Y=>nx478, A0=>q_out_12_EXMPLR, A1=>nx511);
   ix481 : nand02 port map ( Y=>nx480, A0=>d_in(12), A1=>load_in);
   reg_q_out_13 : dffr port map ( Q=>q_out_13_EXMPLR, QB=>OPEN, D=>nx360, 
      CLK=>clk, R=>reset);
   ix361 : nand02 port map ( Y=>nx360, A0=>nx485, A1=>nx487);
   ix486 : nand02 port map ( Y=>nx485, A0=>q_out_13_EXMPLR, A1=>nx511);
   ix488 : nand02 port map ( Y=>nx487, A0=>d_in(13), A1=>load_in);
   reg_q_out_14 : dffr port map ( Q=>q_out_14_EXMPLR, QB=>OPEN, D=>nx370, 
      CLK=>clk, R=>reset);
   ix371 : nand02 port map ( Y=>nx370, A0=>nx492, A1=>nx494);
   ix493 : nand02 port map ( Y=>nx492, A0=>q_out_14_EXMPLR, A1=>nx513);
   ix495 : nand02 port map ( Y=>nx494, A0=>d_in(14), A1=>load_in);
   reg_q_out_15 : dffr port map ( Q=>q_out_15_EXMPLR, QB=>OPEN, D=>nx380, 
      CLK=>clk, R=>reset);
   ix381 : nand02 port map ( Y=>nx380, A0=>nx499, A1=>nx501);
   ix500 : nand02 port map ( Y=>nx499, A0=>q_out_15_EXMPLR, A1=>nx513);
   ix502 : nand02 port map ( Y=>nx501, A0=>d_in(15), A1=>load_in);
   ix508 : inv02 port map ( Y=>nx509, A=>load_in);
   ix510 : inv02 port map ( Y=>nx511, A=>load_in);
   ix512 : inv02 port map ( Y=>nx513, A=>load_in);
end Behavioral ;

