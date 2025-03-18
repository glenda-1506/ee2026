`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 11:51:36 PM
// Design Name: 
// Module Name: NOT_gate
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


module NOT_gate #(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64, 
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH*DISPLAY_HEIGHT) - 1,
    parameter SIZE = 4 // half the length of vertical line
    )(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
    wire [1:0] ready;
    assign draw = ready[0] || ready[1];
    buffer_gate #(192, 128) b1 (pixel_index, x, y, SIZE, ready[0]);
    circle_generator #(192, 128)(pixel_index, (x + SIZE * 2 + 2), (y + SIZE), 1, 0, ready[1]);
endmodule
