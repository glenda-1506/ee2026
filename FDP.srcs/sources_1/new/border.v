`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 12:01:49 AM
// Design Name: 
// Module Name: border
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


module border_design(
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] oled_out
    );
    
    parameter SCREEN_HEIGHT = 64;
    parameter SCREEN_WIDTH = 96;
    parameter BORDER_MARGIN = 3;
    parameter BORDER_THICKNESS = 3;
    parameter RED = 16'b11111_000000_00000;   
    parameter BLACK = 16'b0;           
    
    always @(*) begin
        if (x < BORDER_MARGIN + BORDER_THICKNESS ||
            x >= SCREEN_WIDTH - (BORDER_MARGIN + BORDER_THICKNESS) ||
            y < BORDER_MARGIN + BORDER_THICKNESS || 
            y >= SCREEN_HEIGHT - (BORDER_MARGIN + BORDER_THICKNESS))
            oled_out = RED;
        else
            oled_out = BLACK;
    end
endmodule
