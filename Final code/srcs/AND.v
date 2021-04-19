`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: AND.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: ands 2 single bit inputs
*  
* Change history: 19/06/19 - created in lab
*                 
*  **********************************************************************/ 


module AND(input A, input B, output out);

   assign  out = A & B;
   
endmodule
