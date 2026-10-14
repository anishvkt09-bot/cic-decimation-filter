`timescale 1ns / 1ps

module comb (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   flag,
    input  wire signed [37:0]     data_in,
    output reg  signed [37:0]     data_out,
    output reg                    outready
);

    reg signed [37:0] prev [0:3];
    reg signed [37:0] diff [0:3];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prev[0]  <= 38'sd0;
            prev[1]  <= 38'sd0;
            prev[2]  <= 38'sd0;
            prev[3]  <= 38'sd0;
            diff[0]  <= 38'sd0;
            diff[1]  <= 38'sd0;
            diff[2]  <= 38'sd0;
            diff[3]  <= 38'sd0;
            data_out <= 38'sd0;
            outready <= 1'b0;
        end 
        else if (flag) begin
            // Stage 0
            diff[0] <= data_in - prev[0];
            prev[0] <= data_in;

            // Stage 1
            diff[1] <= diff[0] - prev[1];
            prev[1] <= diff[0];

            // Stage 2
            diff[2] <= diff[1] - prev[2];
            prev[2] <= diff[1];

            // Stage 3
            diff[3] <= diff[2] - prev[3];
            prev[3] <= diff[2];

            data_out <= diff[3];
            outready <= 1'b1;
        end 
        
        else outready <= 1'b0;
        
    end

endmodule