`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: ADD_SUB.v  
* Project: SSRisc  
* Author: Mariane, Lobna, Shahd.  
* Description: This module can either add or subtract two 32-bit values.  
*  
* Change history: 12/06/19 - wrote add module as part of the lab 
*                 19/06/19 - edited it to allow for subtraction, also in lab  
*  **********************************************************************/ 
 
module ADD_SUB(
input [31:0] A,
input [31:0] B, 
input cin, 
output [31:0] sum, 
output cout
    );
    
    
    wire [32:0] c;
    wire [31:0] b;  
    MUX2x1 mux2 (.a(1'b0) ,.b(1'b1), .s(cin), .c(c[0]));
    
    genvar i;
    generate 
        for (i=0; i<32; i=i+1)
        begin 
            MUX2x1 mux(.a(B[i]) ,.b(~B[i]), .s(cin), .c(b[i]));
            fulladder add ( .a(A[i]), .b(b[i]), .cin (c[i]), .sum(sum[i]), .cout(c[i+1]));
        end
    endgenerate 
    
    assign cout = c[32];


endmodule
