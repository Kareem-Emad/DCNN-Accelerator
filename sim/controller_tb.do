restart -f
delete wave /controllertb/*
add wave -position insertpoint  \
sim:/controllertb/clk \
sim:/controllertb/reset \
sim:/controllertb/read_mem \
sim:/controllertb/write_mem \
sim:/controllertb/address \
sim:/controllertb/data_into_mem \
sim:/controllertb/data_outof_mem \
sim:/controllertb/controller_inst/current_state \
sim:/controllertb/controller_inst/next_state \
sim:/controllertb/filter_data \
sim:/controllertb/filter_ready \
sim:/controllertb/nlayers_out \
sim:/controllertb/layer_type_out \
sim:/controllertb/nflt_layer_out \
sim:/controllertb/flt_size_out \
sim:/controllertb/new_width_out \
sim:/controllertb/new_size_squared_out \
sim:/controllertb/layer_mem_size_out \
sim:/controllertb/num_channels_out \
sim:/controllertb/cntr1_data \
sim:/controllertb/img_width_out \
sim:/controllertb/comp_unit_ready \
sim:/controllertb/comp_unit_data1_in \
sim:/controllertb/comp_unit_data2_in \
sim:/controllertb/comp_unit_data1_out \
sim:/controllertb/comp_unit_data2_out \
sim:/controllertb/window_enable \
sim:/controllertb/window_rst \
sim:/controllertb/window_data_in \
sim:/controllertb/q_arr \
sim:/controllertb/controller_inst/flt_bias_out \
sim:/controllertb/controller_inst/addr1_enable \
sim:/controllertb/controller_inst/addr1_data \
sim:/controllertb/controller_inst/cntr1_reset \
sim:/controllertb/controller_inst/cntr1_enable \
sim:/controllertb/controller_inst/cntr1_mode \
sim:/controllertb/controller_inst/cntr1_max_val \
sim:/controllertb/controller_inst/cntr1_max_reached \
sim:/controllertb/controller_inst/cntr1_data \
sim:/controllertb/controller_inst/img_cache/out_column \
sim:/controllertb/controller_inst/cache_height_count \
sim:/controllertb/controller_inst/cache_width_count \
sim:/controllertb/controller_inst/img_cache/que_out
mem load -i /mnt/01D35D8F61D34AA0/Projects/VLSI/DCNN-Accelerator/scripts/memory.mem /controllertb/ram_inst/ram
run