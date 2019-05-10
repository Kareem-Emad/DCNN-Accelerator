library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 
      
 entity fBitUpCounter is 
        
       port(en,Clock, CLR : in  std_logic;
        Q : out std_logic_vector(3 downto 0));
        
end fBitUpCounter;

architecture archi of fBitUpCounter is  
        
       signal tmp: std_logic_vector(3 downto 0):="0000";
        
        begin
        
             process (Clock, CLR) 
        
                  begin
                      if (CLR='1') then   
        		
                          tmp <= (OTHERS =>'0');  
        
                      elsif (rising_edge(Clock) ) then 
        		 if(en ='1') then
        			tmp <= tmp + 1;
			end if;
	
                      end if; 
		    
              end process; 
Q <= tmp;
        
 end archi;