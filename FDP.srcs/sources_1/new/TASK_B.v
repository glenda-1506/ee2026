`timescale 1ns / 1ps

module TASK_B(
    input MAIN_CLOCK,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input reset,    
    output reg [15:0] oled_data_reg = 0,
    input locked,
    input [63:0] buffer
); 
    wire [15:0] out;
   
    Display_Typing display_unit (
        .clk(MAIN_CLOCK), 
        .x_addr(x_addr),
        .y_addr(y_addr),
        .program_locked(locked),
        .pixel_data(out),
        .buffer(buffer)
    );

always @(posedge MAIN_CLOCK) begin
    oled_data_reg <= out;
end

endmodule