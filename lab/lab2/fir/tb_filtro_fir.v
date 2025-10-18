//! @title FIR Filter - Testbench
//! @file filtro_fir.v
//! @author Advance Digital Design - Ariel Pola
//! @date 29-08-2021
//! @version Unit02 - Modelo de Implementacion

//! - Fir filter with 4 coefficients
//! - **i_srst** is the system reset.
//! - **i_en** controls the enable (1) of the FIR. The value (0) stops the systems without change of the current state of the FIR.
//! - Coefficients [-1, 1/2, -1/4, 1/8]

//! ## WaveDrom
//! ### Example 1
//! { signal: [{ name: "Alfa", wave: "01.zx=ud.23.456789" }] }
//!
//! ### Example 2:
//! { signal: [
//!   { name: "pclk", wave: 'p.......' },
//!   { name: "Pclk", wave: 'P.......' },
//!   { name: "nclk", wave: 'n.......' },
//!   { name: "Nclk", wave: 'N.......' },
//!   {},
//!   { name: 'clk0', wave: 'phnlPHNL' },
//!   { name: 'clk1', wave: 'xhlhLHl.' },
//!   { name: 'clk2', wave: 'hpHplnLn' },
//!   { name: 'clk3', wave: 'nhNhplPl' },
//!   { name: 'clk4', wave: 'xlh.L.Hx' },
//! ]}
//! 
//! ### Otros Ejemplos
//! { signal: [
//!   { name: "clk",  wave: "P......" },
//!   { name: "bus",  wave: "x.==.=x", data: ["head", "body", "tail", "data"] },
//!   { name: "wire", wave: "0.1..0." }
//! ]}
//! 
//! { signal: [
//!   { name: "clk",         wave: "p.....|..." },
//!   { name: "Data",        wave: "x.345x|=.x", data: ["head", "body", "tail", "data"] },
//!   { name: "Request",     wave: "0.1..0|1.0" },
//!   {},
//!   { name: "Acknowledge", wave: "1.....|01." }
//! ]}
//! 
//! { signal: [
//!   {    name: 'clk',   wave: 'p..Pp..P'},
//!   ['Master',
//!     ['ctrl',
//!       {name: 'write', wave: '01.0....'},
//!       {name: 'read',  wave: '0...1..0'}
//!     ],
//!     {  name: 'addr',  wave: 'x3.x4..x', data: 'A1 A2'},
//!     {  name: 'wdata', wave: 'x3.x....', data: 'D1'   },
//!   ],
//!   {},
//!   ['Slave',
//!     ['ctrl',
//!       {name: 'ack',   wave: 'x01x0.1x'},
//!     ],
//!     {  name: 'rdata', wave: 'x.....4x', data: 'Q2'},
//!   ]
//! ]}
//! 
//! { signal: [
//!   { name: "CK",   wave: "P.......",                                              period: 2  },
//!   { name: "CMD",  wave: "x.3x=x4x=x=x=x=x", data: "RAS NOP CAS NOP NOP NOP NOP", phase: 0.5 },
//!   { name: "ADDR", wave: "x.=x..=x........", data: "ROW COL",                     phase: 0.5 },
//!   { name: "DQS",  wave: "z.......0.1010z." },
//!   { name: "DQ",   wave: "z.........5555z.", data: "D0 D1 D2 D3" }
//! ]}
//! 
//! { signal: [
//!   { name: 'A', wave: '01........0....',  node: '.a........j' },
//!   { name: 'B', wave: '0.1.......0.1..',  node: '..b.......i' },
//!   { name: 'C', wave: '0..1....0...1..',  node: '...c....h..' },
//!   { name: 'D', wave: '0...1..0.....1.',  node: '....d..g...' },
//!   { name: 'E', wave: '0....10.......1',  node: '.....ef....' }
//!   ],
//!   edge: [
//!     'a~b t1', 'c-~a t2', 'c-~>d time 3', 'd~-e',
//!     'e~>f', 'f->g', 'g-~>h', 'h~>i some text', 'h~->j'
//!   ]
//! }
//! 
//! { signal: [
//!   { name: 'A', wave: '01..0..',  node: '.a..e..' },
//!   { name: 'B', wave: '0.1..0.',  node: '..b..d.', phase:0.5 },
//!   { name: 'C', wave: '0..1..0',  node: '...c..f' },
//!   {                              node: '...g..h' },
//!   {                              node: '...I..J',  phase:0.5 },
//!   { name: 'D', wave: '0..1..0',  phase:0.5 }
//!   ],
//!   edge: [
//!     'b-|a t1', 'a-|c t2', 'b-|-c t3', 'c-|->e t4', 'e-|>f more text',
//!     'e|->d t6', 'c-g', 'f-h', 'g<->h 3 ms', 'I+J 5 ms'
//!   ]
//! }
//! 
//! (function (bits, ticks) {
//!   var i, t, gray, state, data = [], arr = [];
//!   for (i = 0; i < bits; i++) {
//!     arr.push({name: i + '', wave: ''});
//!     state = 1;
//!     for (t = 0; t < ticks; t++) {
//!       data.push(t + '');
//!       gray = (((t >> 1) ^ t) >> i) & 1;
//!       arr[i].wave += (gray === state) ? '.' : gray + '';
//!       state = gray;
//!     }
//!   }
//!   arr.unshift('gray');
//!   return {signal: [
//!     {name: 'bin', wave: '='.repeat(ticks), data: data}, arr
//!   ]};
//! })(5, 16)

