library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity ComputationBlock is
    port(
        img_data_col : in wordarr_t(0 to 4) := (others => (others => '0'));
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
    
    signal buffer_ready_tmp : std_logic;
    signal ready_tmp : std_logic;
    signal buffer_ready_tmp2 : std_logic;
    signal ready_tmp2 : std_logic;
    signal img_load_tmp : std_logic;
    signal filter_load_tmp : std_logic;
    signal start_tmp : std_logic;

    signal comp_pipe_rst : std_logic;
    signal comp_pipe_en : std_logic;

    -- options
    signal output1_init_q : word_t;
    signal output2_init_q : word_t;
    signal filter_size_q : filtersize_t;
    signal operation_q : operation_t;
    signal compute_relu_q : std_logic;

    signal sync_flag : std_logic;
begin
    ready <= ready_tmp and ready_tmp2;
    buffer_ready <= buffer_ready_tmp and buffer_ready_tmp2;
    img_load_tmp <= img_load and buffer_ready_tmp;
    filter_load_tmp <= filter_load and buffer_ready_tmp;
    start_tmp <= start and ready_tmp;
    -- comp cache
    comp_cache_ld <= not(ready_tmp);
    comp_cache_rst <= reset; 
    -- outputs
    output1 <= q_cache_arr(0);
    output2 <= q_cache_arr(1);
    
    process(start_tmp, clk, reset)
    begin
        if reset = '1' then
            output1_init_q <= (others => '0');
            output2_init_q <= (others => '0');
            filter_size_q <= filter5x5;
            operation_q <= convolution;
            compute_relu_q <= '1';
            comp_pipe_rst <= '1';
            comp_pipe_en <= '0';
            sync_flag <= '0';
        else
            if rising_edge(start_tmp) and en = '1' then
                output1_init_q <= output1_init;
                output2_init_q <= output2_init;
                filter_size_q <= filter_size;
                operation_q <= operation;
                compute_relu_q <= compute_relu;
                ready_tmp2 <= '0';
                buffer_ready_tmp2 <= '0';
                comp_pipe_rst <= '1';
                comp_pipe_en <= '0';
                sync_flag <= '0';
            end if;
            if falling_edge(clk) then
                if sync_flag = '0' then
                    sync_flag <= '1';
                else
                    comp_pipe_rst <= '0';
                    comp_pipe_en <= '1';
                    ready_tmp2 <= '1';
                    buffer_ready_tmp2 <= '1';
                end if;
            end if;
        end if;
    end process;

    gen_img_window : entity dcnn.ImageWindow
        port map(
            d => img_data_col,
            q => img_data,
            clk => clk,
            load => img_load_tmp,
            reset => img_reset
        );
    gen_filter_window : entity dcnn.FilterWindow
        port map(
            d => filter_data_word,
            q => filter_data,
            clk => clk,
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
            ready => ready_tmp
        );
end Structural;
