`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 07:03:26 AM
// Design Name: 
// Module Name: keyboard_AND
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


module keyboard_operation_AND #(
    parameter DISPLAY_WIDTH = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [3:0] line_thickness = 1
)(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0] x,                     
    input [Y_BIT:0] y,  
    output draw
);

    wire [2:0] ready;
    assign draw = |ready;

    line_generator L0 (
       .pixel_index(pixel_index),
       .x1(x),
       .y1(y-1),
       .x2(x),
       .y2(y-1),
       .thickness(line_thickness),
       .draw(ready[0]));
       
   line_generator L1 (
       .pixel_index(pixel_index),
       .x1(x-1),
       .y1(y),
       .x2(x+1),
       .y2(y),
       .thickness(line_thickness),
       .draw(ready[1]));
   
   line_generator L2 (
       .pixel_index(pixel_index),
       .x1(x),
       .y1(y+1),
       .x2(x),
       .y2(y+1),
       .thickness(line_thickness),
       .draw(ready[2]));

endmodule
