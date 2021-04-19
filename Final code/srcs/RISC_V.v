`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: RISC_V.v  
* Project: SSRisc  
* Author: Lobna 
* Description: This is the main module for the processor. It instantiates all the modules and conncets them together.  
*  
* Change history: 01/07/19 - Wrote the module 
*                 02/07/19 - edited when testing to fix a few errors.  
                  06/07/19 - added the pipelined implementation to previous code
                  07/07/19 - debugging the module 
                  08/07/19 - bugging and changing the memory into 1 single memory 
                  09/07/19 - debugging 
                  10/07/19 - debugging 
*  **********************************************************************/ 

module RISC_V (input risc_clk,
   input rst,
   input [1:0] ledSel, 
   input [3:0] ssdSel,
   output reg [15:0] leds, 
   output reg [12:0] ssd
);


        //memory 
   wire [31:0] memory_address, memoryout; 
        //clks
    wire nothalfclk, halfclk;
        //IF vars 
    wire[31:0]  PCin, PC, IF_ID_inst_input, IF_ID_PCplus4_input, IF_ID_PCplus4_output;
    reg load;
    
        //ID vars 
    wire [31:0] target, ID_EX_readdata1_input,ID_EX_readdata2_input, ID_EX_immediate_input, IF_ID_inst_output, IF_ID_PC_output, EX_MEM_immediate_output;
    
            //controls 
    wire [12:0] ID_EX_cntrl_input;
    wire [3:0] aluselect;
    wire [1:0] memtoreg, fourteen_and_twelve;
    wire branch, memread, memwrite, alusrc, regwrite, pcselect, auipcselect;
    
    
        //EXE vars
    
    wire [31:0] ID_EX_readdata1_output, ID_EX_readdata2_output, ID_EX_immediate_output, EX_MEM_aluresult_input;
    wire [31:0] EX_MEM_muxb_input, alusrc_A, alusrc_B, ID_EX_PC_output, muxa_output, ID_EX_PCplus4_output;
    wire [12:0] ID_EX_cntrl_output, EX_stage_select;
    wire [4:0] ID_EX_rs1 , ID_EX_rs2, ID_EX_rd_output;
    wire [2:0] ID_EX_func3_output;
    wire  PCsrc,EX_MEM_Bflag_input;
    wire  Forwarding_MUX_A, Forwarding_MUX_B; 
    
        //MEM vars
   
   wire [31:0] EX_MEM_aluresult_output, EX_MEM_muxb_output, EM_MEM_PCplus4_output; 
   wire [6:0] EX_MEM_cntrl_output;
   wire [4:0] EX_MEM_rd_output; 
   wire [2:0] EX_MEM_func3_output;
   wire EX_MEM_Bflag_output;
   
        //WB vars 
   
   wire [31:0] MEM_WB_readdata_output, MEM_WB_aluresult_output, writedata, MEM_WB_PCplus4_output;
   wire [4:0] MEM_WB_rd_output;
   wire [2:0] MEM_WB_cntrl_output;
   wire [1:0] PCmux_sel; 
    
/************************************ Clocks  *******************************************/
  clock_divider cd(.clk(risc_clk) ,.out_clk(halfclk));
   assign nothalfclk = ~halfclk;
/************************************ State Registers  ************************************/
    
    // pc(32) + Inst(32) + PC+4 (32)
    StageReg #(96) IF_ID (nothalfclk,rst,1'b1, 
        //input 
    {PC,IF_ID_inst_input, IF_ID_PCplus4_input}
        //output  
    ,{IF_ID_PC_output, IF_ID_inst_output, IF_ID_PCplus4_output});
    
    
    //controls(13) + PC (32) + readdata1(32) + readdata2 (32) + imm(32) + rs1 (5) + rs2 (5) + inst[11-17]/rd (5) + funct3 (3) + PCplus4 (32)
    StageReg #(191) ID_EX (halfclk,rst,1'b1,
        
    {ID_EX_cntrl_input, IF_ID_PC_output, ID_EX_readdata1_input, ID_EX_readdata2_input, ID_EX_immediate_input,
    IF_ID_inst_output[19:15],IF_ID_inst_output[24:20], IF_ID_inst_output[11:7], IF_ID_inst_output[14:12], IF_ID_PCplus4_output }
     
    ,{ID_EX_cntrl_output,ID_EX_PC_output,ID_EX_readdata1_output,ID_EX_readdata2_output,
     ID_EX_immediate_output, ID_EX_rs1, ID_EX_rs2, ID_EX_rd_output, ID_EX_func3_output, ID_EX_PCplus4_output});
        //ID_EX_cntrl_output = branch (12), memread(11), memtoreg(10-9), aluselect(8-5), memwrite(4), alusrc(3), regwrite(2), pcselect (1), auipcselect(0)
        
       
        //controls (7) + comparator result (1) + aluresult (32) + muxb_input (32) + imm(32) + rd (5) + func3 (3) + PCplus4 (32)
    StageReg #(144) EX_MEM(nothalfclk,rst,1'b1,
    {EX_stage_select[12:9],EX_stage_select[4],EX_stage_select[2:1], EX_MEM_Bflag_input, EX_MEM_aluresult_input,
     EX_MEM_muxb_input, ID_EX_immediate_output, ID_EX_rd_output, ID_EX_func3_output, ID_EX_PCplus4_output},
    
    {EX_MEM_cntrl_output, EX_MEM_Bflag_output, EX_MEM_aluresult_output, EX_MEM_muxb_output,
     EX_MEM_immediate_output, EX_MEM_rd_output, EX_MEM_func3_output, EM_MEM_PCplus4_output});
        //EX_MEM_cntrl_output = branch(6), memread (5), memtoreg(4-3), memwrite(2), regwrite(1), pcselect(0)
    
        //controls (3) + readdata (32) + aluresult (32) + rd (5) + PCplus4 (32)
    StageReg #(104) MEM_WB(halfclk,rst,1'b1,
    {EX_MEM_cntrl_output[4:3], EX_MEM_cntrl_output[1], memoryout, EX_MEM_aluresult_output, EX_MEM_rd_output, EM_MEM_PCplus4_output },
    
    {MEM_WB_cntrl_output, MEM_WB_readdata_output, MEM_WB_aluresult_output, MEM_WB_rd_output, MEM_WB_PCplus4_output});
        //MEM_WB_cntrl = memtoreg (2-1), regwrite (0)
        
/************************************ Memory  ************************************/ 
 Mux2_1 #(32) addr_mux(.sel(halfclk),.in1(EX_MEM_aluresult_output),.in2(PC),.out(memory_address));

 Memory m(.clk(halfclk),.func3(EX_MEM_func3_output),.MemRead(EX_MEM_cntrl_output[5]), .MemWrite(EX_MEM_cntrl_output[2]),
 .addr(memory_address[5:0]),.data_in(EX_MEM_muxb_output), .data_out(memoryout));

/************************************ IF stage  ************************************/   

        //deciding the load
    always @(*)
        begin
            if(IF_ID_inst_output[6:0] == 7'b1110011)
                begin 
                     load = 1'b0;
                end
            else
                        load = 1'b1;
        end
                //obtaining PC 
    register32 PC_inst(.clk(halfclk), .rst(rst), .load(load),.Din(PCin),.Q(PC));
    
        //Adding 4 to PC 
    ADD_SUB add_four(.A(PC), .B(32'd4), .cin(1'b0), .sum(IF_ID_PCplus4_input), .cout());
    
    Mux2_1 #(32) inst_mux(.sel(PCsrc),.in1(memoryout),.in2(memoryout),.out(IF_ID_inst_input));
// {25'b0,7'b0110011}
/************************************ ID stage  ************************************/
      
        ///(ImmGen * 2) + PC or ImmGen + PC (Jal, Jalr)
        //note: CHANGE THIS 
   ADD_SUB immplusPC(.A(ID_EX_PC_output), .B(EX_MEM_immediate_output), .cin(1'b0), .sum(target), .cout());
  
  
        //control unit 
   CU control(.opcode(IF_ID_inst_output[6:2]),.func7(IF_ID_inst_output[30]),.func3(IF_ID_inst_output[14:12]),.branch(branch), .memread(memread), .memwrite(memwrite), .alusrc(alusrc), 
   .regwrite(regwrite), .pcselect(pcselect), .auipcselect(auipcselect),.memtoreg(memtoreg),.aluselect(aluselect));
   
        //chooses ID_EX_cntrl_input 
   Mux2_1 #(13) ID_cntrl_mux(.sel(PCsrc),.in1({branch, memread, memtoreg, aluselect, memwrite, alusrc, regwrite,pcselect, auipcselect}),
   .in2(13'b0),.out(ID_EX_cntrl_input)); 
     
        //register file 
  regfile reg_file(.clk(nothalfclk), .rst(rst), .writedata(writedata), .writereg(MEM_WB_rd_output), .readreg1(IF_ID_inst_output[19:15]), .readreg2(IF_ID_inst_output[24:20]),
  .regwrite(MEM_WB_cntrl_output[0]),.readdata1(ID_EX_readdata1_input),.readdata2(ID_EX_readdata2_input));  
  
        //ImmGen (also shifts)
    immgen imm(.IR(IF_ID_inst_output), .Imm(ID_EX_immediate_input));  
  

 /************************************ EX stage  ************************************/
 
  Mux2_1 #(13) FLUSH_mux(.sel(PCsrc|EX_MEM_cntrl_output[0]),.in1(ID_EX_cntrl_output),.in2(13'b0),.out(EX_stage_select));
 //EX_stage_select = branch (12), memread(11), memtoreg(10-9), aluselect(8-5), memwrite(4), alusrc(3), regwrite(2), pcselect (1), auipcselect(0)
 
 //comparator 
 
  assign fourteen_and_twelve = {ID_EX_func3_output[2], ID_EX_func3_output[0]};
  
  comparator c(.A(alusrc_A),.B(alusrc_B),.Control_line(fourteen_and_twelve), .sign(ID_EX_func3_output[1]),.Bflag(EX_MEM_Bflag_input));
  
        //forwarding unit  
 ForwardingUnit fu(.ID_EX_RS1(ID_EX_rs1),.ID_EX_RS2(ID_EX_rs2),.MEM_WB_regwrite(MEM_WB_cntrl_output[0]),.MEM_WB_output_rd(MEM_WB_rd_output), .Forwarding_MUX_A(Forwarding_MUX_A),.Forwarding_MUX_B(Forwarding_MUX_B));

            //ALU src MUXS
        
        //NOTE: fix in diagram that the select line of the MUXs is the output of forwarding unit
         
        //ALU MUX A
        Mux2_1 #(32) muxa(.sel(Forwarding_MUX_A),.in1(ID_EX_readdata1_output),.in2(writedata),.out(muxa_output));
        
        //2X1 MUX after MUX A
        Mux2_1 #(32) alusrca_mux(.sel(EX_stage_select[0]),.in1(muxa_output),.in2(ID_EX_PC_output),.out(alusrc_A));
        
        //ALU MUX B
        Mux2_1 #(32) muxb(.sel(Forwarding_MUX_B),.in1(ID_EX_readdata2_output),.in2(writedata),.out(EX_MEM_muxb_input));
        
        //2X1 MUX after MUX B
         Mux2_1 #(32) alusrcb_mux(.sel(EX_stage_select[3]),.in1(EX_MEM_muxb_input),.in2(ID_EX_immediate_output),.out(alusrc_B));
        
 
        //ALU 
 ALU alu(.A(alusrc_A),.B(alusrc_B),.ALU_cntrl(EX_stage_select[8:5]),.result(EX_MEM_aluresult_input));
 
 /************************************ MEM stage  ************************************/
 
        //*****NOTE: check the branch 
 AND b_and_c(.A(EX_MEM_Bflag_output),.B(EX_MEM_cntrl_output[6]), .out(PCsrc));
 
  assign PCmux_sel = {PCsrc, EX_MEM_cntrl_output[0]};

 
  /************************************ WB stage  ************************************/
        //write data 
        //NOTE: check the PCplus4
 MUX4x1 write_mux(.A(MEM_WB_aluresult_output),.B(MEM_WB_readdata_output),.C(),.D(MEM_WB_PCplus4_output),.select(MEM_WB_cntrl_output[2:1]),.c(writedata));
        
     //PC options EX_MEM_alyresult == imm + rs1 (jal)
 
 Mux4_1 #(32) PCselect_mux(.sel(PCmux_sel),.in1(IF_ID_PCplus4_input),.in2(EX_MEM_aluresult_output), .in3(target),.in4(),.out(PCin));
 
 /************************************* FPGA ********************************************/

 
    always @(*) begin
        case(ledSel)
            0: leds <= IF_ID_inst_input[31:16];
            1: leds <= IF_ID_inst_input[15:0];
            2: leds <= {branch, memread, memtoreg, aluselect, memwrite, alusrc, regwrite,pcselect, auipcselect};
            3: leds <= halfclk;
            default: leds <= 0;            
        endcase
        
        case(ssdSel)
            0: ssd <= PC[12:0];
            1: ssd <= memoryout[12:0]; 
            2: ssd <= EX_MEM_aluresult_input[12:0]; 
            4: ssd <= writedata[12:0];
            5: ssd <= alusrc_A[12:0]; 
            6: ssd <= alusrc_B[12:0]; 
            7: ssd <= PCin [12:0]; 
            
//            7: ssd <= writedata[12:0]; 
//            8: ssd <= ImmGen_out[12:0]; 
//            9: ssd <= Shift_out[12:0]; 
//            : ssd <= ALUSrcMux_out[12:0]; 
//            10: ssd <= ALU_out[12:0]; 
//            11: ssd <= Mem_out[12:0];
            default: ssd <= 0;
        endcase
    end

endmodule
