
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;
use dcnn.config.all;



entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16;  -- size of the address bus
        WREG : natural := 5;  --size of img width reg (max 28, 5 bits)   
        HREG: natural := 16; --for now since i don't know how big the FC stage img is
        creg: natural := 16 --could change according to size
            );
    port (
        clk             :   in  std_logic;
        io_ready_in     :   in  std_logic;
        io_done_out     :   out std_logic;
        mem_data_in     :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out    :   out std_logic_vector(N - 1 downto 0);
        mem_addr_out    :   out std_logic_vector(M - 1 downto 0);
        mem_write_out   :   out std_logic; -- writes into memory
        mem_read_out    :   out std_logic; -- reads from memory
        filter_data_out :   out std_logic_vector(N-1 downto 0);
	    comp_unit_ready :   out std_logic;
	    comp_unit_data1 :   out std_logic_vector(N-1 downto 0);
	    comp_unit_data2 :   out std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        reset_system,
        dereset_system,
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

    signal current_state : state_type := reset_system;
    signal next_state : state_type := reset_system;

    signal cntr1_reset : std_logic := '0';
    signal cntr1_reset_new : std_logic := '0';
    signal cntr1_enable : std_logic := '1';
    signal cntr1_mode : std_logic := '0';
    signal cntr1_max_val : std_logic_vector(4 downto 0) := (others => '1');
    signal cntr1_max_reached : std_logic := 'Z';
    signal cntr1_data : std_logic_vector(4 downto 0) := (others => 'Z');

    signal fltSize_reset : std_logic := '0';
    signal fltSize_load : std_logic := '0';
    -- signal fltSize_data_in : std_logic_vector(N-1 downto 0) := '0';
    signal fltSize_data_out : std_logic_vector(N-1 downto 0) := (others => '0');
    signal fltSize_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');

    signal bias_reset : std_logic := '0';
    signal bias_load : std_logic := '0';
    signal bias_data_out : std_logic_vector(N-1 downto 0) := (others => '0');
    signal bias_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');

    signal bias2_reset : std_logic := '0';
    signal bias2_load  : std_logic := '0';
    signal bias2_data_out : std_logic_vector(N-1 downto 0) :=(others => '0'); 
    signal bias2_rst_data : std_logic_vector(N-1 downto 0) :=(others => '0'); 
 
    signal offset_reset : std_logic := '0';
    signal offset_load  : std_logic := '0';
    signal offset_address_in : std_logic_vector(M-1 downto 0) :=(others => '0');
    signal offset_address_out : std_logic_vector(M-1 downto 0) :=(others => '0');
    signal offset_rst_data: std_logic_vector(M-1 downto 0);

    signal channel_ctr_reset : std_logic := '0';
    signal channel_ctr_enable  : std_logic := '0';
    signal channel_ctr_mode: std_logic := '0';
    signal channel_max_reached_out : std_logic;
    signal channel_ctr_out : std_logic_vector(2 downto 0);
    signal channel_ctr_max_val_in : std_logic_vector(2 downto 0);

    signal layer_ctr_reset : std_logic := '0';
    signal layer_ctr_enable : std_logic := '0';
    signal layer_ctr_mode : std_logic := '0';
    signal layer_max_reached_out : std_logic := '0';
    signal layer_ctr_out : std_logic_vector(1 downto 0);
    signal layer_ctr_max_val_in : std_logic_vector(1 downto 0);

    signal flt_type_rst : std_logic :='0' ;
    signal flt_type_enable : std_logic := '0';
    signal flt_type_in : std_logic_vector(1 downto 0);
    signal flt_type_out : std_logic_vector(1 downto 0);
    signal flt_type_load : std_logic :='0';


    signal addr1_reset : std_logic := '0';
    signal addr1_enable : std_logic := '1';
    signal addr1_mode : std_logic := '0';
    signal addr1_max_reached : std_logic := 'Z';
    signal addr1_data : std_logic_vector(M-1 downto 0) := (others => 'Z');

    signal base1_reset : std_logic := '0';
    signal base1_load : std_logic := '0';
    signal base1_in : std_logic_vector(M-1 downto 0);
    signal base1_out : std_logic_vector(M-1 downto 0);


    signal base2_reset : std_logic := '0';
    signal base2_load : std_logic := '0';
    signal base2_in : std_logic_vector(M-1 downto 0);
    signal base2_out : std_logic_vector(M-1 downto 0);

    signal out_offset_reset : std_logic := '0';
    signal out_offset_load : std_logic := '0';
    signal out_offset_in : std_logic_vector(M-1 downto 0);
    signal out_offset_out : std_logic_vector(M-1 downto 0);

    signal fltSize_squaredp3 : std_logic_vector(4 downto 0) := (others => 'Z');
    signal write_mem_to_fltr : std_logic := '0';

-----------------------------------------------------------------------------------------------------------------
    --for implementation optimization
    signal filter_tbt: std_logic; -- state signal
    -- signal add_upper_limit_in: std_logic_vector(M-1 downto 0):=(others=>'1');
   
    --Signals between states
    signal edged: std_logic;
    signal second_fetch: std_logic;
    signal img_channel_done: std_logic;

    --connected to window col counter (normal counter)
    signal wind_width_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache width counter
    signal wind_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal wind_width_count_rst : std_logic := '0';
    signal wind_width_count_en : std_logic := '0';
    signal wind_width_count_mode : std_logic := '0';
    signal wind_width_ended : std_logic := 'Z';

    -- for window
    signal wind_en: std_logic ;
    signal wind_col_in  : wordarr_t(4 downto 0) := (others => (others => 'Z'));




------------Signals for Cache----------------
signal cache_height_reset : std_logic := '0'; --for cache height register
signal cache_height_load : std_logic := '0';
signal cache_height : std_logic_vector(N-1 downto 0) := (others => '0');
signal cache_height_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');
signal cache_height_1 : std_logic_vector(N-1 downto 0);

signal cache_width_reset : std_logic := '0'; --for cache width register
signal cache_width_load : std_logic := '0';
signal cache_width : std_logic_vector(N-1 downto 0) := (others => 'Z');
signal cache_width_rst_data : std_logic_vector(N-1 downto 0) := (others => '0');
signal cache_width_1 : std_logic_vector(N-1 downto 0);

signal cache_height_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache height counter
signal cache_height_in : std_logic_vector(15 downto 0) := (others => '0'); 
signal cache_height_count_rst : std_logic := '0';
signal cache_height_count_en : std_logic := '0';
signal cache_height_count_mode : std_logic_vector(1 downto 0) := (others => '0');
signal cache_height_ended : std_logic := 'Z';

signal cache_width_count: std_logic_vector(15 downto 0) := (others => 'Z'); --for cache width counter
signal cache_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
signal cache_width_count_rst : std_logic := '0';
signal cache_width_count_en : std_logic := '0';
signal cache_width_count_mode : std_logic := '0';
signal cache_width_ended : std_logic := 'Z';

signal cache_data_in  : std_logic_vector(N - 1 downto 0) := (others => '0');
signal cache_data_out   : wordarr_t(4 downto 0) := (others => (others => 'Z'));
signal cache_out_sel    : std_logic_vector(N-1 downto 0) := (others => '0');--(cache_width_count+5); --make sure
signal cache_load        : std_logic := '0';
signal cache_rst : std_logic := '0';

-- signal cur_st : cache_substate_type := fc; -- for cache substates
-- signal nxt_st : cache_substate_type := fc;

signal pad_h,height_edge,fc_signal,read_width :std_logic := '0'; -- control signals
signal not_clk : std_logic := '0';
signal width_ended : std_logic := 'Z';
signal height_ended : std_logic := 'Z';
signal another_row : std_logic := '0';



    
----for control reg
signal ftc_cntrl_reg_in: std_logic_vector(creg-1 downto 0);
signal ftc_cntrl_reg_out: std_logic_vector(creg-1 downto 0);
signal ftc_cntrl_reg_en: std_logic;
signal ftc_cntrl_reg_rst: std_logic;
--cnrl reg out
signal filter_tbt_o : std_logic;
signal edged_o : std_logic;
signal second_fetch_o : std_logic;
signal cache_height_ended_o : std_logic;
signal cache_width_ended_o : std_logic;
signal wind_width_ended_o : std_logic;
signal begin_ftc_o : std_logic;
signal begin_ftc: std_logic;





    
begin
    fltSize_squaredp3 <= "11100" when fltSize_data_out = X"0005" else "01100";
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');
    not_clk <= "not"(clk);
    --width_ended <= '1' when cache_width_ended = '1' else '0';
    -- height_ended <= '1' when cache_height_ended = '1' else '0';
    cache_width_1 <= std_logic_vector(unsigned(cache_width) - 1); --zeiabo i changd it to -1?--cache_width - 1;
    cache_height_1 <= std_logic_vector(unsigned(cache_width) - 1);

    --Three by Threee filter. Signal used in fetch to cache state
    filter_tbt<='1' when fltSize_data_out = std_logic_vector(to_signed(3, 16))
    else '0' ; --PUT OUTSIDE PROCESS
------------------------------------------------
---making a control reg for the sake of homogienity inside states
ftc_cntrl_reg_in<= filter_tbt & --15
                edged & --14
                second_fetch & --13
                cache_height_ended &  --12
                cache_width_ended & --11
                wind_width_ended & --10
                begin_ftc & --9
                (8 downto 0 =>'0');
(filter_tbt_o,
edged_o,second_fetch_o,
cache_height_ended_o,
cache_width_ended_o,
wind_width_ended_o,
begin_ftc_o) <= ftc_cntrl_reg_out(15 downto 9);

ftc_cntrl_reg : entity dcnn.Reg
port map (
    clk => not_clk,
    reset => ftc_cntrl_reg_rst,
    load => ftc_cntrl_reg_en,
    d => ftc_cntrl_reg_in,
    q => ftc_cntrl_reg_out,
    rst_data => (others=>'0')
);
    -------------------------------------------------------

    cntr1_inst : entity dcnn.Counter
    port map (
        clk => clk,
        reset => cntr1_reset,
        enable => cntr1_enable,
        mode_in => cntr1_mode,
        max_val_in => cntr1_max_val,
        max_reached_out => cntr1_max_reached,
        counter_out => cntr1_data
    );
    
    cntr_mem_addr : entity dcnn.Counter
    generic map (
        N => 16
    ) 
    port map (
        clk => clk,
        reset => addr1_reset,
        enable => addr1_enable,
        mode_in => addr1_mode,
        max_val_in => (others => '1'),
        max_reached_out => addr1_max_reached,
        counter_out => addr1_data
    );

    reg_filter_height : entity dcnn.Reg
    port map (
        clk => clk,
        reset => fltSize_reset,
        load => fltSize_load,
        d => mem_data_in,
        q => fltSize_data_out,
        rst_data => fltSize_rst_data
    );

    reg_bias1 : entity dcnn.Reg
    port map (
        clk => clk,
        reset => bias_reset,
        load => bias_load,
        d => mem_data_in,
        q => bias_data_out,
        rst_data => bias_rst_data
    );
    ---------------For Initialize Cache stat -----------------------
    img_cache : entity dcnn.Cache
        port map(
            in_word => cache_data_in,
            cache_in_sel => cache_width_count(4 downto 0),
            cache_out_sel  => cache_out_sel(4 downto 0), --not used here
            decoder_enable => cache_load,
            out_column => cache_data_out,
            clk => not_clk,
            reset => cache_rst
        );  

    reg_cache_height : entity dcnn.Reg
        port map (
            clk => not_clk,
            reset => cache_height_reset,
            load => cache_height_load,
            d => cache_height_in,
            q => cache_height,
            rst_data => cache_height_rst_data
        );
    
    reg_cache_width : entity dcnn.Reg
        port map (
            clk => not_clk,
            reset => cache_width_reset,
            load => cache_width_load,
            d => cache_width_in,
            q => cache_width,
            rst_data => cache_width_rst_data
        );
    
    cache_width_cntr : entity dcnn.Counter 
        generic map (
            N => 16
        ) 
        port map(
            clk => clk,
            reset => cache_width_count_rst,
            enable => cache_width_count_en,
            mode_in => cache_width_count_mode, -- 0 if +1, 1 if -1
            max_val_in => cache_width_1,
            max_reached_out => cache_width_ended,
            counter_out => cache_width_count
        );

    cache_height_cntr : entity dcnn.AdvancedCounter
        generic map (
            N => 16
        ) 
        port map(
            clk => clk,
            reset => cache_height_count_rst,
            enable => cache_height_count_en,
            mode_in => cache_height_count_mode, -- 0 if +1, 1 if -1
            max_val_in => cache_height_1,
            max_reached_out => cache_height_ended,
            counter_out => cache_height_count
        );

        window_width_cntr : entity dcnn.Counter 
        generic map (
            N => 16
        ) 
        port map(
            clk => clk,
            reset => wind_width_count_rst,
            enable => wind_width_count_en,
            mode_in => wind_width_count_mode, -- 0 if +1, 1 if -1
            max_val_in => x"0004",
            max_reached_out => wind_width_ended,
            counter_out => wind_width_count
        );

    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, cntr1_data, fltSize_squaredp3, cntr1_max_reached,
    --fetchto cache, fetch to wind
    filter_tbt_o,cache_height_ended_o,edged_o,cache_width_ended_o,second_fetch_o,wind_width_ended_o,mem_data_in,cache_data_out)
    begin
        case current_state is

            when reset_system=> -- should be done in fetch to cache
            
            cache_height_count_rst<='1'; 
            cache_width_count_rst<='1';
            ftc_cntrl_reg_rst<= '1';
            cache_load<='0';  

            next_state <= dereset_system;

            --for testing purposes
            addr1_reset<='1';
            cache_height_in<=x"0005";
            cache_height_load<='1';
            cache_width_in<=x"0005";
            cache_width_load<='1';
            fltSize_load<='1';
            fltSize_reset<='0';


            when dereset_system=>

            -- ftc_cntrl_reg_rst <= '0';
            -- ftc_cntrl_reg_en<='0';
            next_state <= fetch_to_cache;

            -- done in fetch to cache
            cache_height_count_rst<='0';
            cache_width_count_rst<='0';
            
            
            

            --fooor testing
            addr1_reset<='0';
            addr1_enable<='0';
            fltSize_load<='0';
            fltSize_reset<='0';
            cache_width_load<='1';
            cache_height_load<='1';


            -- Fetch the filter window; Needs a counter.
            when init_filter_window =>
                -- Assumes the counter starts at the right memory address.
                case cntr1_data is
                    when "00000" => -- 1: Load Filter Size
                        -- Filter data not ready yet.
                        write_mem_to_fltr <= '0';
                        -- Prepare the counter for the future.
                        cntr1_reset_new <= '0';
                        cntr1_enable <= '1';
                        cntr1_mode <= '0';
                        cntr1_max_val <= "11111";

                        -- Prepare the memory address counter for the future.
                        addr1_reset <= '0';
                        addr1_enable <= '1';
                        addr1_mode <= '0';
                        
                        -- Load Filter Size from memory
                        fltSize_reset <= '0';
                        fltSize_load <= '1';
                        mem_addr_out <= addr1_data;
                        mem_write_out <= '0';
                        mem_read_out <= '1';

                        -- The next state will be the same because we change nothing.
                        next_state <= current_state;
                    when "00001" => -- 2: Load Bias
                        fltSize_load <= '0';
                        cntr1_max_val <= fltSize_squaredp3;

                        -- Load bias from memory
                        mem_addr_out <= addr1_data;
                        mem_read_out <= '1';
                        bias_reset <= '0';
                        bias_load <= '1';
                        
                        next_state <= current_state;
                    -- when "00010" => 
                    when others => -- 3: Fetch to the filter window.
                        bias_load <= '0';
                        if cntr1_max_reached = '0' then -- 4: Loop: for i = 0; i < Imax; i++
                            -- 5:   If Edge: Write 0. Ignored for now..
                            -- 6:   Else: Fetch pixel from current mem loc.
                            mem_addr_out <= addr1_data;
                            mem_read_out <= '1';
                            write_mem_to_fltr <= '1';
                        else
                            cntr1_reset_new <= '1';
                            mem_read_out <= '0';
                            write_mem_to_fltr <= '0';
                            next_state <= end_state;
                        end if;
                end case;

                    when init_image_cache =>

                    when start_convolution =>
                    --when entering fetch to cache
                    ---foooorrr tesstttinnnggg
                    next_state<= fetch_to_cache; 
                    addr1_enable<='0';

        
                    when fetch_to_cache => -- max is  4 if number of coluns is 5
                    --assuming max reahed is raised the first time this  state is entered (from initializing the memory) 
                    --or could raise a signal that says we're just done with initialization and should start at zero
                    -- and rows are set to 0                    
                        addr1_reset<='0';
                        ftc_cntrl_reg_en<='1';
                        ftc_cntrl_reg_rst<='0';
                        if filter_tbt_o ='1' and cache_height_ended_o ='1'and edged_o='0'  and cache_width_ended_o='1' then
                            edged<='1'; --set edged bit
        
                            cache_height_count_en<='1'; 
                            cache_height_count_mode<="11"; -- to decrement 2
                            cache_height_count_rst<='0';
        
                            -- cache_width_count_rst<='1'; -- counter rst to 0000
                            cache_width_count_en<='0';
        
                            cache_load<='1';
                            cache_data_in<=(others=>'0'); --insert 0
        
                            addr1_enable<='0'; 
                            mem_read_out<='0';
                            begin_ftc<='0';
        
                        elsif (( filter_tbt_o='1' and edged_o='1' ) or filter_tbt_o='0' )and cache_height_ended_o='1'and cache_width_ended_o='1' then
                            --filter ends if max col and max rows and either it is 5x5 or it is 3x3 and edge cases done
                            edged<='0';
                            img_channel_done<='1';
        
                            cache_height_count_rst<='1'; -- rst to 0000
                            cache_height_count_en<='0'; 
        
                            -- cache_width_count_rst<='1'; -- rst to 0000
                            cache_width_count_en<='0';
        
                            cache_load<='0';
                            addr1_enable<='0'; 
                            mem_read_out<='0';
                            begin_ftc<='1';
                        
                        else
                            if cache_width_ended_o='1' then 
                                -- cache_width_count_rst<='1'; -- rst to 0000
                                cache_width_count_en<='0';
        
                                cache_height_count_rst<='0';       
                                cache_height_count_en<='1'; 
                                cache_height_count_mode<="00"; -- to increment 1
                                begin_ftc<='1';
                                --cw
                                
                            else
                                cache_height_count_en<='0'; 
                                cache_width_count_rst<='0';  

                                if begin_ftc_o='0' then         
                                    cache_width_count_en<='0';
                                    begin_ftc<='1';
                                else
                                    cache_width_count_en<='1';
                                    begin_ftc<='1';
                                end if;
                                    
                                cache_width_count_mode<='0'; -- +1
                            end if;
        
                            if edged_o ='0' then
                                addr1_enable<='1'; 
                                addr1_mode<='0'; -- given that it is a counter that only jumps +1
                                mem_read_out<='1';
                                mem_addr_out <= addr1_data;
                                cache_data_in<=mem_data_in;
                                cache_load<='1';
                                edged<='0';
                            else
                                
                                cache_load<='1';
                                cache_data_in<=(others=>'0'); --insert 0
                                addr1_enable<='0'; 
                                mem_read_out<='0';
                                edged<='0';
        
        
                            end if;
        
                        end if;
            
                        --decide next state
                        if  filter_tbt_o='1' and second_fetch_o='0' and (cache_width_ended_o='0' or (cache_width_ended_o='1' and cache_width(0)='1')) then --even with so i can fetch again
                            next_state<=fetch_to_cache;
                            second_fetch<='1';
        
                            if(cache_width_ended_o='1') then
                                cache_width_count_rst<='1';
                            end if;
        
        
                        else
                            -- next_state<=fetch_to_image_window;
                            next_state<= fetch_to_cache; --for now for testing purposes
                            second_fetch<='0';
                           

                            
                            if(cache_width_ended_o='1') then --how sequential is process exactly?
                                cache_width_count_rst<='1';
                            end if;
        
                        end if;
        
        
                    when fetch_to_image_window => --assuming col counter is at 4 (first window already initialized)
                    --cache in sel is window_col_counter.
                        if wind_width_ended_o='1' and filter_tbt_o='1'  then
                            wind_en<='1';
                            wind_col_in<=(others => (others => '0'));
                            wind_width_count_en<='0';
                        elsif  wind_width_ended_o='0' then --because if max_reachd i need to re initialize window
                            wind_en<='1';
                            wind_col_in<= cache_data_out;
                            wind_width_count_rst<='0';
                            wind_width_count_en<='1';
                            wind_width_count_mode<='1';
                        else
                            wind_en<='0';
                            wind_width_count_en<='0';
                        end if;
        
                        if filter_tbt_o='1' and second_fetch_o='0' then
                            second_fetch<='1';
                            next_state<=fetch_to_image_window;
                        elsif wind_width_ended_o='1' then 
                            next_state<=init_image_cache;
                            second_fetch<='0';  
                            wind_width_count_rst<='1';
                        else
                            next_state<=write_to_memory;
                            second_fetch<='0';  
                        end if; 
        
                    when write_to_memory =>
        
                    when argmax_computation =>
        
                    when write_classification =>
        
                    when end_state =>
                        next_state <= current_state;
            end case;
        
    end process;
                    
    -- This process syncs the reset of cntr1, normally asynchronously reset.
    -- This needs to be synchronized since otherwise we'd have a glitch in the computation of the next state.
    sync_cntr1_reset : process(clk, cntr1_reset_new)
    begin
        if falling_edge(clk) then
            cntr1_reset <= cntr1_reset_new;
        end if;
    end process;
    
    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk, next_state)
    begin
        if falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end Mixed;