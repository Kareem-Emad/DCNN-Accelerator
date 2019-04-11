load_library tsmc035_typ
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/counter.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 
elaborate Counter -architecture behavioural
set input2output 1.200000
optimize .work.Counter.behavioural -target tsmc035_typ -macro -delay -effort quick -hierarchy flatten 
optimize_timing .work.Counter.behavioural
set novendor_constraint_file FALSE
set sdf_names_style vhdl
auto_write -format SDF counter_syn.sdf
auto_write -format vhdl counter_syn.vhdl
report_area counter_Area_Report.rpt -cell_usage -all_leafs
report_delay counter_delay.rpt -num_paths 1 -longest_path -clock_frequency
