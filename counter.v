`timescale 1ns / 1ps

module counter (
    input  wire clk,
    input  wire reset,
    input  wire enable,
    output reg  flag
);

    reg [8:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 9'd0;
            flag  <= 1'b0;
        end 
        else if (enable) begin
            if (count == 9'd511) begin
                count <= 9'd0;
                flag  <= 1'b1;  
            end else begin
                count <= count + 1'b1;
                flag  <= 1'b0;
            end
        end
        
         else flag <= 1'b0;
         
    end
    
endmodule // flag = 1 for every 512 cycles 