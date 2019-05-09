set_working_dir /home/ayman/Programming/DCNN-Accelerator/syn/computation_block
set bubble_tristates FALSE
load_library tsmc035_typ
read  { /home/ayman/Programming/DCNN-Accelerator/src/config.vhd }
read  { /home/ayman/Programming/DCNN-Accelerator/src/common/Reg_16.vhd }
read  { /home/ayman/Programming/DCNN-Accelerator/src/common/Reg_4.vhd }
read  { /home/ayman/Programming/DCNN-Accelerator/src/comparator/Comparator.vhd }
read  { /home/ayman/Programming/DCNN-Accelerator/src/argmax/ArgMax.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 

set register2register 4.000000
set input2register 4.000000
set register2output 4.000000

optimize .work.ComputationBlock.Structural -target tsmc035_typ -macro -delay -effort standard -hierarchy flatten 
optimize_timing .work.ComputationBlock.Structural 
optimize .work.ComputationBlock.Structural -target tsmc035_typ -macro -delay -effort standard -hierarchy flatten 
optimize_timing .work.ComputationBlock.Structural 

report_area /home/ayman/Programming/DCNN-Accelerator/syn/computation_block/area_report -cell_usage -hierarchy -all_leafs 

report_delay /home/ayman/Programming/DCNN-Accelerator/syn/computation_block/delay_report -num_paths 1 -critical_paths -clock_frequency

set novendor_constraint_file FALSE
auto_write /home/ayman/Programming/DCNN-Accelerator/syn/computation_block/computation_block_syn.v

set novendor_constraint_file FALSE
auto_write -format VHDL -downto PRIMITIVES -module computation_block_syn.vhd

set novendor_constraint_file FALSE
auto_write -format SDF -downto PRIMITIVES -module computation_block_syn.sdf