`timescale 1ns/1ps

module tb_filtro_fir ();

    parameter NB_INPUT   = 8; //! NB of input
    parameter NBF_INPUT  = 7; //! NBF of input
    parameter NB_OUTPUT  = 8; //! NB of output
    parameter NBF_OUTPUT = 7; //! NBF of output
    parameter NB_COEFF   = 8; //! NB of Coefficients
    parameter NBF_COEFF  = 7; //! NBF of Coefficients

    reg             tb_clk;
    reg             tb_en;
    reg             tb_srst;
    reg  [NB_INPUT-1:0] tb_is_data;

    wire [NB_OUTPUT-1:0] tb_os_data;

    reg             aux_tb_en;
    reg             aux_tb_srst;
    reg  [NB_INPUT-1:0] aux_tb_is_data;

    //! Instance of FIR
    filtro_fir
        #(
            .NB_INPUT   (NB_INPUT),   //! NB of input
            .NBF_INPUT  (NBF_INPUT),  //! NBF of input
            .NB_OUTPUT  (NB_OUTPUT),  //! NB of output
            .NBF_OUTPUT (NBF_OUTPUT), //! NBF of output
            .NB_COEFF   (NB_COEFF),   //! NB of Coefficients
            .NBF_COEFF  (NBF_COEFF)   //! NBF of Coefficients
        )
        u_filtro_fir
        (
            .o_os_data  (tb_os_data),
            .i_is_data  (tb_is_data),
            .i_srst     (tb_srst),
            .i_en       (tb_en),
            .clk        (tb_clk)
        );

    // Clock
    always #20 tb_clk = ~tb_clk;

    always @(posedge tb_clk)
    begin
        tb_en      <= aux_tb_en;
        tb_srst    <= aux_tb_srst;
        tb_is_data <= aux_tb_is_data;
    end

    // Stimulus
    real i;
    real aux;
    initial
    begin
        $display("");
        $display("Simulation Started");
        //$dumpfile("./verification/tb_filtro_fir/waves.vcd");
        //$dumpvars(0, tb_filtro_fir);
        tb_clk            = 1'b1;
        #5;
        aux_tb_en         = 1'b1;
        aux_tb_srst       = 1'b1;
        #40;
        aux_tb_en         = 1'b1;
        aux_tb_srst       = 1'b0;
        #1000
         for (i=0;i<4000;i=i+1)
         begin
             aux = $sin(2.0*3.1415926*i/25000.0*1000.0)*(2**NBF_INPUT);
             if(aux > 127.0)
                 aux_tb_is_data = 8'h7F;
             else
                 aux_tb_is_data = aux;
             #20;
             //@(posedge tb_clk);
         end
         $display("Simulation Finished");
        $display("");
        $finish;
    end

endmodule
