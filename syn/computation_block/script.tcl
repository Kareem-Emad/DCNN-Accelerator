set_working_dir /home/ayman/Programming/DCNN-Accelerator/
set bubble_tristates FALSE
load_library tsmc035_typ
read  { src/config.vhd }
read  { src/common/BitAdder.vhd }
read  { src/common/NAdder.vhd }
read  { src/common/register.vhd }
read  { src/common/Reg_16.vhd }
read  { src/common/Queue_5.vhd }
read  { src/common/Queue_25.vhd }
read  { src/buffers/image_window.vhd }
read  { src/buffers/filter_window.vhd }
read  { src/buffers/computation_cache.vhd }
read  { src/computation_block/multipliers/modified_booth_multiplier.vhd }
read  { src/computation_block/multipliers/multiplier.vhd }
read  { src/computation_block/computation_pipeline/mux_layer/mux_layer.vhd }
read  { src/computation_block/computation_pipeline/multiplication_layer/multiplication_layer.vhd }
read  { src/computation_block/computation_pipeline/addition_layer/op7_router.vhd }
read  { src/computation_block/computation_pipeline/addition_layer/op9_router.vhd }
read  { src/computation_block/computation_pipeline/addition_layer/op9_tree.vhd }
read  { src/computation_block/computation_pipeline/addition_layer/op7_tree.vhd }
read  { src/computation_block/computation_pipeline/addition_layer/addition_layer.vhd }
read  { src/computation_block/computation_pipeline/merge_layer/merge_layer.vhd }
read  { src/computation_block/computation_pipeline/merge_layer/merge_layer2.vhd }
read  { src/computation_block/computation_pipeline/relu_layer/relu_layer.vhd }
read  { src/computation_block/computation_pipeline/cache_muxer.vhd }
read  { src/computation_block/computation_pipeline/computation_pipeline.vhd }
read  { src/computation_block/computation_block.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 

set register2register 6.500000
set input2register 6.500000
set register2output 6.500000

optimize .work.ComputationBlock.Structural -target tsmc035_typ -macro -delay -effort standard -hierarchy flatten 
optimize_timing .work.ComputationBlock.Structural  

report_area area_report -cell_usage -hierarchy -all_leafs 
report_delay delay_report -num_paths 1 -critical_paths -clock_frequency

set novendor_constraint_file FALSE
auto_write syn/computation_block/computation_block_syn.v
auto_write -format VHDL -module syn/computation_block/computation_block_syn.vhd
auto_write -format SDF -module syn/computation_block/computation_block_syn.sdf
