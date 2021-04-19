
`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: ALU.v  
* Project: SSRisc  
* Author: Mariane, Lobna, Shahd.  
* Description: This is the main ALU module, using the ALU_cntrl signal will perform 1 of the operations on the 2 given inputs.  
*  
* Change history: 19/06/19 - wrote as part of lab
                  28/06/19 - edited to add other operations required for the project, such as the shift instructions and set less than  
                  
*  **********************************************************************/ 
module ALU(input [31:0] A, input [31:0] B, input [3:0] ALU_cntrl, output reg [31:0] result);

    wire [31:0] temp_srl,temp_sra, temp_sll, temp_slt, temp_sltu;
    
    SRL srl(.A(A), .B(B), .C(temp_srl)); 
    SRA sra(.A(A), .B(B), .C(temp_sra));
    SLL sll(.A(A), .B(B), .C(temp_sll));
    SLT slt(.A(A), .B(B), .C(temp_slt));
    SLTU sltu(.A(A), .B(B), .C(temp_sltu));
    
    always @(*)
    begin
        case(ALU_cntrl)
        
        //and 
        4'b0000: 
            result = A & B; 
        //or 
        4'b0001: 
            result = A | B;
        //add
        4'b0010: 
            result = A + B;
        //xor
        4'b0011: 
            result = A ^ B;
        //srl 
        4'b0100: 
            result = temp_srl; 
        //sra
        4'b0101: 
            result = temp_sra;
        //subtract
        4'b0110: 
            result = A - B;
        //sll
        4'b0111:
            result = temp_sll;
        //slt
        4'b1000:
            result = temp_slt; 
        //sltu
        4'b1001:
            result = temp_sltu;
        //does nothing
        4'b1010:
            result = B;
        default: 
            result = 0; 
        
        endcase
    end
        
endmodule
