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
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [6:0] size         = 5,    // Half the length of the vertical line    
    parameter [3:0] line_thickness = 1     // Thickness for the drawn lines
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
    
    wire [5:0] ready;
    assign draw = |ready;
    line_generator #(192, 128) v1 (x_addr, y_addr, x, y, x, (y + size * 2), line_thickness, ready[0]);
    line_generator #(192, 128) r1 (x_addr, y_addr, x, y, (x + size + 1), y, line_thickness, ready[1]);
    line_generator #(192, 128) d1 (x_addr, y_addr, (x + size + 1), y, (x + size * 2 - 1), (y + size - 2), line_thickness, ready[2]);
    line_generator #(192, 128) v2 (x_addr, y_addr, (x + size * 2 - 1), (y + size - 2), (x + size * 2 - 1), (y + size + 1), line_thickness, ready[3]);
    line_generator #(192, 128) d2 (x_addr, y_addr, (x + size * 2 - 1), (y + size + 1), (x + size + 1), (y + size * 2 - 1), line_thickness, ready[4]);
    line_generator #(192, 128) r2 (x_addr, y_addr, (x + size), (y + size * 2), x, (y + size * 2), line_thickness, ready[5]);
    
endmodule
