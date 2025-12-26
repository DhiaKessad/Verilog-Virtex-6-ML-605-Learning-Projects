module multiplier(
    input a0,
    input a1,
    input b0,
    input b1,
    output q0,
    output q1,
    output q2,
    output q3
);
  wire w1;
  wire w2;
  wire w3;
  wire w4;

assign q0 = a0 & b0;  //first output
assign w1 = a0 & b1; 
assign w2 = a1 & b0;
assign w3 = a1 & b1;

// calling the first HA block
  halfadder HA1 (
    .a(w1),
    .b(w2),
    .s(q1), // second output
    .c(w4)
  );
  halfadder HA2 (
    .a(w4),
    .b(w3),
    .s(q2), // third output
    .c(q3) // fourth output
  );

endmodule 

