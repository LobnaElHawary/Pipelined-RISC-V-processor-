
`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: register32.v  
* Project: SSRisc  
* Author: Lobna, Mariane, Shahd 
* Description: a 32 bit register with a load, rst and clk 
*  
* Change history: 17/06/19 - created in lab 
*
*  **********************************************************************/ 


module register32(
input clk, 
input rst, 
input load, 
input [31:0] Din, 
output [31:0] Q
    );
    
wire [31:0] Dout;         
genvar i;
generate 
    for (i=0; i<32; i=i+1)
    begin
        MUX2x1 multi(.a(Q[i]), .b(Din[i]), .s(load), .c(Dout[i]));
        flipflop flip(.clk(clk), .rst(rst), .D(Dout[i]), .Q(Q[i]));
    end
    
endgenerate    

endmodule
