`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 11:51:36 PM
// Design Name: 
// Module Name: NOT_gate
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


module NOT_gate(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
    
    parameter [6:0] size = 4; // half the length of vertical line
    wire [1:0] ready;
    assign draw = ready[0] || ready[1];
    buffer_gate b1 (pixel_index, x, y, size, ready[0]);
    circle_generator (pixel_index, (x + size * 2 + 2), (y + size), 1, 0, ready[1]);
endmodule
