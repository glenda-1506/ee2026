`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 10:29:26 PM
// Design Name: 
// Module Name: line_generator
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

module line_generator #(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64, 
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PROD_XY_BIT = X_BIT + Y_BIT + 2
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0] x1,      
    input [Y_BIT:0] y1,         
    input [X_BIT:0] x2,       
    input [Y_BIT:0] y2, 
    input [X_BIT:0] thickness,         
    output draw
    );

    // Compute the bounding box (min/max values)
    wire [X_BIT:0] x_min = (x1 <= x2) ? x1 : x2;
    wire [X_BIT:0] x_max = (x1 <= x2) ? x2 : x1;
    wire [Y_BIT:0] y_min = (y1 <= y2) ? y1 : y2;
    wire [Y_BIT:0] y_max = (y1 <= y2) ? y2 : y1;

    wire in_box = (x_addr >= x_min) && (x_addr <= x_max) &&
                  (y_addr >= y_min) && (y_addr <= y_max);

    // Calculate differences for the line (only need to compute once)
    wire [X_BIT:0] diff_x_line = x_max - x_min;
    wire [Y_BIT:0] diff_y_line = y_max - y_min;

    // Compute absolute differences between the pixel and the first endpoint
    wire [X_BIT:0] diff_x_pixel = (x_addr >= x1) ? (x_addr - x1) : (x1 - x_addr);
    wire [Y_BIT:0] diff_y_pixel = (y_addr >= y1) ? (y_addr - y1) : (y1 - y_addr);

    // Check for cases: vertical or horizontal lines
    wire is_vertical   = (diff_x_line == 0);
    wire is_horizontal = (diff_y_line == 0);

    // For angled lines, calculate the absolute cross product
    wire [PROD_XY_BIT:0] term1 = diff_x_pixel * diff_y_line;
    wire [PROD_XY_BIT:0] term2 = diff_y_pixel * diff_x_line;
    wire [PROD_XY_BIT:0] abs_cross = (term1 > term2) ? (term1 - term2) : (term2 - term1);

    wire condition;
    assign condition = is_vertical ? (diff_x_pixel <= thickness) :
                       is_horizontal ? (diff_y_pixel <= thickness) :
                                       (abs_cross   <= thickness);

    assign draw = in_box && condition;

endmodule



