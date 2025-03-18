`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 11:55:26 PM
// Design Name: 
// Module Name: circle_generator
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


module circle_generator#(
    parameter DISPLAY_WIDTH = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter MAX_SQUARE_DISTANCE = ((DISPLAY_WIDTH-1) * (DISPLAY_WIDTH-1)) + 
                                    ((DISPLAY_HEIGHT-1) * (DISPLAY_HEIGHT-1)),
    parameter DIST_BIT = $clog2(MAX_SQUARE_DISTANCE + 1) - 1
    )(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0]  center_x,      
    input [Y_BIT:0]  center_y,          
    input [X_BIT:0]  radius,    
    input [X_BIT:0]  max_diff, // adjust according to the radius
    output draw
    );
    
    wire [X_BIT:0] x = pixel_index % DISPLAY_WIDTH;
    wire [Y_BIT:0] y = pixel_index / DISPLAY_WIDTH;
    
    // Difference of current pixel from center
    wire [X_BIT:0] dx = (x >= center_x) ? (x - center_x) : (center_x - x);
    wire [Y_BIT:0] dy = (y >= center_y) ? (y - center_y) : (center_y - y);
    
    // Squared differene is exactly my r^2 value (based on current pixel pos)
    wire [DIST_BIT:0] dist_sq = dx * dx + dy*dy;
    wire [DIST_BIT:0] radius_sq = radius * radius;
    wire [DIST_BIT:0] diff = (dist_sq >= radius_sq) ? (dist_sq - radius_sq) : (radius_sq - dist_sq);
    assign draw = diff <= max_diff;
endmodule
