module lcd_controller (
    input  wire clk,
    input  wire rst,
    input  wire [63:0] unsorted_data,
    input  wire [63:0] sorted_data,
    output reg  LCD_RS,
    output wire LCD_RW,
    output reg  LCD_E,
    output reg  [3:0] LCD_DB
);
    assign LCD_RW = 1'b0;

    reg [15:0] timer = 0;
    reg ms_tick = 0;
    always @(posedge clk) begin
        if (timer == 50000) begin timer <= 0; ms_tick <= 1; end
        else begin timer <= timer + 1; ms_tick <= 0; end
    end

    reg [7:0] state = 0, wait_cnt = 0, char_idx = 0;
    reg [7:0] current_byte = 0, next_state = 0;

    function [7:0] to_ascii;
        input [3:0] nibble;
        to_ascii = (nibble < 10) ? (8'h30 + nibble) : (8'h37 + nibble);
    endfunction

    wire [3:0] u_nibble = unsorted_data[(15-char_idx)*4 +: 4];
    wire [3:0] s_nibble = sorted_data[(15-char_idx)*4 +: 4];

    always @(posedge clk) begin
        if (rst) begin state <= 0; wait_cnt <= 0; char_idx <= 0; end
        else if (ms_tick) begin
            case (state)
                0: if (wait_cnt < 20) wait_cnt <= wait_cnt + 1; else begin state <= 10; wait_cnt <= 0; end
                
                // Initialization
                10: begin LCD_RS <= 0; LCD_DB <= 4'h3; LCD_E <= 1; state <= 11; end
                11: begin LCD_E <= 0; state <= 12; end
                12: if (wait_cnt < 5) wait_cnt <= wait_cnt + 1; else begin state <= 13; wait_cnt <= 0; end
                13: begin LCD_DB <= 4'h3; LCD_E <= 1; state <= 14; end
                14: begin LCD_E <= 0; state <= 15; end
                15: begin LCD_DB <= 4'h3; LCD_E <= 1; state <= 16; end
                16: begin LCD_E <= 0; state <= 18; end
                18: begin LCD_DB <= 4'h2; LCD_E <= 1; state <= 19; end
                19: begin LCD_E <= 0; state <= 20; end
                
                // Function Set & Config
                20: begin current_byte <= 8'h28; state <= 100; next_state <= 21; end
                21: begin current_byte <= 8'h0C; state <= 100; next_state <= 22; end
                22: begin current_byte <= 8'h06; state <= 100; next_state <= 23; end
                23: begin current_byte <= 8'h01; state <= 100; next_state <= 24; end
                24: if (wait_cnt < 2) wait_cnt <= wait_cnt + 1; else begin state <= 30; wait_cnt <= 0; end

                // Line 1: Unsorted Data (16 Hex chars)
                30: begin 
                    LCD_RS <= 1; 
                    current_byte <= to_ascii(u_nibble);
                    if (char_idx < 15) begin char_idx <= char_idx + 1; state <= 100; next_state <= 30; end
                    else begin state <= 40; char_idx <= 0; end
                end

                // Move to Line 2
                40: begin LCD_RS <= 0; current_byte <= 8'hC0; state <= 100; next_state <= 41; end

                // Line 2: Sorted Data (16 Hex chars)
                41: begin 
                    LCD_RS <= 1;
                    current_byte <= to_ascii(s_nibble);
                    if (char_idx < 15) begin char_idx <= char_idx + 1; state <= 100; next_state <= 41; end
                    else begin state <= 50; char_idx <= 0; end
                end
                
                50: state <= 30; // Continuous update

                100: begin LCD_DB <= current_byte[7:4]; LCD_E <= 1; state <= 101; end
                101: begin LCD_E <= 0; state <= 102; end
                102: begin LCD_DB <= current_byte[3:0]; LCD_E <= 1; state <= 103; end
                103: begin LCD_E <= 0; state <= next_state; end
            endcase
        end
    end
endmodule