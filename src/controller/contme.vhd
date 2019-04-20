library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;

entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16;  -- size of the address bus
        WREG : natural := 5;  --size of img width reg (max 28, 5 bits)   
        HREG: natural := 16 --for now since i don't know how big the FC stage img is
        );
    port (
        clk             :   in  std_logic;
        io_ready_in     :   in  std_logic;
        io_done_out     :   out std_logic;
        mem_data_in     :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out    :   out std_logic_vector(N - 1 downto 0);
        mem_addr_out    :   out std_logic_vector(M - 1 downto 0);
        mem_write_out   :   out std_logic;
        mem_read_out    :   out std_logic;
        filter_data_out :   out std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        init_filter_window,
        init_image_cache,
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory,
        argmax_computation,
        write_classification,
        end_state
    );
    signal current_state : state_type := init_filter_window;
    signal next_state : state_type := init_image_cache;


    --for implementation optimization
    signal filter_tbt_out: std_logic; -- state signal
    signal add_upper_limit_in: std_logic_vector(M-1 downto 0):=(others=>'1');
   
    --Signals between states
    signal edged: std_logic;
    signal second_fetch: std_logic;
    signal img_channel_done: std_logic;

    --connected to cache col counter (normal counter)
    signal cache_col_max_reached_out: std_logic;
    signal cache_col_counter_en: std_logic;
    signal cache_col_counter_mode_in: std_logic;
    signal cache_col_counter_rst: std_logic;
    signal cache_col_counter_out: std_logic_vector(WREG-1 downto 0);



    --conected to cache row counter (aadvancd counter)
    signal cache_rows_max_reached_out: std_logic;
    signal cache_rows_counter_en: std_logic;
    signal cache_rows_counter_mode_in: std_logic_vector(1 downto 0);
    signal cache_rows_counter_rst: std_logic;
    signal cache_rows_counter_out: std_logic_vector(HREG-1 downto 0);-- here for simul, not used , should be open.


    --connected to memory address counter (normal counter)
    signal current_add_counter_mode_in: std_logic;
    signal current_add_counter_out: std_logic_vector(M-1 downto 0);
    signal current_add_counter_en: std_logic;
    signal current_add_counter_rst: std_logic;

    
    --connected to memory
    -- signal mem_read_in: std_logic;
    -- signal mem_write_in: std_logic;
    -- signal mem_data_out: std_logic_vector(N -1 downto 0);
    -- signal mem_data_in: std_logic_vector(N -1 downto 0);


    --connected to cache
    signal cache_en: std_logic;
    signal cache_in: std_logic_vector(N-1 downto 0);
    signal cache_col_out: std_logic_vector((N*5)-1 downto 0);
    signal cache_rst: std_logic;

    --connected to window col counter (normal counter)
    signal wind_col_max_reached_out: std_logic;
    signal wind_col_counter_en: std_logic;
    signal wind_col_counter_mode_in: std_logic;
    signal wind_col_counter_rst: std_logic;
    signal wind_col_counter_out: std_logic_vector(WREG-1 downto 0);


    --connected to window
    signal wind_en: std_logic;
    signal wind_col_in: std_logic_vector((N*5)-1 downto 0);
    signal wind_rst: std_logic;
    signal wind_col_out
    --conected to image width register 
    signal img_width_out: std_logic_vector(WREG-1 downto 0);

    --connected to img height reg
    signal img_height_out: std_logic_vector(HREG-1 downto 0);




    






    
