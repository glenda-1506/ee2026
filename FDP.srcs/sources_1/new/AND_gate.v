`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 01:51:39 AM
// Design Name: 
// Module Name: AND_gate
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


module AND_gate #(
    parameter DISPLAY_WIDTH   = 192,
    parameter DISPLAY_HEIGHT  = 128,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [6:0] size         = 5,    // Half the length of the vertical line    
    parameter [3:0] line_thickness = 1     // Thickness for the drawn lines
    )(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
    
    wire [5:0] ready;
    assign draw = |ready;
    line_generator v1 (pixel_index, x, y, x, (y + size * 2), line_thickness, ready[0]);
    line_generator r1 (pixel_index, x, y, (x + size + 1), y, line_thickness, ready[1]);
    line_generator d1 (pixel_index, (x + size + 1), y, (x + size * 2 - 1), (y + size - 2), line_thickness, ready[2]);
    line_generator v2 (pixel_index, (x + size * 2 - 1), (y + size - 2), (x + size * 2 - 1), (y + size + 1), line_thickness, ready[3]);
    line_generator d2 (pixel_index, (x + size * 2 - 1), (y + size + 1), (x + size + 1), (y + size * 2 - 1), line_thickness, ready[4]);
    line_generator r2 (pixel_index, (x + size), (y + size * 2), x, (y + size * 2), line_thickness, ready[5]);
    
endmodule
