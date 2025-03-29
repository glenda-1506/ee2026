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

module buffer_gate #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter LINE_THICKNESS = 5
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    input [X_BIT:0] size,   // half the length of vertical line    
    output draw
    );
    
    wire [2:0] ready;
    assign draw = ready[0] || ready[1] || ready[2];
    
    // Generate 3 lines (triangle)
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) vertical (x_addr, y_addr, x, y, x, (y + size * 2), LINE_THICKNESS, ready[0]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) slant_down (x_addr, y_addr, x, y, (x + size * 2), (y + size), LINE_THICKNESS, ready[1]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) slant_up (x_addr, y_addr, x, (y + size * 2), (x + size * 2), (y + size), LINE_THICKNESS, ready[2]);
endmodule
