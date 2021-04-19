`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: SRL.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: Shift right Logical, shifts a 32 bit number to the right but does not sign extend
*  
* Change history: 28/06/19 - created
*                 
*  **********************************************************************/ 



module SRL(
input [31:0] A,
input [31:0] B,
output [31:0] C
    );
    assign C = A >> B;  
endmodule
