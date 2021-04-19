`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: forwarding_unit.v  
* Project: SSRisc  
* Author: Mariane, Lobna, Shahd.  
* Description: This module produces the controls needed for forwarding instructions.  
*  
* Change history: 11:46 - 4/07/19 - created module for the lab and the project
*                 - 10:15 - 11:34 debugged logical error in forwarding unit
                  - 12:15 realized we did not make a mistake, so we went back to the original code
                   08/07/19 - realized that we needed to alter the forwarding unit, so we did
*  **********************************************************************/ 
 

module ForwardingUnit(
input [4:0] ID_EX_RS1, 
input [4:0] ID_EX_RS2, 
input  MEM_WB_regwrite, 
input [4:0] MEM_WB_output_rd, 
output reg Forwarding_MUX_A,  // upper mux 
output reg Forwarding_MUX_B   // lower mux
    );
    
   always @ (*) 
   begin

                if(MEM_WB_regwrite && (ID_EX_RS1 == MEM_WB_output_rd) && (MEM_WB_output_rd !=0))
                begin 
                    //memory
                    Forwarding_MUX_A <= 1'b1;
                end
                
                else
                    //register
                    Forwarding_MUX_A <= 1'b0;
                    
                if(MEM_WB_regwrite && (ID_EX_RS2 == MEM_WB_output_rd) && (MEM_WB_output_rd !=0))
                begin 
                    Forwarding_MUX_B <= 1'b1;
                end
                
                else
                    Forwarding_MUX_B <= 1'b0;
           
   end
endmodule
