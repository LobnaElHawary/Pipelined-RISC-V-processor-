`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: Decoder5x32.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: a decoder that decodes a 5 bit input to 32, used in regfile to decode the addresses
*  
* Change history: 19/06/19 - created in lab
*                 
*  **********************************************************************/ 


module Decoder5x32(
input [4:0] in, 
input en, 
output [31:0] out 
    );
    assign out = (en)? 1<< in  : 0; 
endmodule
