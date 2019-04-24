spectrum -f controller.tcl
sed -i ' 1 s/.*/&library adk; use adk.adk_components.all;/' controller_syn.vhd
