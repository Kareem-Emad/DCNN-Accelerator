library ieee;
library dcnn;
use dcnn.config.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ComputationBlockTest is
end ComputationBlockTest;

architecture Test of ComputationBlockTest is
    constant period : time := 100 ps;
    constant initial_value : wordarr_t(0 to 24) := (
        std_logic_vector(to_signed(0, n_word)),
        std_logic_vector(to_signed(1, n_word)),
        std_logic_vector(to_signed(2, n_word)),
        std_logic_vector(to_signed(3, n_word)),
        std_logic_vector(to_signed(4, n_word)),
        std_logic_vector(to_signed(5, n_word)),
        std_logic_vector(to_signed(6, n_word)),
        std_logic_vector(to_signed(7, n_word)),
        std_logic_vector(to_signed(8, n_word)),
        std_logic_vector(to_signed(9, n_word)),
        std_logic_vector(to_signed(10, n_word)),
        std_logic_vector(to_signed(11, n_word)),
        std_logic_vector(to_signed(12, n_word)),
        std_logic_vector(to_signed(13, n_word)),
        std_logic_vector(to_signed(14, n_word)),
        std_logic_vector(to_signed(15, n_word)),
        std_logic_vector(to_signed(16, n_word)),
        std_logic_vector(to_signed(17, n_word)),
        std_logic_vector(to_signed(18, n_word)),
        std_logic_vector(to_signed(19, n_word)),
        std_logic_vector(to_signed(20, n_word)),
        std_logic_vector(to_signed(21, n_word)),
        std_logic_vector(to_signed(22, n_word)),
        std_logic_vector(to_signed(23, n_word)),
        std_logic_vector(to_signed(24, n_word))
    );
    constant initial_value2 : wordarr_t(0 to 24) := (
        std_logic_vector(to_signed(0, n_word)),
        std_logic_vector(to_signed(1, n_word)),
        std_logic_vector(to_signed(2, n_word)),
        std_logic_vector(to_signed(3, n_word)),
        std_logic_vector(to_signed(4, n_word)),
        std_logic_vector(to_signed(-5, n_word)),
        std_logic_vector(to_signed(-6, n_word)),
        std_logic_vector(to_signed(7, n_word)),
        std_logic_vector(to_signed(-8, n_word)),
        std_logic_vector(to_signed(9, n_word)),
        std_logic_vector(to_signed(10, n_word)),
        std_logic_vector(to_signed(11, n_word)),
        std_logic_vector(to_signed(-12, n_word)),
        std_logic_vector(to_signed(-13, n_word)),
        std_logic_vector(to_signed(14, n_word)),
        std_logic_vector(to_signed(15, n_word)),
        std_logic_vector(to_signed(16, n_word)),
        std_logic_vector(to_signed(17, n_word)),
        std_logic_vector(to_signed(18, n_word)),
        std_logic_vector(to_signed(19, n_word)),
        std_logic_vector(to_signed(20, n_word)),
        std_logic_vector(to_signed(21, n_word)),
        std_logic_vector(to_signed(22, n_word)),
        std_logic_vector(to_signed(23, n_word)),
        std_logic_vector(to_signed(24, n_word))
    );

    signal img_data : wordarr_t(0 to 24) := initial_value;
    signal filter_data : wordarr_t(0 to 24) := initial_value2;  
    signal output1_init : word_t := std_logic_vector(to_signed(25, n_word));
    signal output2_init : word_t := std_logic_vector(to_signed(30, n_word));
    signal filter_size : filtersize_t := filter5x5;
    signal operation : operation_t := convolution;
    signal compute_relu : std_logic := '1';
    signal d_arr : wordarr_t(0 to 24);
    signal q_arr : wordarr_t(0 to 24);
    
    signal en : std_logic := '1';
    signal reset : std_logic := '1';
    signal done : std_logic;
    signal clk : std_logic;
begin
    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            q_arr <= d_arr;
        end if;
    end process;

    process
    begin
        filter_size <= filter5x5;
        operation <= convolution;
        en <= '1';
        reset <= '1';
        wait for period;
        reset <= '0';
        output1_init <= std_logic_vector(to_signed(25, n_word));
        output2_init <= std_logic_vector(to_signed(20, n_word));

        wait for period * 15;
        assert q_arr(0) = std_logic_vector(to_signed(4024 + 25, n_word));

        filter_size <= filter3x3;
        reset <= '1';
        wait for period;
        reset <= '0';
        wait for period * 14;
        assert q_arr(0) = std_logic_vector(to_signed(-70 + 25, n_word));
        assert q_arr(1) = std_logic_vector(to_signed(-72 + 20, n_word));
        wait for period;
        assert q_arr(0) = std_logic_vector(to_signed(0, n_word));
        assert q_arr(1) = std_logic_vector(to_signed(0, n_word));
        
        operation <= pooling;
        filter_size <= filter5x5;
        reset <= '1';
        wait for period;
        reset <= '0';
        wait for period * 7;
        assert q_arr(0) = std_logic_vector(to_signed(300 / 32 + 25, n_word));

        filter_size <= filter3x3;
        reset <= '1';
        wait for period;
        reset <= '0';
        wait for period * 7;
        assert q_arr(0) = std_logic_vector(to_signed(54 / 8 + 25, n_word));
        assert q_arr(1) = std_logic_vector(to_signed(63 / 8 + 20, n_word));
    end process;

    gen_comp_pipeline: entity dcnn.ComputationPipeline
        port map(
            img_data,
            filter_data,
            d_arr,
            q_arr,
            output1_init,
            output2_init,
            filter_size,
            operation,
            compute_relu,
            clk,
            en,
            reset,
            done
        );
end Test;