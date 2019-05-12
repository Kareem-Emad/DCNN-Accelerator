set_working_dir /home/ayman/Programming/DCNN-Accelerator/
set bubble_tristates FALSE
load_library tsmc035_typ
read  { src/config.vhd }
read  { src/common/Reg_16.vhd }
read  { src/common/Reg_4.vhd }
read  { src/common/BitAdder.vhd }
read  { src/common/NAdder.vhd }
read  { src/common/NMUX_4.vhd }
read  { src/common/NMUX.vhd }
read  { src/comparator/Comparator.vhd }
read  { src/argmax/ArgMax.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 

set register2register 4.000000
set input2register 4.000000
set register2output 4.000000

optimize .work.ArgMax.DataFlow -target tsmc035_typ -macro -delay -effort standard -hierarchy flatten 
optimize_timing .work.ArgMax.DataFlow 

report_area area_report -cell_usage -hierarchy -all_leafs 

report_delay delay_report -num_paths 1 -critical_paths -clock_frequency

set novendor_constraint_file FALSE
auto_write -format VHDL -downto PRIMITIVES -module syn/argmax/ArgMax_syn.vhd

set novendor_constraint_file FALSE
auto_write -format SDF -downto PRIMITIVES -module syn/argmax/ArgMax_syn.sdf
