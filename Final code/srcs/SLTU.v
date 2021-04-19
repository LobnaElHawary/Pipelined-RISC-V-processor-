`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: SLTU.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: compares 2 32bit inputs and outputs if the first is less than the second
*  
* Change history: 28/06/19 - created
*                 
*  **********************************************************************/ 


module SLTU(
input [31:0] A, 
input [31:0] B,
output [31:0] C
    );
    
    assign C = (A < B)? 1 : 0;
endmodule
