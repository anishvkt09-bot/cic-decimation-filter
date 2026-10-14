`timescale 1ns / 1ps

module cic_tb();
    
    reg data [0:4096025];
    
    reg clk, clk2, clk3, clk4, reset, enable;
    wire outready, outready2;
    
    reg signed [1:0] bits;
    
    
    wire signed [37:0] cicout;
    wire signed [92:0] firout;
    
    initial begin
        // Select input test vector: "hz10.mem", "hz500.mem", or "hz990.mem"
        $readmemh("hz500.mem", data); 
    end

    initial begin
        clk = 0;
        clk2 = 0;
        clk3 = 0;
        bits = 0;
        enable = 0;
        reset = 1;
        #51 reset = 0;
        enable = 1;
    end

    // Clock generation
    always #50 clk = ~clk;            // Sampling clock (fs)
    always #25600 clk2 = ~clk2;
    always #102400 clk3 = ~clk3;       // Decimated clock
    
    integer i;
    initial i = 0;
    
    integer fd1, fd2, fd3, fd4;
    initial begin
        fd1 = $fopen("bits.txt", "w");
        fd2 = $fopen("cic_out_full.txt", "w");
        fd3 = $fopen("fircomp.txt", "w");
        fd4 = $fopen("cic512_out_20bit.txt", "w"); // Decimated 20-bit output for MATLAB PSD analysis
    end

    always @(posedge clk) begin
        if (i < 4096026) begin
            if (i % 2 == 0) begin
                bits = {1'b0, data[i]};
            end else begin
                bits = {2{data[i]}};
            end
            i <= i + 1;
        end else begin
            $fclose(fd1);
            $fclose(fd2);
            $fclose(fd3);
            $fclose(fd4);
            #200;
            $finish;
        end
    end

    always @(posedge clk) begin
        $fwrite(fd1, "%d\n", bits); 
    end

    always @(posedge clk) begin
        if (outready) begin
            
            $fwrite(fd2, "%d\n", $signed(cicout[37:18]));
        end
    end

    always @(posedge clk2) begin
        $fwrite(fd3, "%d\n", $signed(firout));
    end

    always @(posedge clk3) begin
        
        $fwrite(fd4, "%d\n", $signed(cicout[37:18]));
    end

    // Top module instantiation
    top_module uut (
        .clk      (clk),
        .reset    (reset),
        .enable   (enable),
        .data_in  (bits),
        .data_out (cicout),
        .outready (outready)
    );
    
endmodule
