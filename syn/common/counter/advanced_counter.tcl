load_library tsmc035_typ
read -technology "tsmc035_typ"  { /mnt/hgfs/DCNN-Accelerator/src/common/advancedCounter.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 
elaborate AdvancedCounter -architecture behavioural
set input2output 1.200000
optimize .dcnn.AdvancedCounter.behavioural -target tsmc035_typ -macro -delay -effort quick -hierarchy flatten 
optimize_timing .dcnn.AdvancedCounter.behavioural
set novendor_constraint_file FALSE
set sdf_names_style vhdl
auto_write -format SDF adv_counter_syn.sdf
auto_write -format vhdl adv_counter_syn.vhdl
report_area adv_counter_Area_Report.rpt -cell_usage -all_leafs
report_delay adv_counter_delay.rpt -num_paths 1 -longest_path -clock_frequency
