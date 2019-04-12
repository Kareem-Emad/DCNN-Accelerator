load_library tsmc035_typ
read -technology "tsmc035_typ"  {/mnt/hgfs/DCNN-Accelerator/src/common/register.vhd }
pre_optimize -common_logic -unused_logic -boundary -xor_comparator_optimize 
pre_optimize -extract 
elaborate Reg -architecture Behavioral
set input2output 1.200000
optimize .dcnn.Reg.Behavioral -target tsmc035_typ -macro -delay -effort quick -hierarchy flatten 
optimize_timing .dcnn.Reg.Behavioral
set novendor_constraint_file FALSE
set sdf_names_style vhdl
auto_write -format SDF reg_syn.sdf
auto_write -format vhdl reg_syn.vhdl
report_area reg_Area_Report.rpt -cell_usage -all_leafs
report_delay reg_delay.rpt -num_paths 1 -longest_path -clock_frequency
