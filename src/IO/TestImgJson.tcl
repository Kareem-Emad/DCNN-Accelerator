proc c  {} {
    vcom src/dcnn_full_system.vhd   
    # vcom *.vhd 
    echo "---------------COMPILATION IS OVER--------------------------"
    vsim work.DCNNFullSystem
    echo "---------------STARTED SIMULATION---------------------------"
    add wave *
    # add wave -position insertpoint sim:/accelerator/ioU/ImgDecompU/*
    run -all
    force -freeze sim:/DCNNFullSystem/reset 1 0
    # force -freeze sim:/accelerator/i_clk 1 10, 0 {60 ps} -r 100
    force -freeze sim:/DCNNFullSystem/clk 1 0, 0 {0.5 ns} -r {1 ns}
    run
}

proc bitsToHex bits {
     set binValue [binary format B16 $bits]
     binary scan $binValue H4 hex
     return $hex
}

set fp [open "src/IO/img.txt" r]
set file_data [read $fp]
close $fp
set sz [string  length $file_data]

set fjson [open "src/IO/jsnC.txt" r]
set datajson [read $fjson]
close $fjson
set szjson [string  length $datajson]

#  compile, start sim and rst
c

force -freeze sim:/DCNNFullSystem/reset 0 0
force -freeze sim:/DCNNFullSystem/interrupt 0 0
force -freeze sim:/DCNNFullSystem/loadProcess 1 0
force -freeze sim:/DCNNFullSystem/CNNImage 1 0
run
set R [examine ready]

while {$R==0} {
    run
    set R [examine ready]
}
run
force -freeze sim:/DCNNFullSystem/interrupt 1 0
run
# force -freeze sim:/accelerator/i_interrupt 0 0
puts "image size is $sz , and Json size is $szjson"
set j 0
for { set i 0 }  {$i < $sz} {set i [expr {$i + 16}]} {
    set arr($j) [string range $file_data $i $i+15]
    puts "$arr($j)"
    set hex [bitsToHex $arr($j)]
    puts $hex
    force -freeze sim:/DCNNFullSystem/din $hex 0    
    run
    force -freeze sim:/DCNNFullSystem/interrupt 0 0
    incr j
    puts $j
    set x [examine ready]
    # puts $x
    while {$x==0} {
        run
        set x [examine ready]
    }
    force -freeze sim:/DCNNFullSystem/interrupt 1 0
}

# wait for Done Signal
force -freeze sim:/DCNNFullSystem/interrupt 0 0
# run
set D [examine ready]
while {$D==0} {
    run
    puts $D
    set D [examine ready]
}
run
####### image is done, So start sending CNN

# int + load + cnn
force -freeze sim:/DCNNFullSystem/interrupt 1 0
force -freeze sim:/DCNNFullSystem/loadProcess 1 0
force -freeze sim:/DCNNFullSystem/CNNImage 0 0
# run

set j 0
for { set i 0 }  {$i < $szjson} {set i [expr {$i + 16}]} {
    set arr($j) [string range $datajson $i $i+15]
    puts "$arr($j)"
    set hex [bitsToHex $arr($j)]
    puts $hex
    force -freeze sim:/DCNNFullSystem/din $hex 0    
    run
    force -freeze sim:/DCNNFullSystem/interrupt 0 0  
    incr j
    puts $j
    set x [examine ready]
    # puts $x
    set k 0
    while {$x == 0 } {
        run
        set x [examine ready]
    }
    force -freeze sim:/DCNNFullSystem/interrupt 1 0
}



# wait for Done Signal
force -freeze sim:/DCNNFullSystem/interrupt 0 0
# run
set D [examine ready]
while {$D==0} {
    run
    puts $D
    set D [examine ready]
}
run

# after sending process to the chip wait for done
force -freeze sim:/DCNNFullSystem/interrupt 1 0
force -freeze sim:/DCNNFullSystem/loadProcess 1 0
# set D [examine o_done]
# while {$D==0} {
#     run
#     set D [examine done]
# }

# set Result [examine dout]
# puts $Result


mem save -o {D:/CUFE/3B/VLSI/VLSI PROJECT/Integration/Json.mem} -f mti -data symbolic -addr hex -startaddress 0 -endaddress 65535 -wordsperline 1 /accelerator/mem/ram
