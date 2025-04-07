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


module NOT_gate #(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64, 
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter SIZE = 4
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr, 
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
    wire [1:0] ready;
    assign draw = ready[0] || ready[1];
    buffer_gate #(DISPLAY_WIDTH, DISPLAY_HEIGHT) b1 (x_addr, y_addr, x, y, SIZE, ready[0]);
    circle_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT)(x_addr, y_addr, (x + SIZE * 2 + 3), (y + SIZE), 2, 1, ready[1]);
endmodule
