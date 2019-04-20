library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;
use dcnn.constants.all;
use dcnn.config.all;

entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16  -- size of the address bus
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
        filter_data_out :   out std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        init_filter_window,
        init_image_cache,
        init_image_window,
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory,
        argmax_computation,
        write_classification,
        end_state
    );

    type cache_substate_type is (
        fc,
        read_image_height,
        read_image_width,
        start_row,
        read_pixels
    );
    signal current_state : state_type := init_image_cache; --init_filter_window;
    signal next_state : state_type := init_image_cache; --init_filter_window;

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

    signal addr1_reset : std_logic := '0';
    signal addr1_enable : std_logic := '1';
    signal addr1_mode : std_logic := '0';
    signal addr1_max_reached : std_logic := 'Z';
    signal addr1_data : std_logic_vector(M-1 downto 0) := (others => 'Z');

    signal fltSize_squaredp3 : std_logic_vector(4 downto 0) := (others => 'Z');
    signal write_mem_to_fltr : std_logic := '0';
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
    signal cache_height_count_mode : std_logic := '0';
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
    
    signal cur_st : cache_substate_type := fc; -- for cache substates
    signal nxt_st : cache_substate_type := fc;

    signal pad_h,height_edge,fc_signal,read_width :std_logic := '0'; -- control signals
    signal not_clk : std_logic := '0';
    signal width_ended : std_logic := 'Z';
    signal height_ended : std_logic := 'Z';
    signal another_row : std_logic := '0';
    -----------------------------------------------------------