begin
    -- Port Maps
    cache_col_counter: entity dcnn.Counter
                        generic map(
                            WREG --map number of columns is 28
                        )
                        port map(
                            clk=>clk,
                            reset=> cache_col_counter_rst,
                            enable=> cache_col_counter_en,
                            mode_in=> cache_col_counter_mode_in,
                            max_val_in=>img_width_out,
                            max_reached_out=>cache_col_max_reached_out,
                            counter_out=>cache_col_counter_out
                        );

    cache_rows_counter: entity dcnn.AdvancedCounter
                        generic map(
                            HREG
                        )
                        port map(
                            clk=>clk,
                            reset=> cache_rows_counter_rst,
                            enable=> cache_rows_counter_en,
                            mode_in=> cache_rows_counter_mode_in,
                            max_val_in=>img_height_out,
                            max_reached_out=>cache_rows_max_reached_out,
                            counter_out=>cache_rows_counter_out
                        );

    current_add_counter: entity dcnn.Counter
                        generic map(
                            M
                        )
                        port map(
                            clk=>clk,
                            reset=> current_add_counter_rst,
                            enable=> current_add_counter_en,
                            mode_in=> current_add_counter_mode_in,
                            max_val_in=>add_upper_limit_in,
                            max_reached_out=>open,
                            counter_out=>current_add_counter_out
                        );

    -- ram: entity dcnn.Ram
    --                     port map(
    --                         clk=>clk,
    --                         read_in=>mem_read_in,
    --                         write_in=>mem_write_in,
    --                         address_in=>current_add_counter_out,
    --                         data_in=>mem_data_in,
    --                         data_out=>mem_data_out
    --                     );

    cache: entity dcnn.cache
                        generic map(
                            sel=>WREG,
                            n_word=>N
                        )
                        port map(
                            in_word=>cache_in,
                            cache_in_sel=> cache_col_counter_out,
                            cache_out_sel=>wind_col_counter_out,
                            decode_en=>cache_en,
                            out_column=>cache_col_out,
                            clk=>clk,
                            reset=>cache_rst 
                        );
                        
    wind_col_counter: entity dcnn.AdvancedCounter
                        generic map(
                            WREG
                        )
                        port map(
                            clk=>clk,
                            reset=> wind_col_counter_rst,
                            enable=> wind_col_counter_en,
                            mode_in=> wind_col_counter_mode_in,
                            max_val_in=>img_width_out,
                            max_reached_out=>wind_col_max_reached_out,
                            counter_out=>wind_col_counter_out
                        );




    -- This process computes the next state given the current state and the inputs.






    --Three by Threee filter. Signal used in fetch to cache state
    filter_tbt<=filter_size=std_logic_vector(to_signed(3, filter_reg_size)); --PUT OUTSIDE PROCESS



    -- This process computes the next state given the current state and the inputs.
    comp_ns : process(current_state)
    begin
        case current_state is
            when init_filter_window =>
                -- Fetch the filter window; Needs a counter.
                -- 1: Load Filter Width
                -- 2: Load Filter Height
                -- 3: Load Bias
                -- 4: If FilterWidth=3, Set Imax=9. Else Set Imax=25.
                -- 5: Loop: for i = 0; i < Imax; i++
                -- 6:   If Edge: Write 0. 
                -- 7:   Else: Fetch pixel from current mem loc.
            when init_image_cache =>

            when start_convolution =>

            when fetch_to_cache => -- max is  4 if number of coluns is 5
            --assuming max reahed is raised the first time this  state is entered (from initializing the memory) 
            --or could raise a signal that says we're just done with initialization and should start at zero
            -- and rows are set to 0


                if filter_tbt and cache_rows_max_reached_out ='1'and edged='0'  and cache_col_max_reached_out='1' then
                    edged<='1'; --set edged bit

                    cache_rows_counter_en='1'; 
                    cache_rows_counter_mode_in="11"; -- to decrement 2
                    cache_rows_counter_rst<='0';

                    -- cache_col_counter_rst<='1'; -- counter rst to 0000
                    cache_col_counter_en<='0';

                    cache_en<='1';
                    cache_in<=(others=>'0'); --insert 0

                    current_address_en<='0'; 
                    mem_read_in<='0';

                elsif (( filter_tbt='1' and edged='1' ) or filter_tbt='0' )and cache_rows_max_reached_out='1'and cache_col_max_reached_out='1' 
                    --filter ends if max col and max rows and either it is 5x5 or it is 3x3 and edge cases done
                    edged<='0';
                    img_channel_done<='1';

                    cache_rows_counter_rst<='1'; -- rst to 0000
                    cache_rows_counter_en='0'; 

                    -- cache_col_counter_rst<='1'; -- rst to 0000
                    cache_col_counter_en<='0';

                    cache_en<='0';
                    current_address_en<='0'; 
                    mem_read_in<='0';
                
                else
                    if cache_col_max_reached_out='1' then 
                        -- cache_col_counter_rst<='1'; -- rst to 0000
                        cache_col_counter_en<='0';

                        cache_rows_counter_rst<='0';       
                        cache_rows_counter_en='1'; 
                        cache_rows_counter_mode_in="00"; -- to increment 1
                    else
                        cache_rows_counter_en='0'; 
                        cache_col_counter_rst<='0';           
                        cache_col_counter_en<='1';
                        cache_col_counter_mode_in<='0'; -- +1
                    end if;

                    if edged ='0' then
                        current_address_en<='1'; 
                        current_address_mode_in<='0'; -- given that it is a counter that only jumps +1
                        mem_read_in<='1';
                        cache_in<=meme_data_out;
                        cache_en<='1';
                    else
                        
                        cache_en<='1';
                        cache_in<=(others=>'0'); --insert 0
                        current_address_en<='0'; 
                        mem_read_in<='0';


                    end if;

                end if;
    
                --decide next state
                if  filter_tbt='1' and second_fetch='0' and (cache_col_max_reached_out='0' or (cache_col_max_reached_out='1' and img_width_out(0)='1')) then --even with so i can fetch again
                    next_state<=fetch_to_cache;
                    second_fetch='1';

                    if(cache_col_max_reached_out='1') then
                        cache_col_counter_rst<='1';
                    end if;


                else
                    next_state<=fetch_to_image_window;
                    second_fetch='0';
                    
                    if(cache_col_max_reached_out='1') then --how sequential is process exactly?
                        cache_col_counter_rst<='1';
                    end if;

                end if;


            when fetch_to_image_window => --assuming col counter is at 4 (first window already initialized)
            --cache in sel is window_col_counter.
                if wind_col_max_reached_out='1' and filter_tbt='1'  then
                    wind_en<='1';
                    wind_col_in<=(others=>'0');
                    wind_col_counter_en<='0';
                elsif  wind_col_max_reached_out='0' then --because if max_reachd i need to re initialize window
                    wind_en<='1';
                    wind_col_in<= cache_col_out;
                    wind_col_counter_rst<='0';
                    wind_col_counter_en<='1';
                    wind_col_counter_mode_in<='1';
                else
                    wind_en<'0';
                    wind_col_counter_en<='0';
                end if;

                if filter_tbt='1' and second_fetch='0' then
                    second_fetch<='1';
                    next_state<=fetch_to_image_window;
                else wind_col_max_reached_out='1' then 
                    next_state<=ini_image_wind;
                    second_fetch='0';  
                    wind_col_counter_rst<='1';
                else
                    next_state<=write_to_memory;
                    second_fetch='0';  
                end if; 

            when write_to_memory =>

            when argmax_computation =>

            when write_classification =>

            when end_state =>
                next_state <= current_state;
            end case;
    end process;

    
    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk)
    begin
        if falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end Mixed;