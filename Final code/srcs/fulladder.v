
`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: fulladder.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: a 1 bit adder
*  
* Change history: 12/06/19 - created in lab  
*                 
*  **********************************************************************/ 


module fulladder(
input a, 
input b, 
input cin,  
output sum,
output cout  
    );
    
 wire xor1; 
 wire and1;
 wire and2;
 
 assign xor1= a ^ b;
 assign sum= xor1 ^ cin; 
 assign and1= cin & xor1; 
 assign and2= b & a; 
 assign cout= and1|and2; 
endmodule
