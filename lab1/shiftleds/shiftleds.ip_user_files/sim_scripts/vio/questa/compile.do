vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../shiftleds.gen/sources_1/bd/vio/ipshared/814a/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/vio/ipshared/1017/hdl/verilog" "+incdir+../../../../shiftleds.gen/sources_1/bd/vio/ipshared/4506/hdl" \
"../../../bd/vio/ip/vio_vio_0_0/sim/vio_vio_0_0.v" \
"../../../bd/vio/sim/vio.v" \


vlog -work xil_defaultlib \
"glbl.v"

