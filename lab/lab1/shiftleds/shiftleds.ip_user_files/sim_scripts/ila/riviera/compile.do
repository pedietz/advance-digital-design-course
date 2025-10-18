transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/814a/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/1017/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/52c0/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/7b23/hdl/verilog" -l xil_defaultlib \
"../../../bd/ila/ip/ila_ila_0_0/sim/ila_ila_0_0.v" \
"../../../bd/ila/sim/ila.v" \


vlog -work xil_defaultlib \
"glbl.v"

