library ieee;
library dcnn;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;
use dcnn.config.all;

entity DCNNChip is 
    generic ( 
        N : natural := 16;
        M : natural := 16;
        WREG : natural := 5;
        HREG : natural := 16
    );
    port (
        clk : in std_logic;
        reset : in std_logic;

        io_ready_in     : in std_logic;
        io_done_out     : out std_logic;

        mem_read_out    : out std_logic;
        mem_write_out   : out std_logic;
        mem_addr_out    : out std_logic_vector(M-1 downto 0);
        mem_data_in     : in std_logic_vector(N-1 downto 0);
        mem_data_out    : out std_logic_vector(N-1 downto 0)
    );
end DCNNChip;

architecture Structural of DCNNChip is
    -- Image Window Controls
    signal image_wind_en, image_wind_rst : std_logic;
    signal image_wind_col : wordarr_t(4 downto 0);
    signal image_wind_col_flipped : wordarr_t(0 to 4);
    
    -- Filter Window controls
    signal filter_window_ready, filter_window_reset : std_logic;
    signal filter_window_data : std_logic_vector(N-1 downto 0);
    
    -- Computation Programming
    signal comp_unit_ready, comp_unit_operation, comp_unit_relu : std_logic;
    signal comp_unit_flt_size, comp_unit_finished : std_logic;
    signal comp_unit_buffer_finished : std_logic;
    signal comp_unit_bias_1, comp_unit_bias_2 : std_logic_vector(N-1 downto 0);
    signal comp_unit_result_1, comp_unit_result_2 : std_logic_vector(N-1 downto 0);

    signal controller_bias_1, controller_bias_2 : std_logic_vector(N-1 downto 0);
    signal controller_result_1, controller_result_2 : std_logic_vector(N-1 downto 0);
    
    -- Argmax Programming
    signal argmax_ready : std_logic;
    signal argmax_data_outof_controller : std_logic_vector(N-1 downto 0);
    signal argmax_data_out : std_logic_vector(3 downto 0);
    signal argmax_data_into_controller : std_logic_vector(N-1 downto 0);

    signal flt_size_out : std_logic_vector(0 downto 0);

begin
    comp_unit_bias_1 <= controller_bias_2 when flt_size_out(0) = filter3x3 or comp_unit_flt_size = filter3x3 else controller_bias_1;
    comp_unit_bias_2 <= controller_bias_1 when flt_size_out(0) = filter3x3 or comp_unit_flt_size = filter3x3 else controller_bias_2;

    controller_result_1 <= comp_unit_result_2 when flt_size_out(0) = filter3x3 else comp_unit_result_1;
    controller_result_2 <= comp_unit_result_1 when flt_size_out(0) = filter3x3 else comp_unit_result_2;

    argmax_data_into_controller <= (15 downto 4 => '0') & argmax_data_out;

    flt_size_reg : entity dcnn.Reg
    generic map (N => 1)
    port map (
        clk => clk, reset => reset, load => comp_unit_ready,
        d(0) => comp_unit_flt_size, q => flt_size_out, rst_data => "0"
    );

    flip_image_wind : process(image_wind_col)
    begin
        for i in 0 to 4 loop
            image_wind_col_flipped(i) <= image_wind_col(i);
        end loop;
    end process;
    
    controller_inst : entity dcnn.Controller
        port map (
            clk => clk,
            reset => reset,

            io_ready_in => io_ready_in,
            io_done_out => io_done_out,

            mem_data_in => mem_data_in,
            mem_data_out => mem_data_out,
            mem_addr_out => mem_addr_out,
            mem_write_out => mem_write_out,
            mem_read_out => mem_read_out,

            wind_en => image_wind_en,
            wind_rst => image_wind_rst,
            wind_col_in => image_wind_col,

            filter_data_out => filter_window_data,
            filter_ready_out => filter_window_ready,
            filter_reset => filter_window_reset,

            comp_unit_ready => comp_unit_ready,
            comp_unit_operation => comp_unit_operation,
            comp_unit_relu => comp_unit_relu,
            comp_unit_flt_size => comp_unit_flt_size,
            comp_unit_data1_out => controller_bias_1,
            comp_unit_data2_out => controller_bias_2,

            comp_unit_buffer_finished => comp_unit_buffer_finished,
            comp_unit_finished => comp_unit_finished,
            comp_unit_data1_in => controller_result_1,
            comp_unit_data2_in => controller_result_2,

            argmax_ready => argmax_ready,
            argmax_data_out => argmax_data_outof_controller,
            argmax_data_in => argmax_data_into_controller
        );

    computation_block_inst : entity dcnn.ComputationBlock
        port map (
            img_data_col_0 => image_wind_col_flipped(0),
            img_data_col_1 => image_wind_col_flipped(1),
            img_data_col_2 => image_wind_col_flipped(2),
            img_data_col_3 => image_wind_col_flipped(3),
            img_data_col_4 => image_wind_col_flipped(4),
            img_load => image_wind_en,
            img_reset => image_wind_rst,

            filter_data_word => filter_window_data,
            filter_load => filter_window_ready,
            filter_reset => filter_window_reset,

            start => comp_unit_ready,
            operation => comp_unit_operation,
            compute_relu => comp_unit_relu,
            filter_size => comp_unit_flt_size,
            output1_init => comp_unit_bias_1,
            output2_init => comp_unit_bias_2,
            output1 => comp_unit_result_1,
            output2 => comp_unit_result_2,
            buffer_ready => comp_unit_buffer_finished,
            ready => comp_unit_finished,

            clk => clk,
            en => '1',
            reset => reset
        );
    
    argmax_inst : entity dcnn.ArgMax
            port map (
                inp => argmax_data_outof_controller,
                en => argmax_ready,
                clk => clk,
                rst => reset,
                ans => argmax_data_out
            );
    
end Structural;