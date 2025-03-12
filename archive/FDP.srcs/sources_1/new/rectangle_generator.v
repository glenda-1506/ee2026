`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 01:36:53 PM
// Design Name: 
// Module Name: rectangle_generator
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


module rectangle_generator(
    input [12:0] pixel_index,
    input [6:0] x_start, // top left
    input [5:0] y_start, // top left
    input [6:0] x_size,
    input [6:0] y_size,
    output ready
    );
    
    // Generate required wires
    wire[6:0] x = pixel_index % 96;
    wire[5:0] y = pixel_index / 96;
    
    assign ready = (x >= x_start) && (x <= (x_start + (x_size - 1))) &&
                   (y >= y_start) && (y <= (y_start + (y_size - 1))) && (x_size != 0) && (y_size != 0);
    
endmodule
