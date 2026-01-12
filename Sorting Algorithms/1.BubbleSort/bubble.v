module bubble #(parameter N = 5, parameter width = 8)(
    input clk, rst, start,
    output reg done
);
    reg [width-1:0] A [0:N-1];
    reg [2:0] i, j; // 3-bit for N=5

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            i <= 0; j <= 0; done <= 0;
        end else if (start && !done) begin
            if (i < N-1) begin
                if (j < N-1-i) begin
                    if (A[j] > A[j+1]) begin // > for Ascending
                        A[j]   <= A[j+1];
                        A[j+1] <= A[j]; // Swap works via non-blocking
                    end
                    j <= j + 1;
                end else begin
                    j <= 0;
                    i <= i + 1;
                end
            end else done <= 1;
        end
    end
endmodule