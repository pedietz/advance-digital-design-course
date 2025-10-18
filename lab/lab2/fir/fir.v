//! @title FIR Filter
//! @file fir_filter.v
//! @author Pablo Dietz
//! @date 05-10-2025
//! @version v1.0

//! - Fir filter with 4 coefficients
//! - **i_srst** is the system reset.
//! - **i_en** controls the enable (1) of the FIR. The value (0) stops the systems without change of the current state of the FIR.
//! - Coefficients [-1, 1/2, -1/4, 1/8]

module filtro_fir
    #(
         parameter NB_INPUT   = 8, //! NB of input
         parameter NBF_INPUT  = 7, //! NBF of input
         parameter NB_OUTPUT  = 8, //! NB of output
         parameter NBF_OUTPUT = 7, //! NBF of output
         parameter NB_COEFF   = 8, //! NB of Coefficients
         parameter NBF_COEFF  = 7, //! NBF of Coefficients
         parameter N_TAPS     = 4  //! N of Taps
     )
     (
         output signed [NB_OUTPUT-1:0] o_os_data, //! Output Sample
         input  signed [NB_INPUT -1:0] i_is_data, //! Input Sample
         input                         i_en     , //! Enable
         input                         i_srst   , //! Reset
         input                         clk        //! Clock
     );

    localparam NB_ADD     = NB_COEFF  + NB_INPUT + 2; //! Local Parameters
    localparam NBF_ADD    = NBF_COEFF + NBF_INPUT;    //! Local Parameters
    localparam NBI_ADD    = NB_ADD    - NBF_ADD;      //! Local Parameters
    localparam NBI_OUTPUT = NB_OUTPUT - NBF_OUTPUT;   //! Local Parameters
    localparam NB_SAT     = (NBI_ADD) - (NBI_OUTPUT); //! Local Parameters

    //! Internal Signals
    reg  signed [NB_INPUT         -1:0] register [3:1]; //! Matrix for registers
    wire signed [         NB_COEFF-1:0] coeff    [3:0]; //! Matrir for Coefficients
    wire signed [NB_INPUT+NB_COEFF-1:0] prod     [3:0]; //! Partial Products

    
    assign coeff[0] = 8'b1000_0000; // Coeff0 = -1
    assign coeff[1] = 8'b0100_0000; // Coeff1 = 1/2
    assign coeff[2] = 8'b1110_0000; // Coeff2 = -1/4 1/8]
    assign coeff[3] = 8'b0001_0000; // Coeff3 = 1/8

    //! Shift Register
    integer ptr1, ptr2; //! Aux. pointer
    always @(posedge clk)
    begin:shiftreg
        if (i_srst == 1'b1)
        begin
            for(ptr1 = 1; ptr1 < N_TAPS; ptr1 = ptr1 + 1)
            begin:init
                register[ptr1] <= {NB_INPUT{1'b0}};
            end
        end
        else
        begin
            if (i_en == 1'b1)
            begin
                for(ptr2 = 1; ptr2 < N_TAPS; ptr2 = ptr2 + 1)
                begin:shift
                    if(ptr2==1)
                        register[ptr2] <= i_is_data;
                    else
                        register[ptr2] <= register[ptr2-1];
                end
            end
        end
    end

    //! Products
    generate
        genvar ptr;
        for(ptr = 0; ptr < N_TAPS; ptr = ptr + 1)
        begin:mult
            if (ptr==0)
                assign prod[ptr] = coeff[ptr] * i_is_data;
            else
                assign prod[ptr] = coeff[ptr] * register[ptr];
        end
    endgenerate

    // Adders
    integer ptr3; //! Aux. pointer
    reg signed [NB_ADD-1:0] sum; //! Sum of partial products
    always @(*)
    begin:accum
        sum = {NB_ADD{1'b0}};
        for(ptr3 = 0; ptr3 < N_TAPS; ptr3 = ptr3 + 1)
        begin:adder
            sum = sum + prod[ptr3];
        end
    end

    //! Output Assign
    assign o_os_data = ( ~|sum[NB_ADD-1 -: NB_SAT+1] || &sum[NB_ADD-1 -: NB_SAT+1])?
           sum[NB_ADD-(NBI_ADD-NBI_OUTPUT) - 1 -: NB_OUTPUT]:
           (sum[NB_ADD-1])?
           {{1'b1},{NB_OUTPUT-1{1'b0}}}:
           {{1'b0},{NB_OUTPUT-1{1'b1}}};

endmodule
