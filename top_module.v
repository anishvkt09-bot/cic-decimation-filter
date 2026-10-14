`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2026 14:27:46
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   enable,
    input  wire signed [1:0]      data_in,
    output wire signed [37:0]     data_out,
    output wire                   outready
);

    
    wire signed [37:0] acc_to_comb;
    wire               sample_flag;

    // 1. Integrator block
    integrator u_integrator (
        .clk      (clk),
        .reset    (reset),
        .enable   (enable),
        .data_in  (data_in),
        .data_out (acc_to_comb)
    );

    // 2. Rate generator (decimation strobe)
    counter u_counter (
        .clk      (clk),
        .reset    (reset),
        .enable   (enable),
        .flag     (sample_flag)
    );

    // 3. Comb block
    comb u_comb (
        .clk      (clk),
        .reset    (reset),
        .flag     (sample_flag),
        .data_in  (acc_to_comb),
        .data_out (data_out),
        .outready (outready)
    );

endmodule
