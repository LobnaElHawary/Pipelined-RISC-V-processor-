`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: HazardUnit.v  
* Project: SSRisc  
* Author: Mariane, Lobna, Shahd.  
* Description: This module outputs a flag that stalls if there is a hazard detected. 
*  
* Change history: 14:29 - 4/07/19 - created module for the lab and the project
*                 
*  **********************************************************************/ 


module HazardUnit(
input [4:0] IF_ID_RS1,
input [4:0] IF_ID_RS2, 
input [4:0] ID_EX_out_rd, 
input ID_EX_Memread, 
output reg stall
    );
    
    always @ (*)
        begin
        if((IF_ID_RS1 == ID_EX_out_rd | IF_ID_RS2 == ID_EX_out_rd) & (ID_EX_Memread & (ID_EX_out_rd != 0)))
            stall = 1'b1;
        else 
            stall = 1'b0;
    end
    
endmodule
