`timescale 1ns/1ps

module t_bubble;
    reg clk, rst, start;
    wire done;

    bubble #(.N(5), .width(8)) uut (
        .clk(clk), .rst(rst), .start(start), .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, t_bubble);
        $dumpvars(0, uut.A[0], uut.A[1], uut.A[2], uut.A[3], uut.A[4]);
        
        clk = 0; rst = 1; start = 0;
        
        uut.A[0] = 8'd5;
        uut.A[1] = 8'd12;
        uut.A[2] = 8'd3;
        uut.A[3] = 8'd8;
        uut.A[4] = 8'd1;

        #20 rst = 0; 
        #10 start = 1;

        wait(done);
        #20;
        $finish;
    end
endmodule