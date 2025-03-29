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


module OR_gate #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [3:0] line_thickness = 2
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
     
    wire [9:0] ready;
    assign draw = |ready;
    
    // 10 lines generation
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L0 (x_addr, y_addr, x, y, (x + 3), y, line_thickness, ready[0]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L1 (x_addr, y_addr, (x + 3), y, (x + 7), (y + 2), line_thickness, ready[1]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L2 (x_addr, y_addr, (x + 7), (y + 2), (x + 9), (y + 5), line_thickness, ready[2]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L3 (x_addr, y_addr, (x + 9), (y + 5), (x + 7), (y + 8), line_thickness, ready[3]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L4 (x_addr, y_addr, (x + 7), (y + 8), (x + 3), (y + 10), line_thickness, ready[4]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L5 (x_addr, y_addr, (x + 3), (y + 10), x, (y + 10), line_thickness, ready[5]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L6 (x_addr, y_addr, x, (y + 10), (x + 2), (y + 8), line_thickness, ready[6]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L7 (x_addr, y_addr, (x + 2), (y + 8), (x + 3), (y + 5), line_thickness, ready[7]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L8 (x_addr, y_addr, (x + 3), (y + 5), (x + 2), (y + 2), line_thickness, ready[8]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L9 (x_addr, y_addr, (x + 2), (y + 2), x, y, line_thickness, ready[9]);

endmodule
