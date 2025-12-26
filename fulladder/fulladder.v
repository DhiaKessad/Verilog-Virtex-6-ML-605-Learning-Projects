module fulladder (
    input a,
    input b,
    input carry_in,
    output cout, 
    output sum
);
    // Carry Out Logic
    assign cout = (a & b) | (carry_in & (a ^ b)); 
    // Sum Logic
    assign sum = (a ^ b) ^ carry_in;
endmodule