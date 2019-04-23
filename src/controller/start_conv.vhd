


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library dcnn;


entity Controller is
    generic (
        N   : natural := 16;  -- precision of the data
        M   : natural := 16  -- size of the address bus
    );
    port (
        clk             :   in  std_logic; --
        io_ready_in     :   in  std_logic; --
        io_done_out     :   out std_logic; -- why is this one used?
        mem_data_in     :   in  std_logic_vector(N - 1 downto 0); --
        mem_data_out    :   out std_logic_vector(N - 1 downto 0); --
        mem_addr_out    :   out std_logic_vector(M - 1 downto 0); --
        mem_write_out   :   out std_logic; -- writes into memory --
        mem_read_out    :   out std_logic; -- reads from memory --
        filter_data_out :   out std_logic_vector(N-1 downto 0);--
	    comp_unit_ready :   out std_logic;--
	    comp_unit_data1_out :   out std_logic_vector(N-1 downto 0);
        comp_unit_data2_out :   out std_logic_vector(N-1 downto 0);
        comp_unit_data1_in : in std_logic_vector(N-1 downto 0);
        comp_unit_data2_in : in std_logic_vector(N-1 downto 0);
        argmax_ready : out std_logic;
        argmax_data_out : out std_logic_vector(N-1 downto 0);
        argmax_data_in : in std_logic_vector(N-1 downto 0)

    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        prepare_state,
        dummy,
        init_filter_window,
        init_image_cache,
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory1,
        write_to_memory2,
	clean_it,
        argmax_computation,
        write_classification,
        end_state
    );

    signal current_state : state_type := prepare_state;
    signal next_state : state_type := dummy;

    signal cntr1_reset : std_logic ;
    signal cntr1_reset_new : std_logic ;
    signal cntr1_enable : std_logic ;
    signal cntr1_mode : std_logic ;
    signal cntr1_max_val : std_logic_vector(4 downto 0) ;
    signal cntr1_max_reached : std_logic := 'Z';
    signal cntr1_data : std_logic_vector(4 downto 0) ;

    signal fltSize_reset : std_logic ;
    signal fltSize_load : std_logic ;
    signal fltSize_data_in : std_logic_vector(N-1 downto 0) ;
    signal fltSize_data_out : std_logic_vector(N-1 downto 0) ;
    signal fltSize_rst_data : std_logic_vector(N-1 downto 0) ;


    signal bias_base_reset : std_logic :='0';
    signal bias_base_load : std_logic ;
    signal bias_base_data_in  : std_logic_vector(M-1 downto 0) :=(others =>'0');
    signal bias_base_data_out : std_logic_vector(M-1 downto 0) ;
    signal bias_base_rst_data : std_logic_vector(M-1 downto 0) ;

    signal bias_offset_reset : std_logic :='0';
    signal bias_offset_load : std_logic ;
    signal bias_offset_data_in  : std_logic_vector(M-1 downto 0) :=(others =>'0');
    signal bias_offset_data_out : std_logic_vector(M-1 downto 0) ;
    signal bias_offset_rst_data : std_logic_vector(M-1 downto 0) ;

    signal flt_bias_reset : std_logic ;
    signal flt_bias_load : std_logic ;
    signal flt_bias_in : std_logic_vector(N-1 downto 0) ;
    signal flt_bias_out : std_logic_vector(N-1 downto 0) ;
    signal flt_bias_rst_data : std_logic_vector(N-1 downto 0) ;

    signal flt_bias2_reset : std_logic ;
    signal flt_bias2_load : std_logic ;
    signal flt_bias2_in : std_logic_vector(N-1 downto 0) ;
    signal flt_bias2_out : std_logic_vector(N-1 downto 0) ;
    signal flt_bias2_rst_data : std_logic_vector(N-1 downto 0) ;


    signal offset_reset : std_logic ;
    signal offset_load  : std_logic ;
    signal offset_address_in : std_logic_vector(M-1 downto 0) :=(others => '0');
    signal offset_address_out : std_logic_vector(M-1 downto 0) :=(others => '0');
    signal offset_rst_data: std_logic_vector(M-1 downto 0) :=(others =>'0') ;

    signal flt_type_rst : std_logic :='0' ;
    signal flt_type_enable : std_logic ;
    signal flt_type_in : std_logic_vector(1 downto 0);
    signal flt_type_out : std_logic_vector(1 downto 0);
    signal flt_type_load : std_logic :='0';


    signal addr1_reset : std_logic ;
    signal addr1_enable : std_logic ;
    signal addr1_mode : std_logic ;
    signal addr1_max_reached : std_logic := 'Z';
    signal addr1_data : std_logic_vector(M-1 downto 0) ;


    
    signal write_base_reset : std_logic ;
    signal write_base_load : std_logic ;
    signal write_base_data_in : std_logic_vector(M-1 downto 0) ;
    signal write_base_data_out : std_logic_vector(M-1 downto 0);
    signal write_base_rst_data : std_logic_vector(M-1 downto 0) ;

    signal write_offset_reset : std_logic ;
    signal write_offset_load : std_logic ;
    signal write_offset_data_in : std_logic_vector(M-1 downto 0) ;
    signal write_offset_data_out : std_logic_vector(M-1 downto 0);
    signal write_offset_rst_data : std_logic_vector(M-1 downto 0) ;

    signal class_cntr_reset : std_logic ;
    signal class_cntr_enable : std_logic;
    signal class_cntr_max_val_in : std_logic_vector(3 downto 0);
    signal class_cntr_mode_in : std_logic;
    signal class_cntr_max_reached_out : std_logic;
    signal class_cntr_counter_out : std_logic_vector(3 downto 0); 


    -- base address where the 10 classification results are saved.
    -- the class cntr is used to get the 10 results for the argmax unit.
    signal argmax_base_reset : std_logic ;
    signal argmax_base_load : std_logic ;
    signal argmax_base_data_in : std_logic_vector(M-1 downto 0) ;
    signal argmax_base_data_out : std_logic_vector(M-1 downto 0) ;
    signal argmax_base_rst_data : std_logic_vector(M-1 downto 0) ;

    signal result_addr_reset : std_logic ;
    signal result_addr_load : std_logic ;
    signal result_addr_data_in : std_logic_vector(M-1 downto 0) ;
    signal result_addr_data_out : std_logic_vector(M-1 downto 0) ;
    signal result_addr_rst_data : std_logic_vector(M-1 downto 0) ;


    signal fltSize_squaredp3 : std_logic_vector(4 downto 0) ;
    signal write_mem_to_fltr : std_logic ;

    signal bias1 : std_logic_vector(N-1 downto 0);
    signal bias2 : std_logic_vector(N-1 downto 0);

    signal channel_ctr_reset : std_logic := '0';
    signal channel_ctr_enable  : std_logic := '0';
    signal channel_ctr_mode: std_logic := '0';
    signal channel_max_reached_out : std_logic;
    signal channel_ctr_out : std_logic_vector(2 downto 0);
    signal channel_ctr_max_val_in : std_logic_vector(2 downto 0);
   -- temps , to be removed.
    signal bias_reset : std_logic; 
    signal bias_load : std_logic;
