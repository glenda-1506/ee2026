`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 03:27:51 PM
// Design Name: 
// Module Name: FALSE_circuit
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


module FALSE_circuit#(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x,
    input [Y_BIT:0] y,
    output F
    );
    
    assign F = 
      ((x >= 32 && x <= 63) && (y >= 8 && y <= 16)) ||
      ((x >= 32 && x <= 55) && (y >= 25 && y <= 33)) ||
      ((x >= 32 && x <= 39) && (y >= 8 && y <= 55));
      
endmodule
