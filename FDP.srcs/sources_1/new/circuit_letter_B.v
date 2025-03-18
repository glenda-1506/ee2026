`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:07:31 AM
// Design Name: 
// Module Name: circuit_letter_B
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


module circuit_letter_B #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [3:0] line_thickness = 1
    )(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );

    wire [4:0] ready;
    assign draw = |ready;

    // Left vertical line of "B"
    line_generator #(192, 128) L0 (
        .pixel_index(pixel_index),
        .x1(x),
        .y1(y),
        .x2(x),
        .y2(y + 4),
        .thickness(line_thickness),
        .draw(ready[0]));
   
    // Top horizontal line of "B"
    line_generator #(192, 128) L1 (
        .pixel_index(pixel_index),
        .x1(x),
        .y1(y),
        .x2(x + 4),
        .y2(y),
        .thickness(line_thickness),
        .draw(ready[1]));
    
    // Middle horizontal line of "B"
    line_generator #(192, 128) L2 (
        .pixel_index(pixel_index),
        .x1(x),
        .y1(y + 2),
        .x2(x + 4),
        .y2(y + 2),
        .thickness(line_thickness),
        .draw(ready[2]));
    
    // Right vertical line of "B"
    line_generator #(192, 128) L3 (
        .pixel_index(pixel_index),
        .x1(x + 4),
        .y1(y),
        .x2(x + 4),
        .y2(y + 4),
        .thickness(line_thickness),
        .draw(ready[3]));
    
    // Bottom horizontal line of "B"
    line_generator #(192, 128) L4 (
        .pixel_index(pixel_index),
        .x1(x),
        .y1(y + 4),
        .x2(x + 4),
        .y2(y + 4),
        .thickness(line_thickness),
        .draw(ready[4]));
    
endmodule