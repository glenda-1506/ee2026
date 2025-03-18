`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2025 01:08:11 AM
// Design Name: 
// Module Name: keyboard_DELETE
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


module keyboard_function_DELETE #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [3:0] line_thickness = 1
)(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0] x,                     
    input [Y_BIT:0] y,  
    output draw
);
    
    wire [7:0] ready;
    assign draw = |ready;

    line_generator L0 (
       .pixel_index(pixel_index),
       .x1(x+1),
       .y1(y-3),
       .x2(x+5),
       .y2(y-3),
       .thickness(line_thickness),
       .draw(ready[0]));
       
   line_generator L1 (
       .pixel_index(pixel_index),
       .x1(x+1),
       .y1(y-3),
       .x2(x+1),
       .y2(y+3),
       .thickness(line_thickness),
       .draw(ready[1]));
   
   line_generator L2 (
       .pixel_index(pixel_index),
       .x1(x+5),
       .y1(y-3),
       .x2(x+5),
       .y2(y+3),
       .thickness(line_thickness),
       .draw(ready[2]));
       
   line_generator L3 (
      .pixel_index(pixel_index),
      .x1(x+1),
      .y1(y+3),
      .x2(x+5),
      .y2(y+3),
      .thickness(line_thickness),
      .draw(ready[3]));
      
  line_generator L4 (
      .pixel_index(pixel_index),
      .x1(x+2),
      .y1(y-2),
      .x2(x+4),
      .y2(y-2),
      .thickness(line_thickness),
      .draw(ready[4]));
  
  line_generator L5 (
    .pixel_index(pixel_index),
    .x1(x+2),
    .y1(y+2),
    .x2(x+4),
    .y2(y-2),
    .thickness(line_thickness),
    .draw(ready[5]));
        
  line_generator L6 (
      .pixel_index(pixel_index),
      .x1(x-2),
      .y1(y),
      .x2(x+1),
      .y2(y+3),
      .thickness(line_thickness),
      .draw(ready[6]));
  
  line_generator L7 (
      .pixel_index(pixel_index),
      .x1(x-2),
      .y1(y),
      .x2(x+1),
      .y2(y-3),
      .thickness(line_thickness),
      .draw(ready[7]));

endmodule