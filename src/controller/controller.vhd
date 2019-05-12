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
        HREG: natural := 16 --for now since i don't know how big the FC stage img is
        );
    port (
        clk                 :   in  std_logic;
        reset               :   in  std_logic; -- TODO: OR all other resets with this.

        -- IO signals
        io_ready_in         :   in  std_logic;
        io_done_out         :   out std_logic;
        
        -- Memory signals
        mem_data_in         :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out        :   out std_logic_vector(N - 1 downto 0);
        mem_addr_out        :   out std_logic_vector(M - 1 downto 0);
        mem_write_out       :   out std_logic; -- writes into memory
        mem_read_out        :   out std_logic; -- reads from memory
        
        -- To Computation Block
        -- To Image Window
        wind_en             :   out std_logic;
        wind_rst            :   out std_logic;
        wind_col_in         :   out wordarr_t(4 downto 0);
        -- wind_out_vec            :out std_logic_vector(0 to (25*16)-1)

        -- Filter Window input
        filter_data_out     :   out std_logic_vector(N-1 downto 0);
        filter_ready_out    :   out std_logic;
        filter_reset        :   out std_logic;
        
        -- Programming & Bias data
	    comp_unit_ready         :   out std_logic;
        comp_unit_operation     :   out operation_t;
        comp_unit_flt_size      :   out filtersize_t;
        comp_unit_relu          :   out std_logic;
	    comp_unit_data1_out     :   out std_logic_vector(N-1 downto 0);
        comp_unit_data2_out     :   out std_logic_vector(N-1 downto 0);

        -- Inputs from Computation Block
        comp_unit_buffer_finished : in std_logic;
        comp_unit_finished      :   in std_logic;
        comp_unit_data1_in      :   in std_logic_vector(N-1 downto 0);
        comp_unit_data2_in      :   in std_logic_vector(N-1 downto 0);

        -- Argmax Unit
        argmax_ready            :   out std_logic;
        argmax_data_out         :   out std_logic_vector(N-1 downto 0);
        argmax_data_in          :   in std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        got_out_of_reset,
        wait_for_io,
        fetch_nlayers,
        fetch_layer_info_1,
        fetch_layer_info_2,
        fetch_layer_info_3,
        fetch_layer_info_4,
        fetch_layer_info_5,
        fetch_layer_info_6,
        fetch_layer_info_7,
        init_filter_window_1,
        init_filter_window_2,
        fetch_filter_bias,
        init_image_cache_1,
        init_image_cache_2,
        preini_img_window,
        init_image_window,
        start_convolution_1,
        start_convolution_2,
        waiting_on_computation,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory_1,
        write_to_memory_2,
        clean_up,
        clean_up_new_filter,
        clean_up_new_layer,
        argmax_computation,
        write_classification,
        end_state
    );

    -- State signals
    signal current_state : state_type := fetch_nlayers;
    signal next_state : state_type := fetch_nlayers;
    signal actual_next_state : state_type := fetch_nlayers;

    -- General-purpose reset signal.
    signal gen_reset : std_logic := '0'; 
    signal zeros : std_logic_vector(15 downto 0);
    signal ones  : std_logic_vector(15 downto 0);

    -- Generic Counter
    signal cntr1_reset : std_logic;
    signal cntr1_enable : std_logic;
    signal cntr1_mode : std_logic;
    signal cntr1_max_val : std_logic_vector(5 downto 0);
    signal cntr1_max_reached : std_logic;
    signal cntr1_data : std_logic_vector(5 downto 0);

    -- Memory Addressing
    signal addr1_enable : std_logic;
    signal addr1_mode : std_logic;
    signal addr1_max_reached : std_logic;
    signal addr1_data : std_logic_vector(M-1 downto 0);-- := (others => 'Z');
    signal write_mem_to_fltr : std_logic;
    signal mem_read, mem_write : std_logic; 

    -- Layer information signals
    signal nlayers_counter_enable : std_logic;
    signal nlayers_load : std_logic;
    signal nlayers_data_load : std_logic_vector(2 downto 0);
    signal nlayers_max_reached : std_logic;
    signal nlayers_out : std_logic_vector(2 downto 0);

    signal layer_type_load : std_logic;
    signal layer_type_data_load : std_logic_vector(1 downto 0);
    signal layer_type_out : std_logic_vector(1 downto 0);
    signal IsPoolLayer, IsConvLayer, IsFCLayer : std_logic;
    
    signal nflt_layer_enable : std_logic;
    signal nflt_layer_load : std_logic;
    signal nflt_layer_data_load : std_logic_vector(3 downto 0);
    signal nflt_layer_max_reached : std_logic;
    signal nflt_layer_out : std_logic_vector(3 downto 0);
    signal nflt_layer_temp : std_logic_vector(3 downto 0);

    signal flt_size_load : std_logic;
    signal flt_size_data_load : std_logic_vector(2 downto 0);
    signal flt_size_out : std_logic_vector(2 downto 0);
    
    signal new_width_load : std_logic;
    signal new_width_data_load : std_logic_vector(4 downto 0);
    signal new_width_out : std_logic_vector(4 downto 0);

    signal new_size_squared_load : std_logic;
    signal new_size_squared_data_load : std_logic_vector(15 downto 0);
    signal new_size_squared_out : std_logic_vector(15 downto 0);
    
    signal layer_mem_size_load : std_logic;
    signal layer_mem_size_data_load : std_logic_vector(15 downto 0);
    signal layer_mem_size_out : std_logic_vector(15 downto 0);

    signal num_channels_enable : std_logic;
    signal num_channels_load : std_logic;
    signal num_channels_data_load : std_logic_vector(4 downto 0);
    signal num_channels_max_reached : std_logic;
    signal num_channels_out : std_logic_vector(4 downto 0);

    signal max_num_channels_load : std_logic;
    signal max_num_channels_data_in, max_num_channels_data_out : std_logic_vector(4 downto 0);
    
    signal img_width_load : std_logic;
    signal img_width_data_load : std_logic_vector(4 downto 0);
    signal img_width_out : std_logic_vector(4 downto 0);
    signal img_width_reset_data : std_logic_vector(4 downto 0);
    signal img_height_out : std_logic_vector(4 downto 0);

    signal channel_zero_load : std_logic;
    signal channel_zero_data_load_actual : std_logic_vector(0 downto 0);
    signal channel_zero_data_load : std_logic;
    signal channel_zero_out : std_logic;
    signal channel_zero_out_actual : std_logic_vector(0 downto 0);
   
    -- Bias
    signal flt_bias_reset : std_logic;
    signal flt_bias_load : std_logic;
    signal flt_bias_in : std_logic_vector(N-1 downto 0);
    signal flt_bias_out : std_logic_vector(N-1 downto 0);
    signal flt_bias_rst_data : std_logic_vector(N-1 downto 0);

    signal bias_offset_load : std_logic;
    signal bias_offset_data_in  : std_logic_vector(M-1 downto 0);
    signal bias_offset_data_out : std_logic_vector(M-1 downto 0);
    signal bias_offset_rst_data : std_logic_vector(M-1 downto 0);

    signal bias1_load : std_logic;
    signal bias1_data_in : std_logic_vector(N-1 downto 0);
    signal bias1_data_out : std_logic_vector(N-1 downto 0);
    
    --connected to window col counter (normal counter)
    signal wind_width_count: std_logic_vector(15 downto 0); --for cache width counter
    signal wind_width_in : std_logic_vector(15 downto 0); 
    signal wind_width_count_rst : std_logic;
    signal wind_width_count_en : std_logic;
    signal wind_width_count_mode : std_logic;
    signal wind_width_ended : std_logic;
    signal wind_max_width: std_logic_vector(15 downto 0);

    ------------Signals for Cache----------------
    signal cache_height_count: std_logic_vector(15 downto 0); --for cache height counter
    -- signal cache_height_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal cache_height_count_rst : std_logic;
    signal cache_height_count_en : std_logic;
    signal cache_height_count_mode : std_logic_vector(1 downto 0);
    signal cache_height_ended : std_logic;-- := 'Z';
    signal cache_height_1 : std_logic_vector(N-1 downto 0);
    signal max_height : std_logic_vector(15 downto 0);

    signal cache_width_count: std_logic_vector(15 downto 0);-- := (others => 'Z'); --for cache width counter
    -- signal cache_width_in : std_logic_vector(15 downto 0) := (others => '0'); 
    signal cache_width_count_rst : std_logic;
    signal cache_width_count_en : std_logic;
    signal cache_width_count_mode : std_logic;
    signal cache_width_ended : std_logic;-- := 'Z';
    signal cache_width_1 : std_logic_vector(N-1 downto 0);
    

    signal cache_data_in  : std_logic_vector(N - 1 downto 0);
    signal cache_data_out   : wordarr_t(4 downto 0);
    signal cache_out_sel    : std_logic_vector(N-1 downto 0);--(cache_width_count+5); --make sure
    signal cache_load        : std_logic;
    signal cache_rst : std_logic;
    signal cache_rst_actual : std_logic;

    signal not_clk : std_logic;
      
    ----ftc cntrl reg
    signal ftc_cntrl_reg_in: std_logic_vector(15 downto 0);
    signal ftc_cntrl_reg_out: std_logic_vector(15 downto 0);
    signal ftc_cntrl_reg_en: std_logic;
    signal ftc_cntrl_reg_rst: std_logic;
    --ftc cntrl reg in
    signal edged: std_logic;
    signal second_fetch: std_logic;
    signal begin_ftc: std_logic;
    signal ini_wind: std_logic;
    signal finish_wind_row : std_logic;
    --ftc cnrl reg out
    signal edged_o : std_logic;
    signal second_fetch_o : std_logic;
    signal cache_height_ended_o : std_logic;
    signal cache_width_ended_o : std_logic;
    signal wind_width_ended_o : std_logic;
    signal begin_ftc_o : std_logic;
    signal ini_wind_o: std_logic;
    signal finish_wind_row_o : std_logic;
     --for implementation optimization
     signal filter_tbt: std_logic; -- state signal
  

    -- Signals for start convolution
    signal bias1 : std_logic_vector(N-1 downto 0);
    signal bias2 : std_logic_vector(N-1 downto 0);

    -- Signals for Write To Memory
    signal write_base_load : std_logic;
    signal write_base_data_in : std_logic_vector(M-1 downto 0);
    signal write_base_data_out : std_logic_vector(M-1 downto 0);
    signal write_base_rst_data : std_logic_vector(M-1 downto 0);

    signal write_base_prev_load : std_logic;
    signal write_base_prev_data_in : std_logic_vector(M-1 downto 0);
    signal write_base_prev_data_out : std_logic_vector(M-1 downto 0);

    signal write_offset_load : std_logic;
    signal write_offset_data_in : std_logic_vector(M-1 downto 0);
    signal write_offset_data_out : std_logic_vector(M-1 downto 0);
    -- Image Offset
    signal img_addr_en: std_logic;
    signal img_addr_mode: std_logic;
    signal img_addr_max_reached: std_logic;
    signal img_addr_offset : std_logic_vector(M-1 downto 0);
    signal img_addr_offset_reset : std_logic;
    signal img_addr_offset_actual_reset : std_logic;
    -- Image Base Address
    signal img_base_addr_load : std_logic;
    signal img_base_addr_in : std_logic_vector(M-1 downto 0);
    signal img_base_addr:  std_logic_vector(M-1 downto 0);

    -- Signals for Argmax computation
    signal class_cntr_enable : std_logic;
    signal class_cntr_max_val_in : std_logic_vector(3 downto 0);
    signal class_cntr_mode_in : std_logic;
    signal class_cntr_max_reached_out : std_logic;
    signal class_cntr_counter_out : std_logic_vector(3 downto 0); 

    signal random_indicator : std_logic;

    ---for testing window
    -- signal wind_out: wordarr_t(0 to 24);
    -- signal wind_out_vec: std_logic_vector(0 to (25*16)-1);
    -- signal wind_en  : std_logic;
    -- signal  wind_rst :   std_logic;
    -- signal wind_col_in:   wordarr_t(4 downto 0);

