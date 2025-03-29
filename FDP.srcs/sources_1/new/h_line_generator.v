`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 02:38:47 PM
// Design Name: 
// Module Name: h_line_generator
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


module h_line_generator#(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter LENGTH = 1,
    parameter [0:0] IS_RIGHT_DIR = 1'b1,
    parameter LINE_THICKNESS = 1,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr,
    input [Y_BIT:0] y_addr,
    input [X_BIT:0] x,      
    input [Y_BIT:0] y, 
    output draw
    );
    
    wire [X_BIT:0] x_end = IS_RIGHT_DIR ? (x + LENGTH) : (x - LENGTH);
    line_generator #(DISPLAY_WIDTH,DISPLAY_HEIGHT)
                    (x_addr, y_addr, x, y, x_end, y, LINE_THICKNESS, draw);

endmodule
