library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------------------
-- ModifiedBoothMultiplier entity is an implementation of Modified Booth Algoirthm.
-- Takes 8 cycles to calculate product (worst case).
-- Takes less cycles depending on operand real size.
-- preserves product after 8 cycles.
------------------------------------------------------------------------------------

entity ModifiedBoothMultiplier is 
	port(
		M         : in signed(15 downto 0);-- First operand
		R        : in signed(15 downto 0);-- Second operand
		cnt_enable : in std_logic;-- enable from counter
		product     : out signed(31 downto 0);-- Final product
		clk : in std_logic -- clock
	);
end entity ModifiedBoothMultiplier;

architecture ModifiedBoothMultiplierWorkFlow of ModifiedBoothMultiplier is 




signal positive_M: signed(31 downto 0);
signal negative_M: signed(31 downto 0);
signal positive_2M: signed(31 downto 0);
signal negative_2M: signed(31 downto 0);
signal shifting_R: signed(31 downto 0);

signal aux_product: signed(31 downto 0);

begin
process (clk)
begin
	if( rising_edge(clk) ) then
		
        if (cnt_enable = '0') then
            -- intializing second operator 
            -- M,-M,2M,-2M
            positive_M(15 downto 0) <= M;
            positive_M(31 downto 16) <= (OTHERS=>'0');

 	    negative_M <=  -("0000000000000000"&M);
           --negative_M(31 downto 16) <= (OTHERS=>'0');
            

            positive_2M(16 downto 0) <= M&'0';
            positive_2M(31 downto 17) <= (OTHERS=>'0');

            negative_2M <= -("000000000000000"&M&'0');
            --negative_2M(31 downto 17) <= (OTHERS=>'0');

            aux_product <= (OTHERS=>'0');
	    product <= aux_product; 

            shifting_R(16 downto 0) <= R&'0';
            shifting_R(31 downto 17) <= (OTHERS=>'0');

        else
            if(  shifting_R(2 downto 0) = "001" OR  shifting_R(2 downto 0) = "010" ) then -- +M
                aux_product <= aux_product + positive_M;
            else 
                if( shifting_R(2 downto 0) = "101" OR  shifting_R(2 downto 0) = "110" ) then -- +(-M)
                    aux_product <= aux_product + negative_M;
                else
                    if(shifting_R(2 downto 0) = "011" ) then -- +(2M)
                        aux_product <= aux_product + positive_2M;
                    else
                        if(shifting_R(2 downto 0) = "100") then -- +(-2M)
                            aux_product <= aux_product + negative_2M;
                        end if;
                    end if;
                end if;
            end if;

            --raising all M operators by 4
            negative_2M <= negative_2M(29 downto 0)&'0'&'0';
            negative_M <= negative_M(29 downto 0)&'0'&'0';
            positive_M <= positive_M(29 downto 0)&'0'&'0';
            positive_2M <= positive_2M(29 downto 0)&'0'&'0';
            shifting_R <= '0'&'0'&shifting_R(31 downto 2);

  	    end if;

        product <= aux_product;
     end if;
end process;

end architecture ModifiedBoothMultiplierWorkFlow;