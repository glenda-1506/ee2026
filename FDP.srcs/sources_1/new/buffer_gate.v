`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 09:00:28 PM
// Design Name: 
// Module Name: buffer_gate
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

module buffer_gate(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    input [6:0] size,   // half the length of vertical line    
    output draw
    );
    
    wire [2:0] ready;
    assign draw = ready[0] || ready[1] || ready[2];
    
    // Generate 3 lines (triangle)
    line_generator vertical (pixel_index, x, y, x, (y + size * 2), 5, ready[0]);
    line_generator slant_down (pixel_index, x, y, (x + size * 2), (y + size), 5, ready[1]);
    line_generator slant_up (pixel_index, x, (y + size * 2), (x + size * 2), (y + size), 5, ready[2]);
endmodule
