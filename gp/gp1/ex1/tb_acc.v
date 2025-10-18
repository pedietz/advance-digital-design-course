`include "acc.v"

`define NB_ODATA 6
`define NB_IDATA 3
`define NB_SEL   2

`timescale 1ns/100ps

module tb_acc();

parameter NB_ODATA = `NB_ODATA ;
parameter NB_IDATA = `NB_IDATA ;
parameter NB_SEL =   `NB_SEL   ;

wire [NB_IDATA - 1 : 0] o_data     ;
wire                    o_overflow ;
reg  [NB_IDATA - 1 : 0] i_data1    ;
reg  [NB_IDATA - 1 : 0] i_data2    ;
reg  [NB_SEL   - 1 : 0] i_sel      ;
reg                     i_rst_n    ;
reg                     clk        ;

integer fd_i_sel, fd_i_data1, fd_i_data2, fd_i_rst_n;
integer fd_o_mux, fd_o_data,  fd_o_overflow;
integer code_error, ptr;

initial begin
    fd_i_sel = $fopen("./vectors/i_sel.out");
    if (fd_i_sel == 0) $stop;
    fd_i_rst_n = $fopen("./vectors/i_rst_n.out");
    if (fd_i_rst_n == 0) $stop;
    fd_i_data1 = $fopen("./vectors/i_data1.out");
    if (fd_i_data1 == 0) $stop;
    fd_i_data2 = $fopen("./vectors/i_data2.out");
    if (fd_i_data2 == 0) $stop;
    fd_o_mux = $fopen("./vectors/o_mux.out");
    if (fd_o_mux == 0) $stop;
    fd_o_data = $fopen("./vectors/o_data.out");
    if (fd_o_data == 0) $stop;
    fd_o_overflow = $fopen("./vectors/o_overflow.out");
    if (fd_o_overflow == 0) $stop;
    clk = 1'b0;
end

always #5 clk = ~clk;

always @(posedge clk) begin
    
end

acc
#(
    .NB_ODATA   (NB_ODATA) ,
    .NB_IDATA   (NB_IDATA) ,
    .NB_SEL     (NB_SEL) 
)
u_acc
(
    .o_data     (o_data)     ,
    .o_overflow (o_overflow) ,
    .i_data1    (i_data1)    ,
    .i_data2    (i_data2)    ,
    .i_sel      (i_sel)      ,
    .i_rst_n    (i_rst_n)    ,
    .clk        (clk)
);

endmodule