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


module line_generator(
    input [12:0] pixel_index, 
    input [6:0]  x1,      
    input [5:0]  y1,         
    input [6:0]  x2,       
    input [5:0]  y2, 
    input [6:0]  thickness,         
    output draw
    );
    
    wire [6:0] x = pixel_index % 96;
    wire [5:0] y = pixel_index / 96;
    
    // Compute absolute differences for the line endpoints and the current pixel.
    wire [6:0] diff_x_line  = (x1 <= x2) ? (x2 - x1) : (x1 - x2);
    wire [5:0] diff_y_line  = (y1 <= y2) ? (y2 - y1) : (y1 - y2);
    wire [6:0] diff_x_pixel = (x >= x1) ? (x - x1) : (x1 - x);
    wire [5:0] diff_y_pixel = (y >= y1) ? (y - y1) : (y1 - y);
    wire [12:0] term1 = diff_x_pixel * diff_y_line;
    wire [12:0] term2 = diff_y_pixel * diff_x_line;

    // Compute the absolute cross product value
    // This value is directly proportional to area of parallelogram (area of error)
    wire [12:0] abs_cross = (term1 >= term2) ? (term1 - term2) : (term2 - term1);
    wire in_box = (x >= (x1 <= x2 ? x1 : x2)) && (x <= (x1 <= x2 ? x2 : x1)) &&
                  (y >= (y1 <= y2 ? y1 : y2)) && (y <= (y1 <= y2 ? y2 : y1));
    assign draw = in_box && (abs_cross <= thickness);
endmodule


