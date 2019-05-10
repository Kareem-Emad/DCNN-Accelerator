proc c  {} {
    vcom ~/Final_VLSI/DCNN_Accelerator_IO/IO/integration.vhd   
    # vcom *.vhd 
    echo "---------------COMPILATION IS OVER--------------------------"
    vsim work.accelerator
    echo "---------------STARTED SIMULATION---------------------------"
    add wave *
    add wave -position insertpoint sim:/accelerator/ioU/ImgDecompU/*
    run -all
    force -freeze sim:/accelerator/i_rst 1 0
    # force -freeze sim:/accelerator/i_clk 1 10, 0 {60 ps} -r 100
    force -freeze sim:/accelerator/i_clk 1 0, 0 {50 ps} -r 100
    run
}

proc bitsToHex bits {
     set binValue [binary format B16 $bits]
     binary scan $binValue H4 hex
     return $hex
}

set fp [open "~/Final_VLSI/DCNN_Accelerator_IO/IO/img.txt" r]
set file_data [read $fp]
close $fp
set sz [string  length $file_data]

set fjson [open "~/Final_VLSI/DCNN_Accelerator_IO/IO/jsnC.txt" r]
set datajson [read $fjson]
close $fjson
set szjson [string  length $datajson]

#  compile, start sim and rst
c

force -freeze sim:/accelerator/i_rst 0 0
force -freeze sim:/accelerator/i_interrupt 0 0
force -freeze sim:/accelerator/i_loadProcess 1 0
force -freeze sim:/accelerator/i_CNNImage 1 0
run
set R [examine o_ready]

while {$R==0} {
    run
    set R [examine o_ready]
}
run
force -freeze sim:/accelerator/i_interrupt 1 0
run
# force -freeze sim:/accelerator/i_interrupt 0 0

set j 0
for { set i 0 }  {$i < $sz} {set i [expr {$i + 16}]} {
    set arr($j) [string range $file_data $i $i+15]
    puts "$arr($j)"
    set hex [bitsToHex $arr($j)]
    puts $hex
    force -freeze sim:/accelerator/i_din $hex 0    
    run
    force -freeze sim:/accelerator/i_interrupt 0 0
    incr j
    puts $j
    set x [examine o_ready]
    # puts $x
    while {$x==0} {
        run
        set x [examine o_ready]
    }
    force -freeze sim:/accelerator/i_interrupt 1 0
}

# wait for Done Signal
force -freeze sim:/accelerator/i_interrupt 0 0
# run
set D [examine o_ready]
while {$D==0} {
    run
    puts $D
    set D [examine o_ready]
}
run
####### image is done, So start sending CNN

# int + load + cnn
force -freeze sim:/accelerator/i_interrupt 1 0
force -freeze sim:/accelerator/i_loadProcess 1 0
force -freeze sim:/accelerator/i_CNNImage 0 0
run

set j 0
for { set i 0 }  {$i < $szjson} {set i [expr {$i + 16}]} {
    set arr($j) [string range $datajson $i $i+15]
    puts "$arr($j)"
    set hex [bitsToHex $arr($j)]
    puts $hex
    force -freeze sim:/accelerator/i_din $hex 0    
    run
    force -freeze sim:/accelerator/i_interrupt 0 0  
    incr j
    set x [examine o_ready]
    puts $x
    set k 0
    while {$x == 0 } {
        run
        set x [examine o_ready]
    }
    force -freeze sim:/accelerator/i_interrupt 1 0
}



# wait for Done Signal
force -freeze sim:/accelerator/i_interrupt 0 0
# run
set D [examine o_ready]
while {$D==0} {
    run
    puts $D
    set D [examine o_ready]
}
run

# after sending process to the chip wait for done
force -freeze sim:/accelerator/i_interrupt 1 0
force -freeze sim:/accelerator/i_loadProcess 1 0
# set D [examine o_done]
# while {$D==0} {
#     run
#     set D [examine o_done]
# }

# set Result [examine o_dout]
# puts $Result


