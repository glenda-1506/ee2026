`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 04:40:06 PM
// Design Name: 
// Module Name: square_generator
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
// Sets the dimensions of the square. x_start and y_start represent the top left
// corners of the respective squares
// Returns a flag that signals the OLED to display the square
//////////////////////////////////////////////////////////////////////////////////


module square_generator(
    input [12:0] pixel_index,
    input [6:0] x_start, // top left
    input [5:0] y_start, // top left
    input [5:0] size,
    output ready
    );
    
    // Generate required wires
    wire[6:0] x = pixel_index % 96;
    wire[5:0] y = pixel_index / 96;
    
    assign ready = (x >= x_start) && (x <= (x_start + (size - 1))) &&
                   (y >= y_start) && (y <= (y_start + (size - 1)));
    
endmodule
