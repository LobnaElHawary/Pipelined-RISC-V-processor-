
`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: SLL.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: shifts a 32 bit input by a given number througha 32 bit input to the left.
*  
* Change history: 28/06/19 - created
*                 
*  **********************************************************************/ 



module SLL(
input [31:0] A, 
input [31:0] B, 
output [31:0] C
    );
  
    assign C = A << B; 
  
endmodule
