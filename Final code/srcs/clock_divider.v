`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: IntMem.v  
* Project: SSRisc  
* Author: mariane, lobna  and shahd 
* Description: A clock divider that halfs the clock frequency 
*  
* Change history: 08/07/19 - created  
*      
*  **********************************************************************/ 


module clock_divider( clk ,out_clk );
output reg out_clk;
input clk ;

initial begin
     out_clk = 1'b0;	
end
always @(posedge clk)
begin
     out_clk <= !out_clk;	
end
endmodule