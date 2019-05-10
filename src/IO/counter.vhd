library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
      
 entity counter is 
        
       port(Clock, CLR,ldEn : in  std_logic;
	cValue : in std_logic_vector(6 downto 0);
        Q : out std_logic_vector(6 downto 0));
        
end counter;
        
architecture archi of counter is  
        
       signal tmp: std_logic_vector(6 downto 0);
        
        begin
        
             process (Clock, CLR,ldEn) 
        
                  begin   
        
                      if (CLR='1') then   
        		
                          tmp <= (others => '0');  
        		
                      elsif (rising_edge(Clock) ) then 
			if(ldEn = '0') then
        		 
        			tmp <= tmp - 1;
			

		     
			elsif(ldEn = '1') then

				tmp <= cValue ;
			end if;	
                      end if;     
        
		end process; 
	Q <= tmp;
 
              
        end archi;