begin
    -- Outputs to ComputationBlock
    filter_reset <= reset;
    comp_unit_operation <= convolution when IsConvLayer = '1' or IsFCLayer = '1' else pooling;
    comp_unit_flt_size <= filter3x3 when filter_tbt = '1' else filter5x5;
    -- wind_out_vec<=wind_out(24)
    --                 &wind_out(23)
    --                 &wind_out(22)
    --                 &wind_out(21)
    --                 &wind_out(20)
    --                 &wind_out(19)
    --                 &wind_out(18)
    --                 &wind_out(17)
    --                 &wind_out(16)
    --                 &wind_out(15)
    --                 &wind_out(14)
    --                 &wind_out(13)
    --                 &wind_out(12)
    --                 &wind_out(11)
    --                 &wind_out(10)
    --                 &wind_out(9)
    --                 &wind_out(8)
    --                 &wind_out(7)
    --                 &wind_out(6)
    --                 &wind_out(5)
    --                 &wind_out(4)
    --                 &wind_out(3)
    --                 &wind_out(2)
    --                 &wind_out(1)
    --                 &wind_out(0);
    
   
   
    zeros <= (others => '0');
    ones <= (others => '1');
    -- img_base_addr <= X"9857";
    write_base_rst_data <= X"9B68";
    filter_data_out <= mem_data_in when write_mem_to_fltr = '1' else (others => '0');
    filter_ready_out <= '1' when write_mem_to_fltr = '1' else '0';
    IsPoolLayer <= '1' when layer_type_out = "01" else '0';
    IsConvLayer <= '1' when layer_type_out = "00" else '0';
    IsFCLayer <= '1' when layer_type_out = "10" else '0';
    gen_reset <= reset;
    mem_read_out <= mem_read when reset = '0' else '0';
    mem_write_out <= mem_write when reset = '0' else '0';
    actual_next_state <= next_state when reset = '0' else fetch_nlayers;
    img_height_out <= img_width_out;
    not_clk <= "not"(clk);
    cache_rst_actual <= cache_rst when reset = '0' else '1';
    cache_width_1 <= (15 downto 5=>'0') & std_logic_vector(unsigned(img_width_out) - 1);
    cache_height_1 <= (15 downto 5=>'0') & std_logic_vector(unsigned(img_height_out) - 1);
    --Three by Three filter
    filter_tbt <='1' when flt_size_out = std_logic_vector(to_signed(3, 3)) else '0'; 
    channel_zero_data_load_actual(0) <= channel_zero_data_load;
    channel_zero_out <= channel_zero_out_actual(0);
    class_cntr_max_val_in <= "1010";
    img_addr_offset_actual_reset <= img_addr_offset_reset or gen_reset;

    comp_unit_relu <= '1' when num_channels_out = "00001" and IsConvLayer = '1' else '0';

