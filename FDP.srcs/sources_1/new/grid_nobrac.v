`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 02:49:57 PM
// Design Name: 
// Module Name: grid_nobrac
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


module grid_nobrac(
    input [6:0] x,
    input [5:0] y,
    output grid
    );
    
    assign grid = 
        (((x >= 3 && x <= 93) && y == 31) ||
        ((y >= 9 && y <= 53) && (x == 25 || x == 48 || x == 71))) ? 1 : 0;
endmodule