begin
    fltSize_squaredp3 <= "11100" when fltSize_data_out = X"0005" else "01100";
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');

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
    generic map (
        N => 16
    )
    port map (
        clk => clk,
        reset => fltSize_reset,
        load => fltSize_load,
        d => fltSize_data_in,
        q => fltSize_data_out,
        rst_data => fltSize_rst_data
    );

    reg_bias_base : entity dcnn.Reg 
    port map(
        clk =>clk,
        reset => bias_base_reset,
        load => bias_base_load,
        d => bias_base_data_in,
        q => bias_base_data_out,
        rst_data => bias_base_rst_data
    );

    reg_bias_offset : entity dcnn.Reg
    port map (
        clk => clk,
        reset => bias_offset_reset,
        load => bias_offset_load,
        d => mem_data_in,
        q => bias_offset_data_out,
        rst_data => bias_offset_rst_data
    );

    reg_flt_bias1 : entity dcnn.Reg
    port map(
        clk => clk,
        reset => flt_bias_reset,
        load =>flt_bias_load,
        d => flt_bias_in,
        q =>flt_bias_out,
        rst_data => flt_bias_rst_data
    );   

    reg_flt_bias2 : entity dcnn.Reg
    port map(
        clk => clk,
        reset => flt_bias2_reset,
        load => flt_bias2_load,
        d => flt_bias2_in,
        q => flt_bias2_out,
        rst_data => flt_bias2_rst_data
    );

    -- base and offset used for write_to_memory state.
    reg_write_base : entity dcnn.Reg
    port map(
        clk => clk,
        reset => write_base_reset,
        load => write_base_load,
        d => write_base_data_in,
        q => write_base_data_out,
        rst_data => write_base_rst_data
    );

    reg_write_offset : entity dcnn.Reg
    port map(
        clk => clk,
        reset => write_offset_reset,
        load => write_offset_load,
        d => write_offset_data_in,
        q => write_offset_data_out,
        rst_data => write_offset_rst_data
    );

    
    reg_result_addr : entity dcnn.Reg
    port map(
        clk => clk,
        reset => result_addr_reset,
        load => result_addr_load,
        d => result_addr_data_in,
        q => result_addr_data_out,
        rst_data => result_addr_rst_data

    );
    
    ctr_channel : entity dcnn.counter
    generic map (
        N => 3
    )
    port map (
 	clk => clk,
	reset => channel_ctr_reset,
    enable => channel_ctr_enable,
	mode_in => channel_ctr_mode,
	max_val_in => channel_ctr_max_val_in,
	max_reached_out => channel_max_reached_out,
	counter_out => channel_ctr_out
    );


    -- for counting 10 entries to the Argmax unit.
    cntr_class : entity dcnn.Counter
    generic map (
        N => 4
    ) 
    port map(
        clk => clk,
        reset => class_cntr_reset,
        mode_in => class_cntr_mode_in,
        enable => class_cntr_enable,
        max_reached_out => class_cntr_max_reached_out,
        max_val_in => class_cntr_max_val_in, -- max value in is 10.
        counter_out => class_cntr_counter_out
    );
    -- holds the base address where the 10 results of the FC exist.
    reg_class_base : entity dcnn.Reg
    port map(
        clk => clk,
        reset => argmax_base_reset,
        load => argmax_base_load,
        d => argmax_base_data_in,
        q => argmax_base_data_out,
        rst_data => argmax_base_rst_data
    );


    -- This process computes the next state given the current state and the inputs.
    -- It also generates the state machine outputs based on the current state.
    comp_ns : process(current_state, cntr1_data, fltSize_squaredp3, cntr1_max_reached)
    begin
        case current_state is
            
            when prepare_state =>
            bias_base_data_in <= x"0001";
            bias_base_load <= '1'; 
            ------
            bias_offset_data_in <= x"0001";
            bias_offset_load <= '1';
            -----
            flt_bias_in <= x"0002";
            flt_bias_load  <='1';
            ----
            flt_bias2_load <= '1';
            flt_bias2_in <= x"0003";
            -----

            write_base_data_in <= x"000A";
            write_base_load <= '1';
            ----
            write_offset_data_in <= x"0000";
            write_offset_load <= '1';
            ---
            flt_type_in <= "10";
            flt_type_load <= '1';
            ----
            channel_ctr_enable <= '1';
            channel_ctr_mode <= '0';
            channel_ctr_max_val_in <= (others => '1');

            next_state <= dummy;

            when dummy => 
	  

            next_state <= start_convolution;


            -- Fetch the filter window; Needs a counter.
            when init_filter_window =>

            when init_image_cache =>
            -- NOTE : Where do we load the filter type?
            when start_convolution =>
            comp_unit_data1_out <= (others => '0');
            comp_unit_data2_out <= (others => '0');
            bias1 <= (others =>'0');
            bias2 <= (others =>'0');
            -- if pooling or FC, start computing! "00" for pooling, "01" for FC.
            if layer_type_out = "00" then 
                comp_unit_ready <= '1';
             -- check if FC, if FC use the already stored FC bias
            elsif num_channels_out = "000" and layer_type_out = "01" then
                    bias1 <= (others =>'0');
            elsif num_channels_out = "000" and layer_type_out = "10" then
                    bias1 <= flt_bias_out;
            else
                mem_addr_out<= std_logic_vector(unsigned(bias_offset_data_out) + unsigned(bias_base_data_out));
                mem_read_out <= '1';
                bias1 <= mem_data_in;
                mem_read_out <= '0';
                bias_offset_data_in <= std_logic_vector(unsigned(bias_offset_data_out) +1);
                if fltSize_data_out = x"0005" then  -- can't load twice into the bias offset reg in a single cycle.  
                    bias_offset_load <= '1';
                else
                    bias_offset_load <= '0';
                end if;
                        -- we can make that flt size take only 1 or zero.
                if fltSize_data_out = x"0003" then    
                    if num_channels_out = "000" then 
                        bias2 <= flt_bias2_out;
                    else
                        mem_addr_out <=  std_logic_vector(unsigned(bias_offset_data_out) + unsigned(bias_base_data_out)+1);
                        mem_read_out <= '1';
                        bias2 <= mem_data_in;
                        mem_read_out <= '0';
                        bias_offset_data_in <= std_logic_vector(unsigned(bias_offset_data_out) +2 );
                        bias_offset_load <= '1';    
                    end if;
                else
                    bias2 <= (others => '0');    
                end if;                    
            end if;

            comp_unit_data1_out <= bias1;
            comp_unit_data2_out <= bias2;
            comp_unit_ready <= '1';

            when fetch_to_cache =>
            when fetch_to_image_window =>
            -- we need to add a counter for the convolution process.
            when write_to_memory1 =>
            if fltSize_data_out = x"0005" then
                mem_data_out <=  comp_unit_data1_in;
                mem_addr_out <=   std_logic_vector(unsigned(write_base_data_out)+ unsigned(write_offset_data_out));
                mem_write_out <= '1';
                write_offset_data_in <= std_logic_vector(unsigned(write_offset_data_out) +1);
                write_offset_load <= '1';
                
                next_state <= clean_it;
            else
                mem_data_out <= comp_unit_data1_in;
                mem_addr_out <=  std_logic_vector(unsigned(write_base_data_out) + unsigned(write_offset_data_out));
                mem_write_out <= '1';

                write_offset_data_in <= std_logic_vector(unsigned(write_offset_data_out) +1);
                write_offset_load <= '1';
                next_state <= write_to_memory2;
                
            end if; 
            
            when write_to_memory2 =>
                mem_data_out <= comp_unit_data2_in;
                mem_addr_out <=  std_logic_vector(unsigned(write_base_data_out) + unsigned(write_offset_data_out));
                mem_write_out <= '1';

                write_offset_data_in <= std_logic_vector(unsigned(write_offset_data_out) + 1);
                write_offset_load <= '1';
                next_state <= clean_it;
            when clean_it =>
                -- using the class cntr and argmax base register, getting all elements and feeding them into the argmax unit.
        when argmax_computation =>
            if class_cntr_max_reached_out = '1' then
                    class_cntr_reset <= '1';
                    next_state <= write_classification;
            else
                    class_cntr_enable <= '1';
                    mem_addr_out <=  std_logic_vector(unsigned(class_cntr_counter_out) + unsigned(argmax_base_data_out));
                    mem_read_out <= '1';
                    argmax_ready <= '1';
                    argmax_data_out <= mem_data_in;
                    next_state <= argmax_computation;
            end if;

            -- assuming that the result of the argmax is available at the input : argmax_data_in
            -- so simply, it'll be written into mem[result_addr_data_out]
            when write_classification =>
                    mem_addr_out <= result_addr_data_out;
                    mem_data_out <= argmax_data_in;
                    mem_write_out <= '1';
                    next_state <= end_state;
            when end_state =>
    -- END. should we reset? 
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
end Mixed;