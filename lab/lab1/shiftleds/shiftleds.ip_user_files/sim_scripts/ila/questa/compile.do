vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/814a/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/1017/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/52c0/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/ila/ipshared/7b23/hdl/verilog" \
"../../../bd/ila/ip/ila_ila_0_0/sim/ila_ila_0_0.v" \
"../../../bd/ila/sim/ila.v" \


vlog -work xil_defaultlib \
"glbl.v"

