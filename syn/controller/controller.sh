spectrum -f controller.tcl
sed -i 's/library IEEE;/library adk; use adk.adk_components.all; library IEEE;/g' controller_syn.vhd
sed -i 's/__/_/g' controller_syn.sdf
