transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../shiftleds.gen/sources_1/bd/vio/ipshared/814a/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/vio/ipshared/1017/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/vio/ipshared/4506/hdl" -l xil_defaultlib \
"../../../bd/vio/ip/vio_vio_0_0/sim/vio_vio_0_0.v" \
"../../../bd/vio/sim/vio.v" \


vlog -work xil_defaultlib \
"glbl.v"

