module pwm(
    input wire clkp,
    input wire clkn,
    input reset,
    output wire [7:0] led
);

    //Setting up the system clock
    wire sys_clk;
    IBUFGDS #(
        .DIFF_TERM("FALSE"), 
        .IOSTANDARD("LVDS_25")
    )ibufgds_inst(
        .I(clkp),
        .IB(clkn),
        .O(sys_clk)
    );

    reg [7:0] pwm_count ;
    reg [7:0] brightness ;
    reg [20:0] breathe_div;
    reg [7:0] count;

    always @(posedge sys_clk or posedge reset) begin
    if (reset)
        pwm_count <= 0;
    else
        pwm_count <= pwm_count + 1;
    end

    always @(posedge sys_clk or posedge reset) begin
    if (reset) begin
        count <= 8'd1; 
    end else begin
        if (brightness == 255) 
            count <= -1; 
        else if (brightness == 0) 
            count <= 1;  
    end
    end

    always @(posedge sys_clk or posedge reset) begin
        if (reset) begin
            brightness <= 0;
            breathe_div <= 0;
        end else begin
         breathe_div <= breathe_div + 1;
        if (breathe_div == 0) begin
          brightness <= brightness + count; // getting brighter
        end
    end
    end

    assign led[0] = (pwm_count < brightness);
    assign led[1] = (pwm_count +30 < brightness);
    assign led[2] = (pwm_count +60 < brightness);
    assign led[3] = (pwm_count +90 < brightness);
    assign led[4] = (pwm_count + 120 < brightness);
    assign led[5] = (pwm_count + 150 < brightness);
    assign led[6] = (pwm_count + 180 < brightness);
    assign led[7] = (pwm_count + 210 < brightness);


endmodule