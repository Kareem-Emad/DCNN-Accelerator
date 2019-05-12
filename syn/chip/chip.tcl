load_library tsmc035_typ
set_working_dir /mnt/hgfs/DCNN-Accelerator/
set bubble_tristates FALSE
read -technology "tsmc035_typ"  { src/config.vhd }
read -technology "tsmc035_typ"  { src/common/BitAdder.vhd }
read -technology "tsmc035_typ"  { src/common/NAdder.vhd }
read -technology "tsmc035_typ"  { src/common/register.vhd }
read -technology "tsmc035_typ"  { src/common/Reg_16.vhd }
read -technology "tsmc035_typ"  { src/common/Queue_5.vhd }
read -technology "tsmc035_typ"  { src/common/Queue_25.vhd }
read -technology "tsmc035_typ"  { src/buffers/image_window.vhd }
read -technology "tsmc035_typ"  { src/buffers/filter_window.vhd }
read -technology "tsmc035_typ"  { src/buffers/computation_cache.vhd }
read -technology "tsmc035_typ"  { src/computation_block/multipliers/modified_booth_multiplier.vhd }
read -technology "tsmc035_typ"  { src/computation_block/multipliers/multiplier.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/mux_layer/mux_layer.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/multiplication_layer/multiplication_layer.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/addition_layer/op7_router.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/addition_layer/op9_router.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/addition_layer/op9_tree.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/addition_layer/op7_tree.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/addition_layer/addition_layer.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/merge_layer/merge_layer.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/merge_layer/merge_layer2.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/relu_layer/relu_layer.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/cache_muxer.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_pipeline/computation_pipeline.vhd }
read -technology "tsmc035_typ"  { src/computation_block/computation_block.vhd }
read -technology "tsmc035_typ"  { src/common/Reg_4.vhd }
read -technology "tsmc035_typ"  { src/common/NMUX.vhd }
read -technology "tsmc035_typ"  { src/common/NMUX_4.vhd }
read -technology "tsmc035_typ"  { src/comparator/Comparator.vhd }
read -technology "tsmc035_typ"  { src/common/counter.vhd }
read -technology "tsmc035_typ"  { src/argmax/ArgMax.vhd }
read -technology "tsmc035_typ"  { src/common/constants.vhd }
# read -technology "tsmc035_typ"  { src/common/register.vhd }
read -technology "tsmc035_typ"  { src/common/queue.vhd }
# read -technology "tsmc035_typ"  { src/common/Reg_4.vhd }
# read -technology "tsmc035_typ"  { src/common/Reg_16.vhd }
# read -technology "tsmc035_typ"  { src/common/Queue_5.vhd }
# read -technology "tsmc035_typ"  { src/common/Queue_25.vhd }
read -technology "tsmc035_typ"  { src/common/decoder.vhd }
read -technology "tsmc035_typ"  { src/buffers/cache.vhd }
read -technology "tsmc035_typ"  { src/common/advancedCounter.vhd }
# read -technology "tsmc035_typ"  { src/buffers/image_window.vhd }
read -technology "tsmc035_typ"  { src/controller/controller.vhd }
read -technology "tsmc035_typ"  { src/dcnn_chip.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
# pre_optimize -common_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 
elaborate Controller -architecture Mixed
elaborate DCNNChip -architecture Structural 
# pre_optimize .work.Controller.Mixed -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize .work.DCNNChip.Structural -common_logic -boundary -xor_comparator_optimize 
pre_optimize .work.DCNNChip.Structural -extract 
set entity DCNNChip
set architecture Structural
set register2register 5.00000
set input2register 5.00000
set register2output 5.00000
optimize .work.DCNNChip.Structural -target tsmc035_typ -macro -area -effort standard -hierarchy auto 
optimize_timing .work.DCNNChip.Structural 
report_area syn/chip/area_rep -cell_usage -all_leafs
report_delay syn/chip/timing_report -num_paths 5 -longest_path -clock_frequency
set novendor_constraint_file FALSE
auto_write -format VHDL syn/chip/chip_syn.vhd
set novendor_constraint_file FALSE
auto_write -format SDF syn/chip/chip_syn.sdf
auto_write -format Verilog syn/chip/chip_syn.v
auto_write -format SDF syn/chip/chip_syn.sdf