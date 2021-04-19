
`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: comparator.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: this is a modified comparator that is used for all the branch 
*              instructions to output 1 bit if it is either equal, not equal, greater than or less than
*  
* Change history: 28/06/19 - created module
*                 28/06/19 - added sign bit to the control signals
*                 08/07/19 - Dr made a change: took the assign statments out of the always block.
*  **********************************************************************/ 


module comparator(
input [31:0] A, 
input [31:0] B,
input [1:0] Control_line,
input sign, // to determine whether signed or unsigned operation   
output reg  Bflag
    );
    
  
    wire signed [31:0] C, D; 
   
    //00 is BEQ, 01 is BNE, 10 BLT, 11 BGT
    assign C = A; 
    assign D = B;
    
    always @(*) 
    begin 
     // if input sign = 1, unsigned
    if (sign==1) begin 
            case(Control_line) 
            2'b00: begin 
                Bflag= (C==D) ? 1 : 0; 
            end  
            2'b01:begin 
                Bflag= (C!=D) ? 1 : 0; 
            end  
            2'b10:begin
                Bflag= (A<B) ? 1 : 0; 
            end 
            2'b11:begin 
                Bflag= (A>B) ? 1 : 0; 
            end 
            default: 
                Bflag= 0; 
            endcase 
        end 
    
    // if input sign = 0, signed
    else if (sign ==0) begin 
         case(Control_line) 
           2'b00: begin 
               Bflag= (C==D) ? 1 : 0; 
           end  
           2'b01:begin 
               Bflag= (C!=D) ? 1 : 0; 
           end  
           2'b10:begin
               Bflag= (C<D) ? 1 : 0; 
           end 
           2'b11:begin 
               Bflag= (C>D) ? 1 : 0; 
           end 
           default: 
               Bflag= 0; 
           endcase 
    end 
   end
   
endmodule
