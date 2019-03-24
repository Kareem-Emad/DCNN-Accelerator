load_library tsmc035_typ
read -technology "tsmc035_typ"  { /home/ayman/Desktop/DCNN-Accelerator/src/ram/ram.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 
elaborate Ram -architecture Behavioral
set input2output 1.000000
optimize .work.Ram.Behavioral -target tsmc035_typ -macro -delay -effort quick -hierarchy flatten 
optimize_timing .work.Ram.Behavioral
set novendor_constraint_file FALSE
set sdf_names_style vhdl
auto_write -format SDF output/ram_syn.sdf
auto_write -format vhdl output/ram_syn.vhdl
report_area output/Area_Report.rpt -cell_usage -all_leafs
report_delay output/delay.rpt -num_paths 1 -longest_path -clock_frequency
