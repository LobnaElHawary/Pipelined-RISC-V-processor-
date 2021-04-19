`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: flipflop.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: a d flipflop
*  
* Change history: 17/06/19 - created in lab  
*                 
*  **********************************************************************/ 


module flipflop(
input clk,
input rst,
input D,
output reg Q
    );
    
    
    always @ (posedge clk or posedge rst)
     if (rst) begin
     Q <= 1'b0;
     end else begin
     Q <= D;
     end

endmodule