begin
    fltSize_squaredp3 <= "11100" when fltSize_data_out = X"0005" else "01100";
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');
    not_clk <= "not"(clk);
    --width_ended <= '1' when cache_width_ended = '1' else '0';
    -- height_ended <= '1' when cache_height_ended = '1' else '0';
    cache_width_1 <= std_logic_vector(unsigned(cache_width) + 1); --cache_width - 1;
    cache_height_1 <= std_logic_vector(unsigned(cache_width) - 1);

    
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
    ImageCache : entity dcnn.Cache
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
    
    CacheWidthCounter : entity dcnn.Counter 
        generic map (
            N => 16
        ) 
        port map(
            clk => clk,
            reset => cache_width_count_rst,
            enable => cache_width_count_en,
            mode_in => cache_width_count_mode, -- 0 if +1, 1 if -1
            max_val_in => cache_width,
            max_reached_out => cache_width_ended,
            counter_out => cache_width_count
        );

    CacheheightCounter : entity dcnn.Counter
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
    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, cntr1_data, fltSize_squaredp3, cntr1_max_reached ,cur_st,cache_height_ended,cache_width_ended,fc_signal,height_edge,pad_h,mem_data_in,addr1_data)
    begin
        case current_state is
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
                            next_state <= init_image_cache;
                        end if;
                    end case;
            when init_image_cache =>
            mem_addr_out <= addr1_data;
                -- 1: check if FC, set image_width and image_height =5 
                -- 2: else load them from memory.
                -- 3: Outer Loop: for cache_height_count = 0; cache_height_count < image_height; cache_height_count++;
                -- 4:   Inner Loop: for cache_width_count = 0; cache_width_count < image_width; cache_width_count++;
                -- 5:       If pad_h, Load 0 into cache
                -- 6:       else load from memory & increment memory address
                -- 7:       then in both, increment cache_width_count
                -- 8:   --implicitly in the loop: increment cache_height_count and set cache_width_count =0 then check
                -- 9: If height_edge, set pad_h & decrement cache_height_count with certain number & set down height_edge then go to OuterLoop again
                -- 10: finished
            case cur_st is
                when fc =>  --set image height and width to 5
                cache_height_count_rst <= '1';
                cache_height_count_en <= '0';
                    cache_rst <= '1';
                    if fc_signal = '0' then 
                        nxt_st <= read_image_height;
                        --temporary code
                        addr1_reset <= '1';
                    else 
                        cache_height_in <= x"0005";
                        cache_height_load <= '1';
                        cache_width_in <= x"0005";
                        cache_width_load <= '1';
                        nxt_st <= read_pixels;
                    end if;
                    next_state <= current_state;
                when read_image_height =>
                    addr1_reset <= '1'; --assume my address is ready from previouse state unless enable addr1 
                    -- addr1_enable <= '0';
                    addr1_mode <= '0';
                    -- mem_addr_out <= addr1_data;
                    mem_read_out <= '1';
                    mem_write_out <= '0';
                    cache_height_load <= '1';
                    cache_height_in <= mem_data_in;
                    cache_height_count_rst <= '0';
                    nxt_st <= read_image_width;
                    next_state <= current_state;
                when read_image_width =>
                    addr1_reset <= '0';
                    addr1_enable <= '1';
                    mem_read_out <= '1';
                    -- mem_addr_out <= addr1_data;
                    cache_width_load <= '1';
                    cache_width_in <= mem_data_in;

                    -- prepare for next cycle with mode =1 to enter data in column#0 in cache
                    -- cache_width_count_rst <= '0'; --didn't work becouse of Decoder
                    cache_height_count_mode <= '1';
                    cache_height_count_en <= '1';
                    cache_height_count_rst <= '0';
                    -- cache_width_count_rst <= '1';

                    nxt_st <= start_row;
                    next_state <= current_state;
                when start_row =>
                cache_height_count_rst <= '0';
                cache_height_count_en <= '1';
                if cache_height_ended = '1' then 
                    cache_load <= '0';
                else
                --if another_row = '0' then
                    addr1_enable <= '1';
                --else
                   -- addr1_enable <= '0';
                --end if;
                    mem_read_out <= '1';
                    -- mem_addr_out <= addr1_data;
                    cache_load <= '1';
                    cache_rst <= '0';
                    cache_data_in <= mem_data_in;
                    cache_width_count_rst <= '1';
                    cache_width_count_en <= '0'; --don't increment at the start of a row
 		    cache_width_count_mode <= '0';

                    cache_height_count_mode <= '0';
                    -- cache_height_count_rst <= '0';
                    nxt_st <= read_pixels;
                    next_state <= current_state;
                end if;
                when read_pixels => 
                    -- cache_width_count_rst <= '0';
                    -- cache_width_count_en <= '1'; 
                    -- cache_width_count_mode <= '0';
                    cache_height_count_rst <= '0';
                    if cache_height_ended = '0' then 
                        if cache_width_ended = '0' then
                            cache_height_count_en <= '0';
                            -- cache_height_count_rst <= '0';
                            if pad_h = '1' then
                                cache_data_in <= (others => '0');
                                addr1_enable <= '0';
                            else
                                addr1_enable <= '1';
                                mem_read_out <= '1';
                                -- mem_addr_out <= addr1_data;
                                cache_data_in <= mem_data_in;
                            end if;
                            cache_load <= '1';
                            cache_width_count_rst <= '0';
                            cache_width_count_en <= '1'; 
                            nxt_st <= read_pixels;
                            
                        else --inner loop ended
                            cache_load <= '0';
                            -- if end_row = '1' then
                            --     cache_width_count_rst <= '1';
                            -- else
                                -- addr1_enable <= '0';
                                another_row <= '1';
                                cache_width_count_en <= '0';
                                cache_width_count_rst <= '0';

                                cache_height_count_mode <= '0';
                                cache_height_count_en <= '1';
                                -- cache_height_count_rst <= '0';
                                nxt_st <= start_row;
                                
                                -- mem_read_out <= '1';
                                -- mem_addr_out <= addr1_data;
                                -- cache_load <= '1';
                                -- cache_rst <= '0';
                                -- cache_data_in <= mem_data_in;
                                -- end_row <= '1';
                                -- cache_height_count_rst <= '0';
                            -- end if;
                            -- nxt_st <= read_pixels;
                        end if;
                        next_state <= current_state;
                    else --outer loop ended
                        if height_edge = '1'  then 
                            pad_h <= '1';
                            -- TO BE DONE: decrement cache_height_count with some number
                            height_edge <= '0';
                            nxt_st <= read_pixels;
                            next_state <= current_state;
                        else
                            next_state <= init_image_window;
                        end if;
                    end if;
                end case; 
            when init_image_window =>

            when start_convolution =>

            when fetch_to_cache =>
                    
            when fetch_to_image_window =>

            when write_to_memory =>

            when argmax_computation =>

            when write_classification =>

            when others =>
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

    sync_substate : process(clk, nxt_st)
    begin
        if falling_edge(clk) then
            cur_st <= nxt_st;
        end if;
    end process;

    -- end_width: process (cache_width_count_rst, cache_width_ended)
    --     begin
    --         if cache_width_ended = '1' then
    --             width_ended <= '1';
    --         elsif cache_width_count_rst = '1' then
    --             width_ended <= '0';
    --         end if; --else let it latch
    -- end process;
    
    -- end_height: process (cache_height_count_rst, cache_height_ended)
    --     begin
    --         if cache_height_ended = '1' then
    --             height_ended <= '1';
    --         elsif cache_height_count_rst = '1' then
    --             height_ended <= '0';
    --         end if; --else let it latch
    -- end process;
end Mixed;