`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 09:10:08 PM
// Design Name: 
// Module Name: double_digit_generator
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

module double_digit_generator#(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y, 
    input [6:0] number, 
    output draw
    );
    
    wire [1:0] digit_ready;
    assign draw = |digit_ready;
    wire [3:0] digit_tens, digit_ones;
    assign digit_tens = number / 10;
    assign digit_ones = number % 10;
    
    digit_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) d_0
                     (x_addr, y_addr, x, y, digit_tens, digit_ready[0]); 
    digit_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) d_1
                     (x_addr, y_addr, x + 12, y, digit_ones, digit_ready[1]);
endmodule
