load_library tsmc035_typ
set_working_dir /mnt/hgfs/DCNN-Accelerator/syn/controller
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/config.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/constants.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/register.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/queue.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/Reg_4.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/Reg_16.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/Queue_5.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/Queue_25.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/decoder.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/buffers/cache.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/counter.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/advancedCounter.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/buffers/image_window.vhd }
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/controller/controller.vhd }
# pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -common_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 
elaborate Controller -architecture Mixed 
# pre_optimize .work.Controller.Mixed -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize .work.Controller.Mixed -common_logic -boundary -xor_comparator_optimize 
pre_optimize .work.Controller.Mixed -extract 
set entity Controller
set architecture Mixed
set register2register 5.000000
set input2register 5.000000
set register2output 5.000000
optimize .work.Controller.Mixed -target tsmc035_typ -macro -area -effort standard -hierarchy auto 
optimize_timing .work.Controller.Mixed 
report_area /mnt/hgfs/DCNN-Accelerator/syn/controller/area_rep -cell_usage -all_leafs
report_delay /mnt/hgfs/DCNN-Accelerator/syn/controller/timing_report -num_paths 5 -longest_path -clock_frequency
set novendor_constraint_file FALSE
auto_write -format VHDL controller_syn.vhd
set novendor_constraint_file FALSE
auto_write -format SDF controller_syn.sdf
auto_write -format Verilog controller_syn.v
auto_write -format SDF controller_syn.sdf
