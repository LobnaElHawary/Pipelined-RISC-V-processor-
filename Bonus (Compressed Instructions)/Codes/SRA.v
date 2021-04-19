`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: SRA.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: Shift Right Arithmetic, shifts a 32 bit input to the right and sign extends
*  
* Change history: 29/06/19 - created 
*                 
*  **********************************************************************/ 



module SRA(
input signed [31:0] A,
input [31:0] B,
output signed [31:0] C
    );
    
    
    assign C = A >>> B;  
    
endmodule

