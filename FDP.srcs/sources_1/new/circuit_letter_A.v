`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:07:31 AM
// Design Name: 
// Module Name: circuit_letter_A
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


module circuit_letter_A(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
    
    parameter [3:0] line_thickness = 1;
    wire [3:0] ready;
    assign draw = |ready;
    line_generator L0 (pixel_index, x, y, x, y + 4, line_thickness, ready[0]);
    line_generator L1 (pixel_index, x, y, x + 4, y, line_thickness, ready[1]);
    line_generator L2 (pixel_index, x, y + 2, x + 4, y + 2, line_thickness, ready[2]);
    line_generator L3 (pixel_index, x + 4, y, x + 4, y + 4, line_thickness, ready[3]);
    
endmodule
