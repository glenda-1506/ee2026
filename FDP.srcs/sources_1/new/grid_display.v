`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 02:41:40 PM
// Design Name: 
// Module Name: grid_display
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


module grid_display(
    input [6:0] x,
    input [5:0] y,
    output grid
    );
    
    assign grid = 
        (((x >= 0 && x <= 62) && (y == 21 || y == 42)) ||
        ((y >= 0 && y <= 62) && (x == 21 || x == 42))) ? 1 : 0;
endmodule
