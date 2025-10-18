module acc
#(
    parameter NB_ODATA = 6,
    parameter NB_IDATA = 3,
    parameter NB_SEL = 2
)
(
    output [NB_IDATA - 1 : 0] o_data    ,
    output                    o_overflow,
    input  [NB_IDATA - 1 : 0] i_data1   ,
    input  [NB_IDATA - 1 : 0] i_data2   ,
    input  [NB_SEL   - 1 : 0] i_sel     ,
    input                     i_rst_n   ,
    input                     clk
);

localparam NB_MUX = NB_IDATA + 1;
localparam NB_SUM = NB_ODATA + 1;

wire [NB_MUX-1 : 0] o_mux;
reg  [NB_SUM-1 : 0] sum  ;

assign o_mux = (i_sel == 2'b00) ? {1'b0, i_data2}   :
               (i_sel == 2'b01) ? i_data1 + i_data2 :
               (i_sel == 2'b10) ? {1'b0, i_data1}   :
                                  {1'b0, i_data1}   ;

always @(posedge clk or negedge i_rst_n) begin
    if (!i_rst_n)
        sum <= {NB_SUM{1'b0}};
    else
        sum <= {{(NB_SUM - NB_MUX - 1){1'b0}}, o_mux} + sum[NB_SUM - 2 : 0];
end

assign {o_overflow, o_data} = sum;

endmodule