module priority_coder (
    input a1,
    input a2,
    input a3,
    input a4,
    output x, 
    output y
);
    assign x =  a4 | a3;
    assign y = ((~a3)& a2) | a4;
endmodule