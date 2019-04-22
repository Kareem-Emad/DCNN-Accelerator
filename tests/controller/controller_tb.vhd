library ieee, modelsim_lib;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use modelsim_lib.util.all;
library dcnn;

entity ControllerTB is
end ControllerTB;

architecture TB of ControllerTB is
    signal clk, reset, read_mem, write_mem : std_logic := '0';
    signal address : std_logic_vector(15 downto 0) := (others => 'Z');
    signal data_into_mem, data_outof_mem : std_logic_vector(15 downto 0) := (others => 'Z');
    signal filter_data : std_logic_vector(15 downto 0) := (others => 'Z');
    signal io_ready : std_logic := '1';
    signal io_done : std_logic;
    signal nlayers_out : std_logic_vector(2 downto 0);
    signal layer_type_out : std_logic_vector(1 downto 0);
    signal nflt_layer_out : std_logic_vector(3 downto 0);
    signal flt_size_out : std_logic_vector(2 downto 0);
    signal new_width_out : std_logic_vector(4 downto 0);
    signal new_size_squared_out : std_logic_vector(15 downto 0);
    signal layer_mem_size_out : std_logic_vector(15 downto 0);
    signal num_channels_out : std_logic_vector(2 downto 0);
    signal cntr1_data : std_logic_vector(5 downto 0);
    signal img_width_out : std_logic_vector(4 downto 0);

    constant period : time := 1 ns;
begin
    ram_inst : entity dcnn.Ram
        port map (
            clk => clk,
            read_in => read_mem,
            write_in => write_mem,
            address_in => address,
            data_in => data_into_mem,
            data_out => data_outof_mem
        );

    controller_inst : entity dcnn.Controller
        port map (
            clk => clk,
            reset => reset,
            io_ready_in => io_ready,
            io_done_out => io_done,
            mem_data_in => data_outof_mem,
            mem_data_out => data_into_mem,
            mem_addr_out => address,
            mem_read_out => read_mem,
            mem_write_out => write_mem,
            filter_data_out => filter_data
        );
-- 2: Initialize memory values (maybe in the simulator?)
-- 3: Test the initialization of the filter window.

    process is
        variable iter_v : std_logic_vector(15 downto 0);
        variable finished_iter : std_logic;
    begin
        -- A signal spy mirrors the value in the signal at src (1st arg) to the signal at dst (2nd arg).
        -- This is done in order to access signals in component instances.
        init_signal_spy("/controllertb/controller_inst/nlayers_out", "/controllertb/nlayers_out");
        init_signal_spy("/controllertb/controller_inst/layer_type_out", "/controllertb/layer_type_out");
        init_signal_spy("/controllertb/controller_inst/nflt_layer_out", "/controllertb/nflt_layer_out");
        init_signal_spy("/controllertb/controller_inst/flt_size_out", "/controllertb/flt_size_out");
        init_signal_spy("/controllertb/controller_inst/new_width_out", "/controllertb/new_width_out");
        init_signal_spy("/controllertb/controller_inst/new_size_squared_out", "/controllertb/new_size_squared_out");
        init_signal_spy("/controllertb/controller_inst/layer_mem_size_out", "/controllertb/layer_mem_size_out");
        init_signal_spy("/controllertb/controller_inst/num_channels_out", "/controllertb/num_channels_out");
        init_signal_spy("/controllertb/controller_inst/cntr1_data", "/controllertb/cntr1_data");
        init_signal_spy("/controllertb/controller_inst/img_width_out", "/controllertb/img_width_out");
        reset <= '1';
        wait for period;
        reset <= '0';
        assert(img_width_out = "11100") report "Initial image width is incorrect!";
        wait for period;
        assert(nlayers_out = "001") report "Fetching number of layers failed!";
        wait for period;
        assert(layer_type_out = "00") report "Fetching layer type failed!";
        wait for period;
        assert(nflt_layer_out = "0010") report "Fetching number of filters failed!";
        wait for period;
        assert(flt_size_out = "011") report "Fetching filter size failed!";
        wait for period;
        assert(new_width_out = "11010") report "Fetching new width failed!";
        wait for period;
        assert(new_size_squared_out = X"02A4") report "Fetching new squared size failed!";
        wait for period;
        assert(layer_mem_size_out = X"0548") report "Fetching layer memory size failed!";
        wait for period; -- we incur a one state delay before initializing the filter window. 
        -- if FC assert(num_channels_out = X"0005") report "Fetching number of channels failed!";
        for iter in 1 to 9 loop
            iter_v := std_logic_vector(to_unsigned(iter, 16));
            assert(filter_data = iter_v) report "Fetching filter failed! iter " & integer'image(to_integer(unsigned(iter_v))) & " filter_data = " & integer'image(to_integer(unsigned(filter_data)));
            wait for period;
        end loop;
        wait for period;
        -- TO-DO: test initialize cache!
    end process;

    process is
    begin
        clk <= '0';
        wait for period / 2;
        clk <= '1';
        wait for period / 2;
    end process;
end TB;