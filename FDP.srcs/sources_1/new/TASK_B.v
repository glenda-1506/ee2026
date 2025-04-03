`timescale 1ns / 1ps

module TASK_B(
    input MAIN_CLOCK,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [15:0] sw,   // Switch inputs to control letter display    
    input reset,    
    input fb,
    input [3:0] selected_key,
    input key_pressed,
    output led,
    output signal,
    output reg [15:0] oled_data_reg = 0
); 
    wire clk6p25m;
    wire [15:0] out;
    
    clock my_clk_6p25 (MAIN_CLOCK, 7, clk6p25m);

    Display_Typing display_unit (
        .clk(clk6p25m), 
       // .reset(sw[0]),
        .fb(fb),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .selected_key(selected_key),
        .key_pressed(key_pressed),
        .led(led),
        .signal(signal),
        .pixel_data(out)
    );

always @(posedge clk6p25m) begin
    oled_data_reg <= out;
end

endmodule