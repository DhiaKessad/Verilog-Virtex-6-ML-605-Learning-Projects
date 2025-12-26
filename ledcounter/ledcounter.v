module ledcounter(
    input wire clkp, // Differential clock positive
    input clkn, // wire is optional for continuous blocks
    input reset, // Asynchronous reset Negative
    input sw_ud, // Switch Up/Down
    input sw_pr, // Switch pause/run
    input sw_lr,// Switch Left/Right will be added later
    input sw_sf, // Switch slow/fast (Register)
    output wire [7:0] led
);
    //clock signal
    wire sys_clk;
    reg [27:0] clkdiv; // slowing down 200mhz 
    reg [7:0] ledreg; // 8 bit register for leds
    reg       tic; // universal clk for the system

    //clock buffer for the fpga two diff
    IBUFGDS #(
        .DIFF_TERM("FALSE"), 
        .IOSTANDARD("LVDS_25")
    )ibufgds_inst(
        .I(clkp),
        .IB(clkn),
        .O(sys_clk)
    );

    //clock divider slowing down
    always @(posedge sys_clk or posedge reset) begin
        if (reset) begin // reset
            clkdiv <= 28'd0;
            tic <= 1'b0;
        end else begin
        if (clkdiv >= (sw_sf ? 28'd20_000_000 : 28'd100_000_000)) begin
            clkdiv <= 28'd0;
            tic <= 1'b1;
        end else begin 
            clkdiv <= clkdiv + 1'b1;
                tic <= 1'b0;
        end
        end
    end
    
    always @(posedge sys_clk or posedge reset) begin
         if (reset) begin
             ledreg <= 8'd0;
         end else if (tic && !sw_pr) begin 
         if (sw_ud)
                ledreg <= ledreg + 1'b1;
            else
                ledreg <= ledreg - 1'b1;
        end
        end

        // reverse leds ledrev
        wire [7:0] ledrev;
        genvar i;
        generate
        for (i = 0; i < 8; i = i + 1)
           assign ledrev[i] = ledreg[7 - i];
        endgenerate

     assign led = sw_lr ? ledreg : ledrev;

endmodule