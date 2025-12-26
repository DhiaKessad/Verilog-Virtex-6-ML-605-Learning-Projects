module substractor (
    input a,
    input b,
    output d,
    output bin
);
	 assign not_a = ~a;
    assign d = a ^ b; // sum output
    assign bin = not_a & b; // carry output
endmodule