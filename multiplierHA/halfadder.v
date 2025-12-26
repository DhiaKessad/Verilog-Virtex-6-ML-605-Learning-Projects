module halfadder (
    input a,
    input b,
    output s,
    output c
);
    assign s = a ^ b; // sum output
    assign c = a & b; // carry output
endmodule
