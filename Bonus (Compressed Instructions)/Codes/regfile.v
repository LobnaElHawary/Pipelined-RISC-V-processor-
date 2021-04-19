
`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: regfile.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: a register file that has 32 registers, reg0 will always be 0.
*              contains a clk and reset and takes in 32 bit data to be saved in 
*              the registers. outputs 2 registers
*  
* Change history: 19/06/19 - created in lab  
*                 08/07/19 - Dr changed the way we had implemented the re0 to always be 0
*                            by generating from 1 to 32 and having the load be 0 for reg 0
*  **********************************************************************/ 

module regfile(
input clk,
input rst,
input  [31:0] writedata,
input [4:0] writereg, readreg1, readreg2, 
input regwrite, 
output  [31:0] readdata1, readdata2
    );
   
   
  wire [31:0] loaddec; 
  wire [31:0] regs [0:31]; 
  

  Decoder5x32 decode(.in(writereg), .en(regwrite), .out(loaddec));
  
  genvar i; 
  generate 

    register32 reg0 (.clk(clk), .rst(rst), .load(1'b0), .Din(writedata), .Q(regs[0]));

    
    for (i=1; i<32; i = i+1)
    begin
    
        register32 reg1 (.clk(clk), .rst(rst), .load(loaddec[i]), .Din(writedata), .Q(regs[i]));
         
    end     
  endgenerate  
  
  assign readdata1 = regs [readreg1];
  assign readdata2 = regs [readreg2];
  
   
endmodule
