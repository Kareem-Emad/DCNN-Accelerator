library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity ComputationBlock is
    port(
        img_data_col_0 : in word_t;
        img_data_col_1 : in word_t;
        img_data_col_2 : in word_t;
        img_data_col_3 : in word_t;
        img_data_col_4 : in word_t;
        
        img_load : in std_logic := '0';
        img_reset : in std_logic := '0';
        filter_data_word : in word_t := (others => '0');  
        filter_load : in std_logic := '0';
        filter_reset : in std_logic := '0';
        output1_init : in word_t := (others => '0');
        output2_init : in word_t := (others => '0');
        filter_size : in filtersize_t := filter5x5;
        operation : in operation_t := convolution;
        compute_relu : in std_logic := '1';
        start : in std_logic := '0';
        buffer_ready : out std_logic := '0';
        ready : out std_logic := '0';
        output1 : out word_t := (others => '0');
        output2 : out word_t := (others => '0');
        clk : in std_logic := '0';
        en : in std_logic := '0';
        reset : in std_logic := '0'
    );
end ComputationBlock;

architecture Structural of ComputationBlock is          
    signal img_data : wordarr_t(0 to 24);
    signal filter_data : wordarr_t(0 to 24);
    signal d_cache_arr : wordarr_t(0 to 24) := (others => (others => '0'));
    signal q_cache_arr : wordarr_t(0 to 24) := (others => (others => '0'));
    signal comp_cache_ld : std_logic := '1';
    signal comp_cache_rst : std_logic := '0';
    
    signal img_load_tmp : std_logic;
    signal filter_load_tmp : std_logic;
    signal start_tmp : std_logic;
    signal ready_tmp : std_logic;
    signal buffer_ready_tmp : std_logic;

    signal comp_pipe_rst : std_logic;
    signal comp_pipe_en : std_logic;

    -- options
    signal output1_init_q : word_t;
    signal output2_init_q : word_t;
    signal filter_size_q : filtersize_t;
    signal operation_q : operation_t;
    signal compute_relu_q : std_logic;
    signal buffer_ready_q : std_logic;
    signal ready_q : std_logic;

    signal output1_q : word_t;
    signal output2_q : word_t;
    signal semi_ready : std_logic;
    signal img_data_col : wordarr_t(0 to 4);
    signal not_clk : std_logic;
begin
    not_clk <= not(clk);
    img_data_col(4) <= img_data_col_4;
    img_data_col(3) <= img_data_col_3;
    img_data_col(2) <= img_data_col_2;
    img_data_col(1) <= img_data_col_1;
    img_data_col(0) <= img_data_col_0;
    buffer_ready <= buffer_ready_q;

    ready <= ready_q;
    img_load_tmp <= img_load and buffer_ready_q;
    filter_load_tmp <= filter_load and buffer_ready_q;
    start_tmp <= start and ready_q;
    -- comp cache
    comp_cache_ld <= not(semi_ready);
    comp_cache_rst <= reset;
    -- outputs
    output1 <= output1_q;
    output2 <= output2_q;

    process(clk, semi_ready, reset)
    begin
        if reset = '1' then
            output1_q <= (others => '0');
            output2_q <= (others => '0');
        elsif rising_edge(clk) then
            if semi_ready = '1' then
                output1_q <= q_cache_arr(0);
                output2_q <= q_cache_arr(1);
            end if;
        end if;
    end process;
    
    process(clk, reset, ready_tmp)
    begin
        if reset = '1' then
            output1_init_q <= (others => '0');
            output2_init_q <= (others => '0');
            filter_size_q <= filter5x5;
            operation_q <= convolution;
            compute_relu_q <= '1';
            comp_pipe_rst <= '1';
            comp_pipe_en <= '0';
            ready_q <= '1';
            buffer_ready_q <= '1';        
        else
            if falling_edge(clk) then
                if en = '1' and start_tmp = '1' then
                    output1_init_q <= output1_init;
                    output2_init_q <= output2_init;
                    filter_size_q <= filter_size;
                    operation_q <= operation;
                    compute_relu_q <= compute_relu;
                    comp_pipe_rst <= '0';
                    comp_pipe_en <= '1';
                    ready_q <= '0';
                    buffer_ready_q <= '0';
                else 
                    ready_q <= ready_tmp or ready_q;
                    buffer_ready_q <= buffer_ready_tmp or buffer_ready_q;
                    comp_pipe_rst <= ready_tmp;
                    comp_pipe_en <= not(ready_tmp);
                end if;
            end if;
        end if;
    end process;

    gen_img_window : entity dcnn.ImageWindow
        port map(
            d => img_data_col,
            q => img_data,
            clk => not_clk,
            load => img_load_tmp,
            reset => img_reset
        );
    gen_filter_window : entity dcnn.FilterWindow
        port map(
            d => filter_data_word,
            q => filter_data,
            clk => not_clk,
            load => filter_load_tmp,
            reset => filter_reset
        );
    gen_comp_cache : entity dcnn.ComputationCache
        port map(
            d => d_cache_arr,
            q => q_cache_arr,
            clk => clk,
            load => comp_cache_ld,
            reset => comp_cache_rst
        );
    gen_comp_pipeline : entity dcnn.ComputationPipeline
        port map(
            img_data => img_data,
            filter_data => filter_data,
            d_arr => d_cache_arr,
            q_arr => q_cache_arr,
            output1_init => output1_init_q,
            output2_init => output2_init_q,
            filter_size => filter_size_q,
            operation => operation_q,
            compute_relu => compute_relu_q,
            clk => clk,
            en => comp_pipe_en,
            reset => comp_pipe_rst,
            buffer_ready => buffer_ready_tmp,
            ready => ready_tmp,
            semi_ready => semi_ready
        );
end Structural;
