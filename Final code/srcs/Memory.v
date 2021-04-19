`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: Memory.v  
* Project: SSRisc  
* Authors: Mariane, Lobna, Shahd.  
* Description: This is the single memory, it is a large 8 bit array. it can write into and read from the memory
*              It is used for both the instruction and data memory
* Change history: 24/06/19 - wrote as part of lab (was data memory)
                  01/07/19 - edited to be 8 bit array instead of a word addressable memory
                             tested it make sure it is working
                  02/07/19 - edited to contain an initial begin for testing
                  08/07/19 - made the datamemory into the Memory.v module 
*  **********************************************************************/ 

module Memory(input clk, input [2:0] func3, input MemRead, input MemWrite,
 input [5:0] addr, input [31:0] data_in, output reg [31:0] data_out);
 
  reg [7:0] mem [0:63];
 
  
  initial begin
  mem[0]=  8'b0_0110011;  //add x0.x0,x0
      mem[1] = 8'b0_000_0000;
      mem[2] = 8'b0000_0000;
      mem[3] = 8'b00000000;
      
      mem[4]=  8'b1_0000011;  //lw x1, 52(x0)
      mem[5] = 8'b0_010_0000;
      mem[6] = 8'b0100_0000;
      mem[7] = 8'b00000011;
  
      mem[8] = 8'b0_0000011; //lw x2, 56(x0)
      mem[9] = 8'b0_010_0001;
      mem[10] = 8'b1000_0000;
      mem[11] = 8'b00000011;
      
      mem[12]=  8'b1_0000011;  //lw x3, 60(x0)
      mem[13] = 8'b0_010_0001;
      mem[14] = 8'b1100_0000;
      mem[15] = 8'b000000011;
      
      
      mem[20] = 8'b0_1100011;  //blt x3, x2, 12 
      mem[21] = 8'b1_100_1100;
      mem[22] = 8'b0010_0001;
      mem[23] = 8'b0000000_0;
  
      mem[24] = 8'b1_0110011;  //add x3, x1, x2 //should be skipped
      mem[25] = 8'b1_000_0001;
      mem[26] = 8'b0010_0000;
      mem[27] = 8'b00000000;
      
      
      mem[28] = 8'b1_0110011;  //add x5, x3, x2
      mem[29] = 8'b1_000_0010;
      mem[30] = 8'b0010_0001;
      mem[31] = 8'b00000000;
      
     
          //data mem
          
      mem[52] = 8'd17;
      mem[53] = 8'b0;
      mem[54] = 8'b0;
      mem[55] = 8'b0;
      
  
      mem[56] = 8'd25; 
      mem[57] = 8'h00;
      mem[58] = 8'h00;
      mem[59] = 8'h00;
  
      mem[60] = 8'd9; 
      mem[61] = 8'h00;
      mem[62] = 8'h00;
      mem[63] = 8'h00;
  
 end 

       always @(*)
  begin
  
    if (MemWrite && !clk)
      case(func3)
          //store byte 
          3'b000:
               mem[addr] = data_in [7:0]; 
               
          //store half word 
          3'b001:
          begin
              mem[addr] = data_in [7:0]; 
              mem[addr + 1] = data_in [15:8];
          end
              
          //store word 
          3'b010:
          begin
              mem[addr] = data_in [7:0]; 
              mem[addr + 1] = data_in [15:8];
              mem[addr + 2] = data_in [23:16];
              mem[addr + 3] = data_in [31:24];
          end
      endcase
      
    if(clk)
           data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; 
                     
    else
    
    begin
    if (MemRead)
          case(func3)
          
              //load byte 
              3'b000:
                   data_out = {{24{ mem[addr][7]}}, mem[addr]}; 
                    
              //load half word 
              3'b001:
                  data_out = {{16{mem[addr+1][7]}},mem[addr+1] ,mem[addr]}; 
                  
              //load word 
              3'b010:
                  data_out = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]}; 
                  
              //load byte unsigned
              3'b100:
                  data_out = {{24{1'b0}}, mem[addr]};
                  
              //load half word unsigned
              3'b101:
                  data_out = {{16{1'b0}},mem[addr+1], mem[addr]};
           
             default:
                  data_out = 0; 
          endcase
        end
   
   end
  
 endmodule

