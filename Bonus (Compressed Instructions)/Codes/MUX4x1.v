
`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: MUX4x1.v  
* Project: SSRisc  
* Author: Mariane, Lobna, Shahd.  
* Description: a 32 bit 4 by 1 multiplexer
*  
* Change history: 01/07/19 - created to be used for the updating the PC and RD
*  **********************************************************************/ 


module MUX4x1(
input [31:0] A, 
input [31:0] B, 
input [31:0] C, 
input [31:0] D, 
input [1:0] select, 
output [31:0] c 
 );
 
assign c = (select == 00)? A: (select == 01)? B: (select == 10)?  C : D;

endmodule
