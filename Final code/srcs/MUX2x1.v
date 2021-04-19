`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: MUX2x1.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: a 2 by 1 multiplexer 
*  
* Change history: 17/06/19 - created in lab  
*                 
*  **********************************************************************/ 


module MUX2x1(
input a, 
input b, 
input s, 
output c 
    );
 wire and1;
 wire and2;
 wire nots;
 
 assign nots=~s;
 assign and1= a&nots;
 assign and2= b&s;
 assign c= and1|and2;
 
   
  
endmodule
