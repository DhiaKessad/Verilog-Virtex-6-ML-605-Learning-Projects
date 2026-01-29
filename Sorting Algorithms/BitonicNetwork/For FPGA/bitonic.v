module bitonic #(parameter WIDTH = 8) (
    input  [WIDTH*8-1:0] data_in,
    input                asc_mode, // 1 for Smallest->Biggest, 0 for Biggest->Smallest
    output [WIDTH*8-1:0] data_out
);
    wire [WIDTH-1:0] x [0:7];
    wire [WIDTH-1:0] s1 [0:7], s2 [0:7], s3 [0:7], s4 [0:7], s5 [0:7];
    wire [WIDTH-1:0] y [0:7];
    
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : unpack
            assign x[i] = data_in[WIDTH*(i+1)-1 : WIDTH*i];
            assign data_out[WIDTH*(i+1)-1 : WIDTH*i] = y[i];
        end
    endgenerate

    // STAGE 1
    compare_swap #(WIDTH) cs1_0(x[0], x[1], asc_mode,  s1[0], s1[1]);
    compare_swap #(WIDTH) cs1_1(x[2], x[3], !asc_mode, s1[2], s1[3]);
    compare_swap #(WIDTH) cs1_2(x[4], x[5], asc_mode,  s1[4], s1[5]);
    compare_swap #(WIDTH) cs1_3(x[6], x[7], !asc_mode, s1[6], s1[7]);

    // STAGE 2
    compare_swap #(WIDTH) cs2_0(s1[0], s1[2], asc_mode,  s2[0], s2[2]);
    compare_swap #(WIDTH) cs2_1(s1[1], s1[3], asc_mode,  s2[1], s2[3]);
    compare_swap #(WIDTH) cs2_2(s1[4], s1[6], !asc_mode, s2[4], s2[6]);
    compare_swap #(WIDTH) cs2_3(s1[5], s1[7], !asc_mode, s2[5], s2[7]);
    
    compare_swap #(WIDTH) cs2_4(s2[0], s2[1], asc_mode,  s3[0], s3[1]);
    compare_swap #(WIDTH) cs2_5(s2[2], s2[3], asc_mode,  s3[2], s3[3]);
    compare_swap #(WIDTH) cs2_6(s2[4], s2[5], !asc_mode, s3[4], s3[5]);
    compare_swap #(WIDTH) cs2_7(s2[6], s2[7], !asc_mode, s3[6], s3[7]);

    // STAGE 3
    compare_swap #(WIDTH) cs3_0(s3[0], s3[4], asc_mode, s4[0], s4[4]);
    compare_swap #(WIDTH) cs3_1(s3[1], s3[5], asc_mode, s4[1], s4[5]);
    compare_swap #(WIDTH) cs3_2(s3[2], s3[6], asc_mode, s4[2], s4[6]);
    compare_swap #(WIDTH) cs3_3(s3[3], s3[7], asc_mode, s4[3], s4[7]);
    
    compare_swap #(WIDTH) cs3_4(s4[0], s4[2], asc_mode, s5[0], s5[2]);
    compare_swap #(WIDTH) cs3_5(s4[1], s4[3], asc_mode, s5[1], s5[3]);
    compare_swap #(WIDTH) cs3_6(s4[4], s4[6], asc_mode, s5[4], s5[6]);
    compare_swap #(WIDTH) cs3_7(s4[5], s4[7], asc_mode, s5[5], s5[7]);
    
    compare_swap #(WIDTH) cs3_8(s5[0], s5[1], asc_mode, y[0], y[1]);
    compare_swap #(WIDTH) cs3_9(s5[2], s5[3], asc_mode, y[2], y[3]);
    compare_swap #(WIDTH) cs3_10(s5[4], s5[5], asc_mode, y[4], y[5]);
    compare_swap #(WIDTH) cs3_11(s5[6], s5[7], asc_mode, y[6], y[7]);

endmodule

module compare_swap #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in0, in1,
    input              asc, 
    output [WIDTH-1:0] out0, out1
);
    assign out0 = (asc) ? ((in0 <= in1) ? in0 : in1) : ((in0 >= in1) ? in0 : in1);
    assign out1 = (asc) ? ((in0 <= in1) ? in1 : in0) : ((in0 >= in1) ? in1 : in0);
endmodule