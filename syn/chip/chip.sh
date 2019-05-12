spectrum -f chip.tcl
sed -i 's/library IEEE;/library adk; use adk.adk_components.all; library IEEE;/g' chip_syn.vhd
sed -i 's/__/_/g' chip_syn.sdf
