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


module circle_generator(
    input [12:0] pixel_index, 
    input [6:0]  center_x,      
    input [5:0]  center_y,          
    input [6:0]  radius,    
    input [6:0]  max_diff, // adjust according to the radius
    output draw
    );
    
    wire [6:0] x = pixel_index % 96;
    wire [5:0] y = pixel_index / 96;
    
    // Difference of current pixel from center
    wire [6:0] dx = (x >= center_x) ? (x - center_x) : (center_x - x);
    wire [5:0] dy = (y >= center_y) ? (y - center_y) : (center_y - y);
    
    // Squared differene is exactly my r^2 value (based on current pixel pos)
    wire [14:0] dist_sq = dx * dx + dy*dy;
    wire [13:0] radius_sq = radius * radius;
    wire [14:0] diff = (dist_sq >= radius_sq) ? (dist_sq - radius_sq) : (radius_sq - dist_sq);
    assign draw = diff <= max_diff;
endmodule
