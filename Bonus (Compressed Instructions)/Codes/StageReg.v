// file: StageReg.v, previously RegWLoad.v
// author: @cherifsalama

`timescale 1ns/1ns

module StageReg(
    clk,
    rst,
    load,
    data_in, 
    data_out 
);

    parameter SIZE=32;

    input clk, rst, load;
    input [SIZE-1:0] data_in; 
    output [SIZE-1:0] data_out;
    
    wire [SIZE-1:0] ds;

    genvar i;
    generate
    for(i=0;i<SIZE;i=i+1) begin
        Mux2_1 m (load,data_out[i],data_in[i],ds[i]);
        flipflop f(clk,rst,ds[i],data_out[i]);
    end
    endgenerate

endmodule
