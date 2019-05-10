library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity DecompressImage is
    Port(clk: in std_logic;
        rst: in std_logic;
        din : in std_logic_vector(15 downto 0);
        proces : in std_logic;
        decompressed,word : out std_logic;
        dataOut :  out std_logic_vector(15 downto 0));
end entity DecompressImage;

architecture ArchIODecompressImage of DecompressImage is
    component UpdCounter is
        Port ( clk,rst,en : in  STD_LOGIC;      
               dir : in  STD_LOGIC;     -- direction of counter (up or down)
               count : out  STD_LOGIC_VECTOR (6 downto 0));   
    end component;
signal packet: std_logic := '0' ; -- 0 at first packet , 1 at second packet
signal en1 : std_logic := '0' ;
signal en2 : std_logic := '0' ;
signal bgn : std_logic :='0';
signal cnt,cnt2: std_logic_vector(6 downto 0);
signal rstc1 : std_logic ;--:= rst;
signal rstc2 : std_logic ;--:= rst;
signal decomp:std_logic:='0';
begin
process (proces,rst,cnt,cnt2,clk,bgn,packet)
    begin
    if (rst='1') then
        decomp<='0';
        decompressed<='0';
        rstc1<='1';
        rstc2<='1';
        bgn<='0';
        word<='0';
        en1<='0';
        en2<='0';
        packet<='0';
    elsif (clk'Event and clk = '1') then
        if (proces='1') then
            bgn<='1';
            packet<='0';
            decompressed<='0';
            decomp<='0';
            rstc1<=rst;
            rstc2<=rst;
            word<='0';
        elsif(proces='0' and decomp='1')then
            -- rstc1 <='1';
            -- rstc2 <='1';
            -- en1 <='0';
            -- en2 <='0';
            -- bgn<='0';
            -- word<='0';
            decompressed<='0';
            word<='0';
        else-- proces =0
            if (bgn='1' and packet='0' and din(14 downto 8) ="0000000")  then -- process the first packet
                decompressed<='1';
                decomp<='1';
                word<='0';
            elsif (bgn='1' and packet='0' ) then
                en1<='1';
                bgn<='0';
                word<='1';----???????
            elsif(packet='0'and cnt=din(14 downto 8)-1 )then
                packet<='1';
                en1<='0';
                --en2<='1';
                bgn<='1';-----
                --decompressed<='0';
                rstc1<='1';
                word<='0';
            elsif (bgn='1' and packet='1' and din(6 downto 0) ="0000000" )  then-- process the second packet
                decompressed<='1';
                decomp<='1';
                word<='0';
            elsif(bgn='1' and packet='1' ) then
                en2<='1';
                bgn<='0';
                word<='1'; --- ???????
            elsif( packet='1' and cnt2=din(6 downto 0)-1) then
                decompressed<='1';
                decomp<='1';
                en2<='0';
                rstc2 <='1';
                word<='0';
            -- elsif(decomp='1') then -- is that my task or not ?
            --     rstc1 <='1';
            --     rstc2 <='1';
            --     en1 <='0';
            --     en2 <='0';
            --     bgn<='0';
            --     word<='0';
            elsif (en1='1' or en2='1') then
                word<='1';
            end if;

        end if;
    end if;
end process;

C1: UpdCounter port map (clk,rstc1,en1,'1',cnt); -- cnt up (dir=1) , and stop when counter reaches the no of pixels
C2 : UpdCounter port map (clk,rstc2,en2,'1',cnt2);
dataOut<= (others=>'1') when packet='0' and din(15) ='1'
else (others=>'0') when packet='0' and din(15) ='0'
else (others=>'1') when packet='1' and din(7)='1'
else (others=>'0') ;--when packet='1' and din(7)='0'

end ArchIODecompressImage;


