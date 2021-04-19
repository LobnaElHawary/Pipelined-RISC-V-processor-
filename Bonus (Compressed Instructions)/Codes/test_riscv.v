`timescale 1ns / 1ps

/*******************************************************************  
*  
* Module: IntMem.v  
* Project: SSRisc  
* Author: Mariane, Shahd, Lobna 
* Description: A test bench to test that the RISC-V processor is working as expected
*  
* Change history: 02/07/19 11:45:01 AM - created file
*                          12:00 - debugged and finished files
*  **********************************************************************/ 


module test_riscv();
reg risc_clk, rst; 

 RISC_V risc(.risc_clk(risc_clk), .rst(rst));
 
    initial begin
        rst = 1;
        risc_clk = 0;

        #10 rst = 0;

    end 
    
    always #50 risc_clk = !risc_clk;

endmodule
