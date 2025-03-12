`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 01:51:14 AM
// Design Name: 
// Module Name: OR_gate
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


module OR_gate(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
     
    parameter [3:0] line_thickness = 2;
    wire [9:0] ready;
    assign draw = |ready;
    
    // 10 lines generation
    line_generator L0 (pixel_index, x, y, (x + 3), y, line_thickness, ready[0]);
    line_generator L1 (pixel_index, (x + 3), y, (x + 7), (y + 2), line_thickness, ready[1]);
    line_generator L2 (pixel_index, (x + 7), (y + 2), (x + 9), (y + 5), line_thickness, ready[2]);
    line_generator L3 (pixel_index, (x + 9), (y + 5), (x + 7), (y + 8), line_thickness, ready[3]);
    line_generator L4 (pixel_index, (x + 7), (y + 8), (x + 3), (y + 10), line_thickness, ready[4]);
    line_generator L5 (pixel_index, (x + 3), (y + 10), x, (y + 10), line_thickness, ready[5]);
    line_generator L6 (pixel_index, x, (y + 10), (x + 2), (y + 8), line_thickness, ready[6]);
    line_generator L7 (pixel_index, (x + 2), (y + 8), (x + 3), (y + 5), line_thickness, ready[7]);
    line_generator L8 (pixel_index, (x + 3), (y + 5), (x + 2), (y + 2), line_thickness, ready[8]);
    line_generator L9 (pixel_index, (x + 2), (y + 2), x, y, line_thickness, ready[9]);

endmodule
