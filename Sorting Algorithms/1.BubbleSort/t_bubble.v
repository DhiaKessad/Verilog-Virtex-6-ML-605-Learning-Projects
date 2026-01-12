`timescale 1ns/1ps
module t_bubble;
   reg clk, start, rst, A, i, j, temp;

   bubble uut(
    .clk(clk),
    .start(start),
    .rst(rst),
    .A(A),
    .i(i),
    .j(j),
    .temp(temp)
   );

    intial begin
    $dumpfile("waveform");
    $dumpvars(0, t_bubble);

    