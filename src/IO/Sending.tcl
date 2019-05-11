proc c  {} {
    vcom IO.vhd   
    echo "---------------COMPILATION IS OVER--------------------------"
    vsim work.IO
    echo "---------------STARTED SIMULATION---------------------------"
    add wave *
    run -all
    force -freeze sim:/io/Rst 1 0
    run
}

proc bitsToHex bits {
     set binValue [binary format B16 $bits]
     binary scan $binValue H4 hex
     return $hex
}

set fjson [open "jsnC.txt" r]
set datajson [read $fjson]
close $fjson
set szjson [string  length $datajson]


set fp [open "compimg.txt" r]
set file_data [read $fp]
close $fp
set sz [string  length $file_data]

c
#CNN
force -freeze sim:/io/Interrupt 1 0
force -freeze sim:/io/LoadProcess 0 0
# Load 1 process 0 CHECK !!!
force -freeze sim:/io/CNNImage 0 0
# CNN 0 Image 1 CHECK!!!
force -freeze sim:/io/Rst 0 0
force -freeze sim:/io/Clk 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/io/Interrupt 0 0

set j 0
for { set i 0 }  {$i < $szjson} {set i [expr {$i + 15}]} {
    set arr($j) [string range $datajson $i $i+15]
    puts "$arr($j)"
    set hex [bitsToHex $arr($j)]
    puts $hex
    force -freeze sim:/io/Din $hex 0    
    run
    incr j
    set x [examine Ready]
    puts $x
    set k 0
    while {$x == 0 && $k <5} {
    # while {$x==0} {}
        run
        incr k
    }
}

# wait for Done Signal
set D [examine Done]
while {$D==0} {
    run
}

#IMAGE 
force -freeze sim:/io/Interrupt 1 0
force -freeze sim:/io/LoadProcess 0 0
# Load 1 process 0 CHECK !!!
force -freeze sim:/io/CNNImage 1 0
run
force -freeze sim:/io/Interrupt 0 0


set j 0
for { set i 0 }  {$i < $sz} {set i [expr {$i + 15}]} {
    set arr($j) [string range $file_data $i $i+15]
    puts "$arr($j)"
    set hex [bitsToHex $arr($j)]
    puts $hex
    force -freeze sim:/io/Din $hex 0    
    run
    incr j
    set x [examine Ready]
    puts $x
    # set k 0
    #  while {$x == 0 && $k <5} {
    while {$x==0} {}
        run
        #  incr k
    }
}

# wait for Done Signal
set D [examine Done]
while {$D==0} {
    run
}

force -freeze sim:/io/Interrupt 1 0
force -freeze sim:/io/LoadProcess 0 0
run
force -freeze sim:/io/Interrupt 0 0


# wait for Done Signal
set D [examine Done]
while {$D==0} {
    run
}

set Result [examine Dout]
puts $Result
