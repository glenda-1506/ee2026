`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 20:55:53
// Design Name: 
// Module Name: main
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module main (
    input clk,  
    input [7:0] x,
    input [6:0] y,
    input [15:0] top_oled_data,
    input [15:0] middle_oled_data,
    input [15:0] bottom_oled_data,
    input [2:0] top_counter,
    input [2:0] middle_counter,
    input [2:0] bottom_counter,
    output reg [15:0] oled_display
);

    wire [15:0] square_output;
    wire [15:0] circle_output;

    square_design square (
        .x(x), 
        .y(y),
        .top_oled_data(top_oled_data),
        .middle_oled_data(middle_oled_data),
        .bottom_oled_data(bottom_oled_data),
        .oled_out(square_output)
    );

    circle_design circle (
        .x(x), 
        .y(y),
        .top_counter(top_counter),
        .middle_counter(middle_counter),
        .bottom_counter(bottom_counter),
        .oled_out(circle_output)
    );

    always @(posedge clk) begin
    if (square_output != 16'b0) begin
        oled_display <= square_output;
    end else begin
        oled_display <= circle_output;
    end
end

endmodule
