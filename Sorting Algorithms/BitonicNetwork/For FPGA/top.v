module top (
    input sys_clk_p, sys_clk_n,
    input btn_reset,  
    input btn_fetch,  
    input sw_order,   
    output LCD_RS, LCD_RW, LCD_E,
    output [3:0] LCD_DB
);

    // 200MHz to 50MHz
    wire clk_200, clk_50;
    IBUFGDS ibufg_clk (.I(sys_clk_p), .IB(sys_clk_n), .O(clk_200));
    
    reg [1:0] clk_div = 0;
    always @(posedge clk_200) clk_div <= clk_div + 1'b1;
    assign clk_50 = clk_div[1];


    reg [3:0] rom_addr = 0;
    wire [63:0] rom_data;
    reg fetch_prev;
    wire fetch_pulse = btn_fetch && !fetch_prev;

    always @(posedge clk_50) begin
        fetch_prev <= btn_fetch;
        if (btn_reset) 
            rom_addr <= 0;
        else if (fetch_pulse) 
            rom_addr <= rom_addr + 1'b1;
    end


    reg [63:0] rom_mem [0:15];
    initial $readmemh("data.hex", rom_mem);
    assign rom_data = rom_mem[rom_addr];

    wire [63:0] sorted_out;
    bitonic #(8) sorter_inst (
        .data_in(rom_data),
        .asc_mode(!sw_order), 
        .data_out(sorted_out)
    );


    lcd_controller lcd_inst (
        .clk(clk_50),
        .rst(btn_reset),
        .unsorted_data(rom_data),   // Line 1
        .sorted_data(sorted_out),   // Line 2
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_E(LCD_E),
        .LCD_DB(LCD_DB)
    );

endmodule