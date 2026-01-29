`timescale 1ns/1ps

module tb_bitonic_sort;
    parameter WIDTH = 8;
    reg [WIDTH*8-1:0] data_in;
    wire [WIDTH*8-1:0] data_out;

    bitonic #(WIDTH) dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    integer i;
    initial begin $dumpfile("wave.vcd");
     $dumpvars(0, tb_bitonic_sort); end

    initial begin
        data_in = {8'd10, 8'd2, 8'd45, 8'd1, 8'd99, 8'd15, 8'd0, 8'd33};
        #10;
        $display("--- Test Case 1 (Random) ---");
        $write("Input:  ");
        for (i=0; i<8; i=i+1) $write("%d ", data_in[WIDTH*(i+1)-1 -: WIDTH]);
        $write("\nOutput: ");
        for (i=0; i<8; i=i+1) $write("%d ", data_out[WIDTH*(i+1)-1 -: WIDTH]);
        $display("\n");

        // Test Case 2: Reverse order
        data_in = {8'd80, 8'd70, 8'd60, 8'd50, 8'd40, 8'd99, 8'd20, 8'd10};
        #10;
        $display("--- Test Case 2 (Reverse) ---");
        $write("Input:  ");
        for (i=0; i<8; i=i+1) $write("%d ", data_in[WIDTH*(i+1)-1 -: WIDTH]);
        $write("\nOutput: ");
        for (i=0; i<8; i=i+1) $write("%d ", data_out[WIDTH*(i+1)-1 -: WIDTH]);
        $display("\n");

        $finish;
    end

endmodule