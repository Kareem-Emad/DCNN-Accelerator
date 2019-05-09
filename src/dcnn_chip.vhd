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
    
    -- Filter Window controls
    signal filter_window_ready, filter_window_reset : std_logic;
    signal filter_window_data : std_logic_vector(N-1 downto 0);
    
    -- Computation Programming
    signal comp_unit_ready, comp_unit_operation, comp_unit_relu : std_logic;
    signal comp_unit_flt_size, comp_unit_finished : std_logic;
    signal comp_unit_buffer_finished : std_logic;
    signal comp_unit_bias1, comp_unit_bias2 : std_logic_vector(N-1 downto 0);
    signal comp_unit_result1 : std_logic_vector(N-1 downto 0);
    signal comp_unit_result2 : std_logic_vector(N-1 downto 0);
    
    -- Argmax Programming
    signal argmax_ready : std_logic;
    signal argmax_data_outof_controller : std_logic_vector(N-1 downto 0);
    signal argmax_data_into_controller : std_logic_vector(N-1 downto 0);


begin
    -- ram_inst : entity dcnn.Ram
    --     port map (
    --         clk => clk,
    --         read_in => read_mem,
        -- )
    
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
            comp_unit_data1_out => comp_unit_result1,
            comp_unit_data2_out => comp_unit_result2,

            comp_unit_finished => comp_unit_finished,
            comp_unit_data1_in => comp_unit_bias1,
            comp_unit_data2_in => comp_unit_bias2,

            argmax_ready => argmax_ready,
            argmax_data_out => argmax_data_outof_controller,
            argmax_data_in => argmax_data_into_controller
        );

    computation_block_inst : entity dcnn.ComputationBlock
        port map (
            img_data_col_0 => image_wind_col(0),
            img_data_col_1 => image_wind_col(1),
            img_data_col_2 => image_wind_col(2),
            img_data_col_3 => image_wind_col(3),
            img_data_col_4 => image_wind_col(4),
            img_load => image_wind_en,
            img_reset => image_wind_rst,

            filter_data_word => filter_window_data,
            filter_load => filter_window_ready,
            filter_reset => filter_window_reset,

            start => comp_unit_ready,
            operation => comp_unit_operation,
            compute_relu => comp_unit_relu,
            filter_size => comp_unit_flt_size,
            output1_init => comp_unit_bias1,
            output2_init => comp_unit_bias2,
            output1 => comp_unit_result1,
            output2 => comp_unit_result2,
            buffer_ready => comp_unit_buffer_finished,
            ready => comp_unit_finished,

            clk => clk,
            en => '1',
            reset => reset
        );
end Structural;