`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 18:07:18
// Design Name: 
// Module Name: square_design
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


//////////////////////////////////////////////////////////////////////////////////
// Square Design Module
//////////////////////////////////////////////////////////////////////////////////

module square_design (
    input [7:0] x,
    input [6:0] y,
    input [15:0] top_oled_data,
    input [15:0] middle_oled_data,
    input [15:0] bottom_oled_data,
    output reg [15:0] oled_out
);
    
    parameter X_START = 43, X_END = 55; 
    parameter TOP_Y_START = 2, TOP_Y_END = 14;
    parameter MIDDLE_Y_START = 18, MIDDLE_Y_END = 30;
    parameter BOTTOM_Y_START = 34, BOTTOM_Y_END = 46;

    always @(*) begin
        if (x >= X_START && x <= X_END && y >= TOP_Y_START && y <= TOP_Y_END) begin
            oled_out = top_oled_data;
        end else if (x >= X_START && x <= X_END && y >= MIDDLE_Y_START && y <= MIDDLE_Y_END) begin
            oled_out = middle_oled_data;
        end else if (x >= X_START && x <= X_END && y >= BOTTOM_Y_START && y <= BOTTOM_Y_END) begin
            oled_out = bottom_oled_data;
        end else begin
            oled_out = 16'b0;
        end
    end
endmodule
