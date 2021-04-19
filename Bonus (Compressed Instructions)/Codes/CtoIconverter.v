`timescale 1ns / 1ps
/*******************************************************************  
*  
* Module: CtoIconverter.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: This module converts the compressed instruction to Integer format
*  
* Change history: 11/7/19 - created
*  **********************************************************************/ 

module CtoIconverter(
input [31:0] inst,
output reg [31:0] Iinst,
output reg cflag
    );
   
    wire [1:0] base; 
    wire [4:0] rdtemp;
    wire [4:0] rstemp;
    wire [11:0] immtemp;
    
    assign base = inst [1:0];
    
    assign rdtemp = inst[4:2] + 8;
    assign rstemp = inst[9:7] + 8;
    assign immtemp = {5'b0,inst[5],inst[12:10],inst[6],2'b0};

    initial begin
    cflag =0;
    end
    
    
    always @(*)
    begin
    
            case (base)
              2'b00:
                begin
                    cflag = 1;
                    
                    if(inst[15:13]== 3'b000)
                    Iinst = {2'b0,inst[10:7],inst[12:11],inst[5],inst[6],2'b0, 5'b0, 3'b000,rdtemp,7'b0010011};
                    else if(inst[15:13]== 3'b010)//lw
                    Iinst = {immtemp,rstemp,3'b010,rdtemp,7'b0000011};
                    else //sw
                    Iinst = {5'b0,inst[5],inst[12:11],rstemp,rdtemp,3'b010,inst[10],inst[6],2'b0,7'b0100011};
                    
                end
              2'b01:
                begin
                                  cflag = 1;
                                  
                        if(inst[15:13] == 3'b111)//bnez
                        Iinst = {1'b0,2'b0,inst[12],inst[6:5],inst[2],rstemp,5'b00000,3'b001,inst[11:10],inst[4:3],1'b0,7'b1100011};
                        else if(inst[15:13] == 3'b110)//bnez
                        Iinst = {1'b0,2'b0,inst[12],inst[6:5],inst[2],rstemp,5'b00000,3'b000,inst[11:10],inst[4:3],1'b0,7'b1100011};
                        else if(inst[15:13] == 3'b001) // jal
                        Iinst = {1'b0,inst[9],inst[11:10],inst[7],inst[8],inst[2],inst[12],inst[6:3],8'b0,5'b00001,7'b1101111};
                        else if(inst[15:13] == 3'b000)
                            begin
                            if(inst[11:7] ==0) // NOP
                            Iinst = {7'b0,5'b0, 5'b0, 3'b000,5'b0,7'b0010011};
                            else   //addi
                            Iinst = {6'b0,inst[12],inst[6:2], inst[11:7], 3'b000,inst[11:7],7'b0010011};                 
                            end
                        else if(inst[15:13] == 3'b010) // li
                        Iinst = {6'b0,inst[12],inst[6:2], 5'b0, 3'b000,inst[11:7],7'b0010011};
                        else if(inst[15:13] == 3'b011) // lui
                        Iinst = {inst[17],inst[6:2],inst[11:7],7'b0110111};
                        else if(inst[15:13] == 3'b100) // srli
                                if(inst[11:10] == 2'b00)
                                    Iinst = {7'b0,inst[6:2],rstemp,3'b111,rstemp,7'b0010011};
                                else if(inst[11:10] == 2'b01)     // srai
                                    Iinst = {7'b0100000,inst[6:2],rstemp,3'b101,rstemp,7'b0010011};
                                else if(inst[11:10] == 2'b10)   // andi
                                    Iinst = {6'b0,inst[12],inst[6:2],rstemp,3'b111,rstemp,7'b0010011};
                                else
                                begin
                                if(inst[6:5]== 2'b00)
                                    // sub
                                    Iinst = {7'b0100000,rdtemp,rstemp,3'b000,rstemp,7'b0110011};
                                else if(inst[6:5]== 2'b01)
                                    // xor
                                    Iinst = {7'b0,rdtemp,rstemp,3'b100,rstemp,7'b0110011};
                                else if(inst[6:5]== 2'b10)
                                    // or
                                    Iinst = {7'b0,rdtemp,rstemp,3'b110,rstemp,7'b0110011};
                                else
                                    // and
                                    Iinst = {7'b0,rdtemp,rstemp,3'b111,rstemp,7'b0110011};
                                  end
                                              
                end
              2'b10:
                begin                                  
                cflag = 1;

                        if(inst[15:13] == 000) //slli
                        Iinst = {7'b0,inst[6:2],inst[11:7],3'b001,inst[11:7],7'b0010011};
                        else if(inst[15:13] == 010) //lwsp
                        
                        Iinst = {4'b0,inst[3:2],inst[12],inst[6:4],2'b0,5'b00010,3'b010,inst[11:7],7'b0000011};
                        else if(inst[15:13] == 110) //swsp
                      
                        Iinst = {4'b0,inst[8:7],inst[12],inst[6:2],5'b00010,3'b010,inst[11:9],2'b0,7'b0100011};
                        else
                            begin
                            if(inst[6:2] == 0)
                                if(inst[11:7] == 0) //ebreak
                                    Iinst = {25'b0,7'b1110011};
                                else //jalr
                                Iinst = {12'b0,inst[11:7],3'b000,5'b00001,7'b1100111};
                            else //add
                             Iinst = {7'b0,inst[6:2],inst[11:7],3'b000,inst[11:7],7'b0110011};
                            end           
                end
              2'b11: 
                begin
                Iinst = {16'b0,inst};
                cflag = 0;  
                end
              default:
              cflag = 0; 
            endcase
    end
    
endmodule
