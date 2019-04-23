library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity ComputationPipeline is
    port(
        img_data : in wordarr_t(0 to 24) := (others => (others => '0'));
        filter_data : in wordarr_t(0 to 24) := (others => (others => '0'));
        d_arr : out wordarr_t(0 to 24) := (others => (others => '0'));
        q_arr : in wordarr_t(0 to 24) := (others => (others => '0'));
        output1_init : in word_t := (others => '0');
        output2_init : in word_t := (others => '0');
        filter_size : in filtersize_t := filter5x5;
        operation : in operation_t := convolution;
        compute_relu : in std_logic := '1';
        clk : in std_logic := '0';
        en : in std_logic := '0';
        reset : in std_logic := '0';
        buffer_ready : out std_logic := '0';
        ready : out std_logic
    );
end ComputationPipeline;

architecture Behavioral of ComputationPipeline is
    constant state_mux : natural := 0;
    constant state_mul_l : natural := 1;
    constant state_mul_h : natural := 8;
    constant state_add_l : natural := 9;
    constant state_add_h : natural := 12;
    constant state_merge1 : natural := 13;
    constant state_merge2 : natural := 14;
    constant state_relu : natural := 15;
    constant n_states : natural := 16;

    signal counter : unsigned(n_states-1 downto 0);
    signal ordered_filter_data : wordarr_t(0 to 24);
    signal ordered_img_data : wordarr_t(0 to 24);
    signal d_arr_mux : wordarr_t(0 to 24);
    signal d_arr_mul : wordarr_t(0 to 24);
    signal d_arr_add : wordarr_t(0 to 24);
    signal d_arr_merge1 : wordarr_t(0 to 24);
    signal d_arr_merge2 : wordarr_t(0 to 24);
    signal d_arr_relu : wordarr_t(0 to 24);
    signal sel_mux : std_logic;
    signal sel_mul : std_logic;
    signal sel_add : std_logic;
    signal sel_merge1 : std_logic;
    signal sel_merge2 : std_logic;
    signal sel_relu : std_logic;
begin
    process(clk, en, reset)
    begin
        if reset = '1' then
            counter <= to_unsigned(1, n_states);
        else
            if falling_edge(clk) and en = '1' then
                if counter(state_mux) = '1' and operation = pooling then
                    counter <= (state_add_l => '1', others => '0');
                elsif counter(state_merge2) = '1' and compute_relu = '0' then
                    counter <= to_unsigned(0, n_states);
                else
                    counter <= shift_left(counter, 1);
                end if;
            end if;
        end if;
    end process;
    
    sel_mux <= counter(0);
    sel_mul <= counter(1) or counter(2) or counter(3) or
                counter(4) or counter(5) or counter(6) or
                counter(7) or counter(8);
    sel_add <= counter(9) or counter(10) or counter(11) or
                counter(12);
    sel_merge1 <= counter(13);
    sel_merge2 <= counter(14);
    sel_relu <= counter(15);
    buffer_ready <= not(sel_mux) and not(sel_mul);
    ready <= '1' when counter = to_unsigned(0, n_states) else '0';
    
    cache_muxer_gen : entity dcnn.CacheMuxer 
        port map(
            d_arr_mux => d_arr_mux,
            d_arr_mul => d_arr_mul,
            d_arr_add => d_arr_add,
            d_arr_merge1 => d_arr_merge1,
            d_arr_merge2 => d_arr_merge2,
            d_arr_relu => d_arr_relu,
            sel_mux => sel_mux,
            sel_mul => sel_mul,
            sel_add => sel_add,
            sel_merge1 => sel_merge1,
            sel_merge2 => sel_merge2,
            sel_relu => sel_relu,
            d_arr => d_arr
        );

    mux_layer_gen : entity dcnn.MuxLayer
        port map(
            img_data => img_data,
            filter_data => filter_data,
            filter_size => filter_size,
            ordered_img_data => ordered_img_data,
            ordered_filter_data => ordered_filter_data
        );
    d_arr_mux <= ordered_img_data;
    
    mul_layer_gen : entity dcnn.MultiplicationLayer
        port map(
            img_data => ordered_img_data,
            filter_data => ordered_filter_data,
            d_arr => d_arr_mul,
            clk => clk,
            en => sel_mul
        );

    add_layer_gen : entity dcnn.AdditionLayer
        port map(
            d_arr => d_arr_add,
            q_arr => q_arr
        );
    
    merge_layer1_gen : entity dcnn.MergeLayer
        port map(
            d_arr => d_arr_merge1,
            q_arr => q_arr,
            operation => operation,
            filter_size => filter_size
        );

    merge_layer2_gen : entity dcnn.MergeLayer2
        port map(
            d_arr => d_arr_merge2,
            q_arr => q_arr,
            output1_init => output1_init,
            output2_init => output2_init
        );

    relu_layer_gen : entity dcnn.ReluLayer
        port map(
            d_arr => d_arr_relu,
            q_arr => q_arr
        );
end Behavioral;
