restart -f

delete wave /dcnnchiptb/*
add wave -position insertpoint  \
sim:/dcnnchiptb/clk \
sim:/dcnnchiptb/reset \
sim:/dcnnchiptb/read_mem \
sim:/dcnnchiptb/write_mem \
sim:/dcnnchiptb/address \
sim:/dcnnchiptb/data_into_mem \
sim:/dcnnchiptb/data_outof_mem \
sim:/dcnnchiptb/dcnn_chip_inst/controller_result_1 \
sim:/dcnnchiptb/dcnn_chip_inst/controller_result_2 \
sim:/dcnnchiptb/dcnn_chip_inst/controller_bias_1 \
sim:/dcnnchiptb/dcnn_chip_inst/controller_bias_2 \
sim:/dcnnchiptb/dcnn_chip_inst/comp_unit_finished \
sim:/dcnnchiptb/dcnn_chip_inst/comp_unit_ready \
sim:/dcnnchiptb/dcnn_chip_inst/comp_unit_operation \
sim:/dcnnchiptb/dcnn_chip_inst/comp_unit_relu \
sim:/dcnnchiptb/dcnn_chip_inst/comp_unit_flt_size \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/current_state \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/next_state \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/nlayers_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/layer_type_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/nflt_layer_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/flt_size_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/new_width_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/new_size_squared_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/layer_mem_size_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/num_channels_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/img_width_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/img_height_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/channel_zero_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/flt_bias_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/write_base_data_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/write_offset_data_out \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/img_base_addr \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/img_addr_offset \
sim:/dcnnchiptb/dcnn_chip_inst/controller_inst/img_cache/que_out \
sim:/dcnnchiptb/dcnn_chip_inst/computation_block_inst/gen_img_window/q \
sim:/dcnnchiptb/dcnn_chip_inst/image_wind_col \
sim:/dcnnchiptb/dcnn_chip_inst/image_wind_col_flipped \
sim:/dcnnchiptb/dcnn_chip_inst/computation_block_inst/filter_data