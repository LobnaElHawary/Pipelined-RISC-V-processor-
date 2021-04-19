`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: MUX32.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: a 2 by 1 32 bit size multiplexer
*  
* Change history: 17/06/19 - created in lab  
*                 
*  **********************************************************************/ 


module MUX32(
input [31:0] a, 
input [31:0] b, 
input s, 
output [31:0] out
);
    
assign out = (s)? b:a;

endmodule
