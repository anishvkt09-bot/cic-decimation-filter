`timescale 1ns / 1ps

module integrator (
    input  wire                   clk,
    input  wire                   reset,
    input  wire                   enable,
    input  wire signed [1:0]      data_in,
    output wire signed [37:0]     data_out
);

    reg signed [37:0] acc [0:3];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc[0] <= 38'sd0;
            acc[1] <= 38'sd0;
            acc[2] <= 38'sd0;
            acc[3] <= 38'sd0;
        end 
        else if (enable) begin
            acc[0] <= acc[0] + {{36{data_in[1]}}, data_in};
            acc[1] <= acc[1] + acc[0];
            acc[2] <= acc[2] + acc[1];
            acc[3] <= acc[3] + acc[2];
        end
    end

    // OUTPUT
    assign data_out = acc[3];

endmodule