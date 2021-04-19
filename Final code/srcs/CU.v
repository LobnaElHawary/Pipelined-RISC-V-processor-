`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: CU.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: The control unit for the processor
*  
* Change history: 19/06/19 - created in lab  
*                 01/07/19 - edited the control signals and added more control signals
*                 02/07/19 - edited the control signals when testing / fixed typos
                           - found errors, and fixing them
*  **********************************************************************/ 

module CU(
input[4:0] opcode,
input func7, 
input [2:0] func3, 
output reg branch, memread, memwrite, alusrc, regwrite, pcselect, auipcselect,
output reg [1:0] memtoreg,
output reg [3:0] aluselect
);

    always @(*) 
    begin 
    case (opcode)
        
        //R-format
        5'b01100 : 
        begin
            branch <= 0;
            memread <= 0;
            memwrite <= 0;
            alusrc <= 0;
            regwrite <=1;
            memtoreg <= 00;
            pcselect <= 0;
            auipcselect <= 0; 
            
            if(func3== 3'b000)
            begin 
                if(func7 == 0)
                    aluselect = 4'b0010;
            else 
                    aluselect = 4'b0110;
            end
           
    
            //SLT
            if(func3 == 3'b010)
                    aluselect = 4'b1000;
            //SLTU 
            if(func3 == 3'b011)
                    aluselect = 4'b1001;
            //XOR
            if(func3 == 3'b100)
                    aluselect = 4'b0011;
            
            //OR
            if(func3 == 3'b110)
                    aluselect = 4'b0001; 
            
            //AND
            if(func3 == 3'b111)
            begin
                    aluselect = 4'b0000;
            end    
            
            //SRL and SRA
            if(func3 == 3'b101)
            begin 
                //SRL
                if(func7 == 0)
                  aluselect = 4'b0100;
                else
                //SRA
                aluselect = 4'b0101; 
            end
            
            //SLL
            if(func3 == 3'b001)
                aluselect = 4'b0111;
end

        
        //Load
        5'b00000 : 
         begin
            branch <= 0;
            memread <= 1;
            aluselect <= 4'b0010;
            memwrite <= 0;
            alusrc <= 1;
            regwrite <=1;
            memtoreg <= 01;
            pcselect <= 0;
            auipcselect <= 0;
            
        end
        
        //S format
        5'b01000 : 
         begin
           branch <= 0;
           memread <= 0;
           aluselect <= 4'b0010;
           memwrite <= 1;
           alusrc <= 1;
           regwrite <=0;
           memtoreg <= 00;
           pcselect <= 0;
           auipcselect <= 0;
           
         end
        
        //SB format
        5'b11000 :
        begin
           branch <= 1;
           memread <= 0;
           aluselect <= 4'b0110;
           memwrite <= 0;
           alusrc <= 0;
           regwrite <=0;
           memtoreg <= 00;
           pcselect <= 0;
           auipcselect <= 0;
           
         end
        
           // I format 
           5'b00100 :
           begin
              branch <= 0;
              memread <= 0;
              memwrite <= 0;
              alusrc <= 1;
              regwrite <= 1;
              memtoreg <= 00;
              pcselect <= 0;
              auipcselect <= 0;
              
 
              //ADDI
              if(func3 == 3'b000)
                  aluselect = 4'b0010;
                  
                //SLLI
                if(func3 == 3'b001)
                    aluselect = 4'b0111;
         
              //SLTI
              if(func3 == 3'b010)
                  aluselect = 4'b1000;
                  
              //SLTIU
              if(func3 == 3'b011)
                  aluselect = 4'b1001;
                  
              //XORI
              if(func3 == 3'b100)
                  aluselect = 4'b0011;
                  
              //ORI
              if(func3 == 3'b110)
                  aluselect = 4'b0001;
                  
            //Shift Immediates 
            if(func3 == 3'b101)
            begin 
                if(func7 == 1'b1)
                //SRAI
                    aluselect = 4'b0101; 
                else
                //SRLI
                    aluselect = 4'b0100; 
            end
              //ANDI
              if(func3 == 3'b111)
                  aluselect = 4'b0000;
                  

            end
            
            //U format (lui)
            5'b01101:
            begin
                branch <= 0;
                memread <= 0;
                aluselect = 4'b1010; 
                memwrite <= 0;
                alusrc <= 1;
                regwrite <= 1;
                memtoreg <= 00;
                pcselect <= 0;
                auipcselect <= 0;
                
            end 
            
            //UJ format (jal)
            5'b11011:
            begin
              branch <= 0;
              memread <= 0;
              aluselect = 4'b0010;
              memwrite <= 0;
              alusrc <= 1;
              regwrite <= 1;
              memtoreg <= 11;
              pcselect <= 1;
              auipcselect <= 1;
              
            end
            
            //jalr
            5'b11001:
            begin
                branch <= 0;
                memread <= 0;
                aluselect = 4'b0010;
                memwrite <= 0;
                alusrc <= 1;
                regwrite <= 1;
                memtoreg <= 11;
                pcselect <= 1;
                auipcselect <= 0;
            end
            
            //auipc
            5'b00101:
            begin
                branch <= 0;
                memread <= 0;
                aluselect = 4'b0010;
                memwrite <= 0;
                alusrc <= 1;
                regwrite <= 1;
                memtoreg <= 00;
                pcselect <= 0;
                auipcselect <= 1;
            end
            
            
        default: 
        begin
           branch <= 0;
           memread <= 0;
           aluselect = 4'b1010;
           memwrite <= 0;
           alusrc <= 0;
           regwrite <=0;
           memtoreg <= 00;
           pcselect <= 0;
           auipcselect <= 0;
           
         end
     endcase
     end
endmodule