--FOR TESTING PURPOSES
    -- image_window: entity dcnn.ImageWindow
    -- port map (
    --     d =>wind_col_in,
    --     q =>wind_out,
    --     clk =>not_clk,
    --     load=> wind_en,
    --     reset =>wind_rst
    -- );

    -- Layer Information Components
    nlayers : entity dcnn.LoadedCounter
    generic map (N => 3)
    port map (
        clk => clk, reset => gen_reset, enable => nlayers_counter_enable,
        load => nlayers_load, mode_in => ones(0), max_val_in => "001",
        load_data_in => nlayers_data_load, max_reached_out => nlayers_max_reached,
        counter_out => nlayers_out
    );
    
    layer_type : entity dcnn.Reg
    generic map (N => 2)
    port map (
        clk => clk, reset => gen_reset, load => layer_type_load, 
        d => layer_type_data_load, q => layer_type_out, rst_data => zeros(1 downto 0)
    );

    nflt_layer_cntr : entity dcnn.LoadedCounter
    generic map (N => 4)
    port map (
        clk => clk, reset => gen_reset, enable => nflt_layer_enable,
        load => nflt_layer_load, mode_in => '1', max_val_in => "0001",
        load_data_in => nflt_layer_data_load, max_reached_out => nflt_layer_max_reached,
        counter_out => nflt_layer_out
    );

    nflt_layer_total : entity dcnn.Reg
    generic map (N => 4)
    port map (
        clk => clk, reset => gen_reset, load => nflt_layer_load, 
        d => nflt_layer_data_load, q => nflt_layer_temp, rst_data => zeros(3 downto 0)
    );

    flt_size : entity dcnn.Reg
    generic map (N => 3)
    port map (
        clk => clk, reset => gen_reset, load => flt_size_load, 
        d => flt_size_data_load, q => flt_size_out, rst_data => zeros(2 downto 0)
    );

    new_width : entity dcnn.Reg
    generic map (N => 5)
    port map (
        clk => clk, reset => gen_reset, load => new_width_load,
        d => new_width_data_load, q => new_width_out, rst_data => zeros(4 downto 0)
    );

    new_size_squared : entity dcnn.Reg
    port map (
        clk => clk, reset => gen_reset, load => new_size_squared_load,
        d => new_size_squared_data_load,  q => new_size_squared_out, rst_data => zeros
    );

    layer_mem_size : entity dcnn.Reg
    port map (
        clk => clk, reset => gen_reset, load => layer_mem_size_load,
        d => layer_mem_size_data_load,  q => layer_mem_size_out, rst_data => zeros
    );

    num_channels : entity dcnn.LoadedCounter
    generic map (N => 5)
    port map (
        clk => clk, reset => gen_reset, enable => num_channels_enable,
        load => num_channels_load, mode_in => '1', max_val_in => zeros(4 downto 0),
        load_data_in => num_channels_data_load, max_reached_out => num_channels_max_reached,
        counter_out => num_channels_out
    );

    max_num_channels_inst : entity dcnn.Reg
    generic map (N => 5)
    port map (
        clk => clk, reset => gen_reset, load => max_num_channels_load,
        d => max_num_channels_data_in, q => max_num_channels_data_out, rst_data => "00001"
    );

 
    img_width : entity dcnn.Reg
    generic map ( N => 5 )
    port map (
        clk => clk, reset => gen_reset, load => img_width_load,
        d => img_width_data_load, q => img_width_out, rst_data =>  "11100"
    );

    channel_zero : entity dcnn.Reg
    generic map ( N => 1 )
    port map (
        clk => clk, reset => gen_reset, load => channel_zero_load,
        d => channel_zero_data_load_actual, q => channel_zero_out_actual, rst_data => zeros(0 downto 0)
    );

    -- Filter biases
    reg_flt_bias1 : entity dcnn.Reg
    port map(
        clk => clk,
        reset => flt_bias_reset,
        load =>flt_bias_load,
        d => flt_bias_in,
        q =>flt_bias_out,
        rst_data => flt_bias_rst_data
    );
    
    -- Generic counter
    cntr1_inst : entity dcnn.Counter
    generic map (N => 6)
    port map (
        clk => clk,
        reset => cntr1_reset,
        enable => cntr1_enable,
        mode_in => cntr1_mode,
        max_val_in => cntr1_max_val,
        max_reached_out => cntr1_max_reached,
        counter_out => cntr1_data
    );
    
    -- Memory addressing
    cntr_mem_addr : entity dcnn.Counter
    generic map (
        N => 16
    ) 
    port map (
        clk => clk,
        reset => gen_reset,
        enable => addr1_enable,
        mode_in => addr1_mode,
        max_val_in => ones,
        max_reached_out => addr1_max_reached,
        counter_out => addr1_data
    );

    img_base_addr_inst : entity dcnn.Reg
    port map (
        clk => clk,
        reset => reset,
        load => img_base_addr_load,
        d => img_base_addr_in,
        q => img_base_addr,
        rst_data => X"9857"
    );

    img_mem_addr_offset : entity dcnn.Counter
    generic map (
        N => 16
    ) 
    port map (
        clk => clk,
        reset => img_addr_offset_actual_reset,
        enable => img_addr_en,
        mode_in => img_addr_mode,
        max_val_in => ones,
        max_reached_out => img_addr_max_reached,
        counter_out => img_addr_offset
    );

    -- Image Cache components
    img_cache : entity dcnn.Cache
        port map(
            in_word => cache_data_in,
            cache_in_sel => cache_width_count(4 downto 0),
            cache_out_sel  =>wind_width_count(4 downto 0), --not used here
            decoder_enable => cache_load,
            out_column => cache_data_out,
            clk => not_clk,
            reset => cache_rst_actual
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
        max_val_in => max_height,
        max_reached_out => cache_height_ended,
        counter_out => cache_height_count
    );

    --Image window components
    window_width_cntr : entity dcnn.Counter 
    generic map (
        N => 16
    ) 
    port map(
        clk => clk,
        reset => wind_width_count_rst,
        enable => wind_width_count_en,
        mode_in => wind_width_count_mode, -- 0 if +1, 1 if -1
        max_val_in => wind_max_width,
        max_reached_out => wind_width_ended,
        counter_out => wind_width_count
    );


    ---making a control reg for the sake of homogienity inside states
    

    ftc_cntrl_reg_in<= 
                    edged & --15
                    second_fetch & --14
                    cache_height_ended &  --13
                    cache_width_ended & --12
                    wind_width_ended & --11
                    begin_ftc & --10
                    ini_wind & --9
                    finish_wind_row & --8
                    (7 downto 0 =>'0');

    (edged_o,second_fetch_o,
    cache_height_ended_o,
    cache_width_ended_o,
    wind_width_ended_o,
    begin_ftc_o,
    ini_wind_o,
    finish_wind_row_o) <= ftc_cntrl_reg_out(15 downto 8);

    ftc_cntrl_reg : entity dcnn.Reg
    port map (
        clk => not_clk,
        reset => ftc_cntrl_reg_rst,
        load => ftc_cntrl_reg_en,
        d => ftc_cntrl_reg_in,
        q => ftc_cntrl_reg_out,
        rst_data => zeros
    );

    -- Convolution data
    reg_bias_offset : entity dcnn.Reg
    port map (
        clk => clk,
        reset => gen_reset,
        load => bias_offset_load,
        d => bias_offset_data_in,
        q => bias_offset_data_out,
        rst_data => bias_offset_rst_data
    );

    bias1_reg : entity dcnn.Reg
    port map (
        clk => clk,
        reset => gen_reset,
        load => bias1_load,
        d => bias1_data_in,
        q => bias1_data_out,
        rst_data => zeros
    );

    -- Write to memory.
    reg_write_base : entity dcnn.Reg
    port map(
        clk => not_clk,
        reset => gen_reset,
        load => write_base_load,
        d => write_base_data_in,
        q => write_base_data_out,
        rst_data => write_base_rst_data
    );

    reg_write_base_prev : entity dcnn.Reg
    port map(
        clk => clk,
        reset => gen_reset,
        load => write_base_prev_load,
        d => write_base_prev_data_in,
        q => write_base_prev_data_out,
        rst_data => zeros
    );

    reg_write_offset : entity dcnn.Reg
    port map(
        clk => not_clk,
        reset => gen_reset,
        load => write_offset_load,
        d => write_offset_data_in,
        q => write_offset_data_out,
        rst_data => zeros
    );
    
    -- Argmax Result
    -- Counting 10 entries in the Argmax unit
    cntr_class : entity dcnn.Counter
    generic map (
        N => 4
    ) 
    port map(
        clk => not_clk,
        reset => gen_reset,
        mode_in => class_cntr_mode_in,
        enable => class_cntr_enable,
        max_reached_out => class_cntr_max_reached_out,
        max_val_in => class_cntr_max_val_in, -- max value in is 10.
        counter_out => class_cntr_counter_out
    );
    
    
    comp_ns : process(current_state, io_ready_in,
    addr1_data, mem_data_in,
    layer_type_out, IsConvLayer, IsPoolLayer,
    IsFCLayer, channel_zero_out, flt_bias_out, write_offset_data_out, write_base_prev_data_out,
    write_base_data_out, bias_offset_data_out, bias1, bias2,
    bias1_data_out, comp_unit_data1_in, comp_unit_data2_in, comp_unit_finished, new_size_squared_out,
    nlayers_max_reached, num_channels_max_reached,
    new_width_out, layer_mem_size_out,
    nflt_layer_max_reached, class_cntr_max_reached_out,
    class_cntr_counter_out, img_addr_offset, img_base_addr,
    cache_height_ended_o,edged_o,cache_width_ended_o,second_fetch_o,wind_width_ended_o,
    cache_data_out,cache_height_ended,cache_width_ended,ini_wind_o,ini_wind,
    finish_wind_row,finish_wind_row_o, begin_ftc_o, cache_width_1,
    cache_height_1, wind_width_count, argmax_data_in,
    cntr1_max_reached, filter_tbt, nflt_layer_temp, nflt_layer_out, max_num_channels_data_out
    )
    begin
        -- Signals associated with components
        -- Layer Info
        nlayers_counter_enable <= '0';
        nlayers_load <= '0';
        nlayers_data_load <= (others => '0');
        layer_type_load <= '0';
        layer_type_data_load <= (others => '0');
        nflt_layer_enable <= '0';
        nflt_layer_load <= '0';
        nflt_layer_data_load <= (others => '0');
        flt_size_load <= '0';
        flt_size_data_load <= (others => '0');
        new_width_load <= '0';
        new_width_data_load <= (others => '0');
        new_size_squared_load <= '0';
        new_size_squared_data_load <= (others => '0');
        layer_mem_size_load <= '0';
        layer_mem_size_data_load <= (others => '0');
        num_channels_enable <= '0';
        num_channels_load <= '0';
        num_channels_data_load <= (others => '0');
        max_num_channels_load <= '0';
        max_num_channels_data_in <= (others => '0');
        img_width_load <= '0';
        img_width_data_load <= (others => '0');
        -- Filter biases
        flt_bias_reset <= '0';
        flt_bias_load <= '0';
        flt_bias_in <= (others => '0');
        flt_bias_rst_data <= (others => '0');
        -- Generic counter
        cntr1_reset <= '0';
        cntr1_enable <= '0';
        cntr1_mode <= '0';
        cntr1_max_val <= (others => '1');
        -- Memory Addressing counter
        addr1_enable <= '0';
        addr1_mode <= '0';
        img_addr_offset_reset <= '0';
        img_base_addr_load <= '0';
        img_base_addr_in <= (others => '0');
        -- Image Cache
        cache_data_in <= (others => '0');
        cache_out_sel <= (others => '0');
        cache_load <= '0';
        cache_rst <= '0';
        cache_width_count_rst <= '0';
        cache_width_count_en <= '0';
        cache_width_count_mode <= '0';
        -- cache_width_1
        cache_height_count_rst <= '0';
        cache_height_count_en <= '0';
        cache_height_count_mode <= "00";
        -- max_height <= X"001C"; -- Is this real?
        max_height <= cache_height_1;
        edged <= edged_o;
        second_fetch <= second_fetch_o;
        begin_ftc <= begin_ftc_o;
        ini_wind <= ini_wind_o;
        finish_wind_row <= finish_wind_row_o;
        -- Image window
        wind_width_in <= (others => '0');
        wind_width_count_rst <= '0';
        wind_width_count_en <= '0';
        wind_width_count_mode <= '0';
        -- wind_max_width <= X"0005"; -- Is this real too?
        wind_max_width<=cache_width_1; 
        wind_en <= '0';
        wind_rst <= '0';
        ftc_cntrl_reg_rst <= '0';
        ftc_cntrl_reg_en <= '0';
        wind_col_in <= cache_data_out; --(others => (others => '0'));
        img_addr_en <= '0';
        img_addr_mode<='0';
        -- Convolution data
        bias1 <= (others => '0');
        bias1_load <= '0';
        bias1_data_in <= (others => '0');
        bias2 <= (others => '0');
        bias_offset_load <= '0';
        bias_offset_data_in <= (others => '0');
        bias_offset_rst_data <= (others => '0');
        -- Write to memory registers
        write_base_load <= '0';
        write_base_data_in <= (others => '0');
        write_base_prev_load <= '0';
        write_base_prev_data_in <= (others => '0');
        write_offset_load <= '0';
        write_offset_data_in <= (others => '0');
        -- Argmax result
        class_cntr_mode_in <= '0';
        class_cntr_enable <= '0';
        -- Misc signals
        channel_zero_load <= '0';
        channel_zero_data_load <= '0';
        -- Outputs
        comp_unit_data1_out <= (others => '0');
        comp_unit_data2_out <= (others => '0');
        write_mem_to_fltr <= '0';
        mem_read <= '0';
        mem_write <= '0';
        mem_addr_out <= (others => '0');
        io_done_out <= '0';
        mem_data_out <= (others => '0');
        comp_unit_ready <= '0';
        argmax_ready <= '0';
        argmax_data_out <= (others => '0');
        random_indicator <= '0';
        next_state <= current_state;
        case current_state is
            when got_out_of_reset =>
                next_state <= wait_for_io;
            when wait_for_io =>
                if io_ready_in = '0' then
                    next_state <= wait_for_io;
                else
                    next_state <= fetch_nlayers;
                end if;
            when fetch_nlayers => -- Fetches the number of layers from memory
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                nlayers_load <= '1';
                nlayers_data_load <= mem_data_in(2 downto 0);
                num_channels_data_load <= "00001";
                num_channels_load <= '1';
                next_state <= fetch_layer_info_1;
            when fetch_layer_info_1 => -- Fetches the layer type from memory
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                layer_type_load <= '1';
                layer_type_data_load <= mem_data_in(1 downto 0);
                next_state <= fetch_layer_info_2;
            when fetch_layer_info_2 => -- Fetches nflt_layer
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                nflt_layer_load <= '1';
                nflt_layer_data_load <= mem_data_in(3 downto 0);
                next_state <= fetch_layer_info_3;
            when fetch_layer_info_3 => -- Fetches new filter size
                addr1_enable <= '1';
                mem_addr_out <= addr1_data; 
                mem_read <= '1';
                flt_size_load <= '1';
                flt_size_data_load <= mem_data_in(2 downto 0);
                next_state <= fetch_layer_info_4;
            when fetch_layer_info_4 => -- Fetches new image size
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                new_width_load <= '1';
                new_width_data_load <= mem_data_in(4 downto 0);
                next_state <= fetch_layer_info_5;
            when fetch_layer_info_5 => -- Fetch new image size squared
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                new_size_squared_load <= '1';
                new_size_squared_data_load <= mem_data_in;
                next_state <= fetch_layer_info_6;
            when fetch_layer_info_6 => -- Fetch total mem area taken by the following layer
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                layer_mem_size_load <= '1';
                layer_mem_size_data_load <= mem_data_in;
                if layer_type_out = "10" then -- If FC, fetch the no. of channels.
                    next_state <= fetch_layer_info_7;
                else
                    next_state <= fetch_filter_bias;
                end if;
            when fetch_layer_info_7 => -- Fetch the new number of channels (for the FC layer)
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                num_channels_load <= '1';
                num_channels_data_load <= mem_data_in(4 downto 0);
                max_num_channels_load <= '1';
                max_num_channels_data_in <= mem_data_in(4 downto 0);
                img_width_load <= '1';
                img_width_data_load <= "00101"; -- i.e. 5
                next_state <= fetch_filter_bias;
            when fetch_filter_bias =>
                channel_zero_load <= '1';
                channel_zero_data_load <= '1';
                if IsConvLayer = '1' or IsFCLayer = '1' then
                    addr1_enable <= '1';
                    mem_addr_out <= addr1_data;
                    mem_read <= '1';
                    flt_bias_load <= '1';
                    flt_bias_in <= mem_data_in;
                end if;
                if nflt_layer_temp = nflt_layer_out then
                    write_base_prev_load <= '1';
                    write_base_prev_data_in <= write_base_data_out;
                end if;
                next_state <= init_filter_window_1;
            when init_filter_window_1 =>
                if IsPoolLayer = '1' then
                    next_state <= init_image_cache_1;
                else
                    mem_addr_out <= addr1_data;
                    mem_read <= '1';
                    -- addr1_enable <= '1';
                    write_mem_to_fltr <= '1';
                    cntr1_reset <= '1';
                    next_state <= init_filter_window_2;
                end if;
            when init_filter_window_2 =>
                cntr1_enable <= '1';
                cntr1_mode <= '0';
                if filter_tbt = '1' then
                    cntr1_max_val <= "001001"; -- 9
                else
                    cntr1_max_val <= "011001"; -- 25
                end if;
                addr1_enable <= '1';
                mem_addr_out <= addr1_data;
                mem_read <= '1';
                write_mem_to_fltr <= '1';
                if cntr1_max_reached = '0' then
                    next_state <= init_filter_window_2;
                else
                    mem_read <= '0';                
                    write_mem_to_fltr <= '0';
                    next_state <= init_image_cache_1; -- should be init_image_cache
                end if;
            when init_image_cache_1 =>
                -- Cleaning up from Init filter window
                cntr1_enable <= '0';
                write_mem_to_fltr <= '0';
                mem_read <= '0';
                addr1_enable <= '0';
                nflt_layer_enable <= '0';

                -- Properly set the maximum width and height
                max_height <= x"0005";
                -- Reset stuff
                cntr1_reset <= '1';
                ftc_cntrl_reg_rst <= '1';--reset control register
                ftc_cntrl_reg_en <= '0';
                cache_rst <= '1'; --reset cache and its counters
                cache_width_count_rst <= '1';
                cache_width_count_mode <= '0';
                cache_height_count_rst <= '1';
                cache_height_count_mode <= "00";
                -- Next state is the loop
                next_state <= init_image_cache_2;

            when init_image_cache_2 =>
                max_height <= x"0005";
                cache_height_count_mode <= "00";
                cache_width_count_mode <= '0';
                cache_rst <= '0';
                ftc_cntrl_reg_rst <= '0';
                ftc_cntrl_reg_en <= '1';

                if cache_height_ended_o = '0' then 
                    if cache_width_ended_o = '0' then --add pixel to cache
                        img_addr_en <= '1';
                        img_addr_mode<= '0';
                        mem_addr_out <= std_logic_vector(unsigned(img_base_addr) + unsigned(img_addr_offset));
                        mem_read <= '1';
                        cache_data_in <= mem_data_in;
                        cache_load <= '1';

                        cache_height_count_en <= '0';
                        cache_width_count_rst <= '0';
                        if begin_ftc_o='0' then  -- starting new row   
                            cache_width_count_en<='0';
                            begin_ftc<='1';
                        else
                            cache_width_count_en<='1';
                            begin_ftc<='1';
                        end if;
                    else --inner loop ended
                        img_addr_en <= '0';
                        mem_read <= '0';
                        cache_load <= '0';
                        cache_width_count_en <= '0';
                        cache_width_count_rst <= '1';
                        begin_ftc <= '0';

                        cache_height_count_en <= '1';
                        cache_height_count_rst <= '0';

                    end if;
                    next_state <= current_state;
                else --outer loop ended
                    cache_width_count_rst <= '1'; --resetting for next states 
                    cache_height_count_en <= '0';
                    next_state <= preini_img_window;
                    wind_width_count_rst <= '1';
                    ini_wind <= '1';
                    edged <= '0';
                    second_fetch<='0';
                    img_addr_en <= '0';
                
                end if;
            when preini_img_window => --for the sake of reusing this state for fetch to wind
                -- Cleaning up
                num_channels_enable <= '0';
                write_offset_load <= '0';
                -- Preparing
                -- wind_max_width <= x"0004";
                cache_height_count_en <= '0';
                ftc_cntrl_reg_rst <= '0'; 
                ftc_cntrl_reg_en<='1';
                if finish_wind_row_o = '1' then
                    next_state<= fetch_to_cache;
                elsif ini_wind_o     ='1' then
                    next_state <= init_image_window;
                    wind_width_count_rst<='1';
                else
                    next_state<= start_convolution_1;
                    wind_width_count_rst<='0';
                end if;
                
            when init_image_window =>
                ftc_cntrl_reg_en<='1';
                img_addr_en <= '0';
                
                wind_rst<='0';                
                cache_height_count_en <= '0';
                if wind_width_ended_o = '0' then  --If window_col_count != 5
                    if filter_tbt = '1' then
                        wind_max_width <= x"0003";
                    else
                        wind_max_width <= x"0004";
                    end if;
                    wind_col_in<= cache_data_out;
                    wind_en <= '1';

                    wind_width_count_rst<='0';
                    if ini_wind_o='1' then
                        ini_wind<='0';
                        wind_width_count_en <= '0';
                    else
                        wind_width_count_en <= '1';
                    end if;
                    
                    wind_width_count_mode<='0';
                    next_state <= current_state;
                else
                    wind_width_count_rst <= '0';
                    wind_width_count_en <= '0';
                    wind_en <= '0';
                    next_state <= start_convolution_1;   
                    wind_max_width<=cache_width_1; 
                end if;
            when start_convolution_1 =>
                bias1 <= (others => '0');
                if IsPoolLayer = '1' then -- Pooling
                    comp_unit_ready <= '1';
                elsif channel_zero_out = '1' then
                    bias1 <= flt_bias_out;
                else
                    mem_addr_out <= std_logic_vector(unsigned(write_offset_data_out) + unsigned(write_base_data_out));
                    mem_read <= '1';
                    bias1 <= mem_data_in;
                    bias_offset_load <= '1';
                    bias_offset_data_in <= std_logic_vector(unsigned(write_offset_data_out) +1);
                end if;
                comp_unit_data1_out <= bias1;
                if filter_tbt = '1' then
                    next_state <= start_convolution_2;
                else
                    comp_unit_ready <= '1';
                    next_state <= waiting_on_computation;
                end if;
                bias1_load <= '1';
                bias1_data_in <= bias1;
                wind_width_count_rst <= '0';
            when start_convolution_2 =>
                comp_unit_data1_out <= bias1_data_out;
                bias2 <= (others =>'0');
                if channel_zero_out = '1'  then
                    bias2 <= flt_bias_out;
                else
                    mem_addr_out <= std_logic_vector(unsigned(bias_offset_data_out) + unsigned(write_base_data_out));
                    mem_read <= '1';
                    bias2 <= mem_data_in; 
                end if;
                comp_unit_data2_out <= bias2;
                comp_unit_ready <= '1';
                next_state <= waiting_on_computation;
                wind_width_count_rst <= '0';
            when waiting_on_computation =>
                if comp_unit_finished = '1' then
                    if IsFCLayer = '1' then
                        next_state <= write_to_memory_1;
                    else
                        next_state <= fetch_to_cache;
                    end if;
                else
                    next_state <= waiting_on_computation;
                end if;
            when fetch_to_cache =>  
                --Making sure signals are correctly set
                ftc_cntrl_reg_en<='1';
                ftc_cntrl_reg_rst<='0'; ----must be reset at end on ini windowwwww please.
                max_height<=cache_height_1;
             
                wind_en <= '0';
                --Deciding when to incremend counters (height and width)
                if cache_width_ended_o='1' then 
                    cache_width_count_rst<='1'; -- rst to 0000
                    cache_width_count_en<='0';
                    finish_wind_row<='0';
                    wind_width_count_rst<='1'; -- rst to 0000
                    ini_wind<='1';
                    begin_ftc<='0';
    
                    if cache_height_ended_o='0' then
                        cache_height_count_rst<='0';       
                        cache_height_count_en<='1'; 
                        cache_height_count_mode<="00"; -- to increment 1
                        
                    else
                        cache_height_count_en<='0'; 
                    end if;
                    
                    next_state<=write_to_memory_1;
                    second_fetch<='0';
                     
                else
                    ini_wind<='0';
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

                    if  filter_tbt='1' and second_fetch_o='0' then-- and (cache_width_ended_o='0' or (cache_width_ended_o='1' and cache_width(0)='1')) then --even with so i can fetch again
                         next_state<=fetch_to_cache;
                         second_fetch<='1';
                   elsif finish_wind_row_o='1' then    
                        next_state<= fetch_to_cache;
                        second_fetch<='0';
                    else
                        next_state<=fetch_to_image_window;
                        second_fetch<='0';
                    end if;

                end if;
                
                   --Deciding if i'm about to load 0's into cache
                if (cache_width_ended='1' and cache_height_ended='1') or edged_o='1' then -- for self latching
                   edged<='1';
                else
                   edged<='0';
                end if;               
                --What value will be pushed into cache
                if  edged_o='0' then  --undefined in first time, should be pre initialized to 0 in some previouse state
                    if cache_width_ended_o='1' then 
                        img_addr_en <='0'; 
                        cache_load<='0';
                    else
                        img_addr_en <='1'; 
                        img_addr_mode<='0'; -- given that it is a counter that only jumps +1
                        mem_read <='1';
                        mem_addr_out <= std_logic_vector(unsigned(img_base_addr) + unsigned(img_addr_offset));
                        cache_data_in<=mem_data_in;
                        cache_load<='1';
                    end if;
                else    
                    if filter_tbt = '1' and cache_width_ended_o = '0' then
                        cache_load <= '1';
                    else
                        cache_load <= '0';
                    end if;
                    cache_data_in<=(others=>'0'); --insert 0
                    img_addr_en <='0';
                    mem_read <='0';
                    
                end if;
                --decide next state
                -- if  filter_tbt='1' and second_fetch_o='0' and ini_wind='0' then-- and (cache_width_ended_o='0' or (cache_width_ended_o='1' and cache_width(0)='1')) then --even with so i can fetch again
                --     next_state<=fetch_to_cache;
                --     second_fetch<='1';
                -- elsif finish_wind_row_o='1' then    
                --     next_state<= fetch_to_cache;
                --     second_fetch<='0';
                -- elsif ini_wind='1' then
                --     next_state<=write_to_memory_1;
                --     second_fetch<='0';
                -- else 
                --     next_state<=fetch_to_image_window;
                --     second_fetch<='0';
                -- end if;
                --prepae for fetch to iimg_wind
            when fetch_to_image_window => --assuming col counter is at 4 (first window already initialized)
            --cache in sel is window_col_counter.
    
            --- I'll disable alll uneeded counterrrrss and stuff 
                cache_load<='0';   
                cache_width_count_en<='0';
                cache_height_count_en<='0';
                img_addr_en <='0'; 
                mem_read <='0';
                ftc_cntrl_reg_en<='1';
                ftc_cntrl_reg_rst<='0';
                -- wind_max_width<=cache_width_1; 
                cache_out_sel<= wind_width_count;
                if wind_width_ended_o='1' and filter_tbt='1'  then
                    wind_en<='1';
                    wind_col_in<=(others => (others => '0'));
                    wind_width_count_en<='0';
                elsif  wind_width_ended_o='0' then --because if max_reachd i need to re initialize window
                    wind_en<='1';
                    wind_col_in<= cache_data_out;
                    wind_width_count_rst<='0';
                    wind_width_count_en<='1';
                    wind_width_count_mode<='0';
                else
                    wind_en<='0';
                    wind_width_count_en<='0';
                end if;
       
                --decide next state
                if filter_tbt='1' and second_fetch_o='0' then
                    second_fetch<='1';
                    next_state<=fetch_to_image_window;    
                else          
                    if wind_width_ended_o='1' then
                        finish_wind_row <= '1'; -- reset signal 
                        next_state<=fetch_to_cache;
                    else
                        finish_wind_row <= '0';
                        next_state<=write_to_memory_1;
                    end if; 
                    
                    second_fetch<='0';  
                end if; 
            when write_to_memory_1 =>
                -- wind_en <= '1';
                mem_data_out <= comp_unit_data1_in;
                mem_addr_out <= std_logic_vector(unsigned(write_base_data_out) + unsigned(write_offset_data_out));
                mem_write <= '1';
                write_offset_data_in <= std_logic_vector(unsigned(write_offset_data_out) + 1);
                write_offset_load <= '1';
                if filter_tbt = '1' then
                    next_state <= write_to_memory_2;
                else
                    next_state <= clean_up;
                end if;
            when write_to_memory_2 =>
                -- wind_en <= '0';
                mem_data_out <= comp_unit_data2_in;
                mem_addr_out <= std_logic_vector(unsigned(write_base_data_out) + unsigned(write_offset_data_out));
                mem_write <= '1';
                write_offset_data_in <= std_logic_vector(unsigned(write_offset_data_out) + 1);
                write_offset_load <= '1';
                next_state <= clean_up;
            when clean_up =>
                -- wind_en <= '0';
                if not(write_offset_data_out = new_size_squared_out) then -- channel unfinished
                    next_state <= preini_img_window; -- should be initialize window
                else
                    write_offset_load <= '1';
                    write_offset_data_in <= (others => '0'); -- write_offset = 0
                    if num_channels_max_reached = '0' then -- new channel
                        num_channels_enable <= '1'; -- decrement the channel
                        channel_zero_load <= '1';
                        channel_zero_data_load <= '0';
                        next_state <=  init_filter_window_1;
                        if IsPoolLayer = '1' then
                            -- A new channel for a pooling layer is like a new filter for a convolution layer. It writes to a new part of the memory.
                            write_base_load <= '1';
                            write_base_data_in <= std_logic_vector(unsigned(write_base_data_out) + unsigned(new_size_squared_out));
                        end if;
                    else
                        img_addr_offset_reset <= '1'; -- reset the image offset address
                        if nflt_layer_max_reached = '0' then -- new filter..
                            next_state <= clean_up_new_filter;
                        elsif nlayers_max_reached = '0' then -- new layer
                            next_state <= clean_up_new_layer;
                        else -- finished all layers
                            next_state <= argmax_computation;
                        end if;
                    end if;
                end if;
            when clean_up_new_filter =>
                write_base_data_in <= std_logic_vector(unsigned(write_base_data_out) + unsigned(new_size_squared_out));
                write_base_load <= '1';
                nflt_layer_enable <= '1';
                num_channels_load <= '1';
                num_channels_data_load <= max_num_channels_data_out;
                next_state <= fetch_filter_bias;
            when clean_up_new_layer =>
                -- write_base_load <= '1';
                -- if IsPoolLayer = '1' then
                -- write_base_data_in <= std_logic_vector(unsigned(write_base_data_out) + unsigned(layer_mem_size_out)); -- write_base += LayerMemSize
                -- TODO: Fix img_base_addr <-- write_base_prev_data_out
                -- img_base_addr = write_base_prev_data_out
                nlayers_counter_enable <= '1';
                write_base_data_in <= std_logic_vector(unsigned(write_base_data_out) + unsigned(new_size_squared_out));
                write_base_load <= '1';
                img_base_addr_load <= '1';
                img_base_addr_in <= std_logic_vector(unsigned(write_base_prev_data_out) - 1);
                if IsPoolLayer = '1' then
                    num_channels_load <= '1';
                    num_channels_data_load <= max_num_channels_data_out;
                else
                    max_num_channels_load <= '1';
                    max_num_channels_data_in <= "0" & nflt_layer_temp;
                    num_channels_load <= '1';
                    num_channels_data_load <= "0" & nflt_layer_temp; -- ImgChannels = nflt_layer
                end if;
                img_width_load <= '1';
                img_width_data_load <= new_width_out; -- ImgWidth = NewWidth
                next_state <= fetch_layer_info_1;
            when argmax_computation =>
                if class_cntr_max_reached_out = '1' then
                    next_state <= write_classification;
                else
                    class_cntr_enable <= '1';
                    mem_addr_out <=  std_logic_vector(unsigned(class_cntr_counter_out) + unsigned(write_base_data_out) - 9);
                    mem_read <= '1';
                    argmax_ready <= '1';
                    argmax_data_out <= mem_data_in;
                    next_state <= argmax_computation;
                end if;
            when write_classification =>
                -- Write the classification to the last place in memory.
                mem_addr_out <= (others => '1'); --std_logic_vector(unsigned(class_cntr_counter_out) + unsigned(write_base_data_out));
                mem_data_out <= argmax_data_in;
                mem_write <= '1';
                next_state <= end_state;
            when end_state =>
                next_state <= end_state;
            end case;
    end process;

    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk, reset, next_state)
    begin
        if reset = '1' then
            current_state <= got_out_of_reset;
        elsif falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end Mixed;