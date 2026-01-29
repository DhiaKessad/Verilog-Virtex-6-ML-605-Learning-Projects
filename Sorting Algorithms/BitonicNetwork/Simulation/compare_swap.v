module compare_swap #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in0, in1,
    input              asc, 
    output [WIDTH-1:0] out0, out1
);
    assign out0 = (asc) ? ((in0 <= in1) ? in0 : in1) : ((in0 >= in1) ? in0 : in1);
    assign out1 = (asc) ? ((in0 <= in1) ? in1 : in0) : ((in0 >= in1) ? in1 : in0);
endmodule