library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity Controller is
    generic (
        N : natural := 16;  -- precision of the data
        M : natural := 16;  -- size of the address bus

        --Fetch to cache
        filter_reg_size: natural := 3; --max size is 5x5 so 3 bits
        img_h_reg_size: natural := 5   --max image height is 28
    );
    port (
        clk             :   in  std_logic;
        io_ready_in     :   in  std_logic;
        io_done_out     :   out std_logic;
        mem_data_in     :   in  std_logic_vector(N - 1 downto 0);
        mem_data_out    :   out std_logic_vector(N - 1 downto 0);
        mem_addr_out    :   out std_logic_vector(M - 1 downto 0);
        mem_write_out   :   out std_logic;
        mem_read_out    :   out std_logic;
        filter_data_out :   out std_logic_vector(N-1 downto 0)
    );
end Controller;

architecture Mixed of Controller is
    type state_type is (
        init_filter_window,
        init_image_cache,
        start_convolution,
        fetch_to_cache,
        fetch_to_image_window,
        write_to_memory,
        argmax_computation,
        write_classification,
        end_state
    );
    signal current_state : state_type := init_filter_window;
    signal next_state : state_type := init_image_cache;
    

    --needed registers
    signal filter_size : std_logic_vector(filter_reg_size downto 0); --out of reg
    signal img_height  : std_logic_vector(img_h_reg_size downto 0);
    signal img_width : std_logic_vector()
    


    --counters
    signal inserted_rows_o  : std_logic_vector(img_h_reg_size downto 0);
    signal inserted_rows_i  : std_logic_vector(img_h_reg_size downto 0);

    signal inserted_col_o  : std_logic_vector(img_h_reg_size downto 0);
    signal inserted_col_i  : std_logic_vector(img_h_reg_size downto 0);


    signal current_pixel_add_o: std_logic_vector(M downto 0);
    signal current_pixel_add_i: std_logic_vector(M downto 0);


    --control word   MUST LATCH ON A DIFFERENT EDGE THAN OTHER COUNTERS AND WHOLE SYSTEM FOR SIGNALS TO TAKE EFFECT
    signal update_cw: std_logic; -- if cw is to change during processing

        --in (take care of order so we can & easily when reading out or setting in)
        signal edged_i: std_logic; -- to set edged bit in control word
        signal update_rows_counter_i: std_logic; --to update current rows register
        signal shift_into_cache_i:std_logic; --to shift a memory values in cache
      
        --out
        signal edged_o: std_logic; -- to read edged bit from control word
        signal update_rows_counter_o: std_logic; --to read bit value
        signal shift_into_cache_o:std_logic; --to read bit value if needed
begin
    -- This process computes the next state given the current state and the inputs.
    comp_ns : process(current_state)
    begin
        case current_state is
            when init_filter_window =>
            
            when init_image_cache =>

            when start_convolution =>

            when fetch_to_cache =>
                if ((filter_size=std_logic_vector(to_signed(3, filter_reg_size)))
                    and (inserted_rows=img_height)) or edged='1' then
                        update_cw<='1'; --will change CW
                        cache_input<=(others=>'0'); --insert 0
                        shift_into_cache<='1';
                        if edged_o='0' then
                            edged_i<='1'; --set edged bit
                            update_rows_counter_i<='1';
                            inserted_rows_i<= inserted_rows_o -2; --decrease row count by 2 to shift zero rows
                        end if;
                else
                    
                    current_pixel_add_i<=current_pixel_add_o+1; -- will update value in next cycle
                    mem_addr<=current_pixel_add_o+1; --should access with current o +1
                    mem_read<='1';
                    cache_input<=meme_data_out;
                end if;

                if inserted_col_o=













            when fetch_to_image_window =>

            when write_to_memory =>

            when argmax_computation =>

            when write_classification =>

            when end_state =>
                next_state <= current_state;
            end case;
    end process;

    
    -- This process syncs the current state and the next state.
    -- Currently this operates on the falling edge of the clock, in-sync with the memory. Could change.
    sync_state : process(clk)
    begin
        if falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
end Mixed;