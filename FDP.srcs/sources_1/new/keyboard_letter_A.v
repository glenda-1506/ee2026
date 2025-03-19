`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2025 11:56:18 PM
// Design Name: 
// Module Name: keyboard_letter_A
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


module keyboard_letter_A #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT           = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT           = $clog2(DISPLAY_HEIGHT) - 1,
    parameter [3:0] line_thickness = 1
    )(
    input [X_BIT:0] x_addr,
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
    
    wire [3:0] ready;
    assign draw = |ready;
    
    line_generator L0 (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x1(x), 
        .y1(y), 
        .x2(x), 
        .y2(y + 8), 
        .thickness(line_thickness), 
        .draw(ready[0])
    );
 
    line_generator L1 (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x1(x), 
        .y1(y), 
        .x2(x + 7), 
        .y2(y), 
        .thickness(line_thickness), 
        .draw(ready[1])
    );

    line_generator L2 (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x1(x), 
        .y1(y + 4), 
        .x2(x + 7), 
        .y2(y + 4), 
        .thickness(line_thickness), 
        .draw(ready[2])
    );
 
    line_generator L3 (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x1(x + 7), 
        .y1(y), 
        .x2(x + 7), 
        .y2(y + 8), 
        .thickness(line_thickness), 
        .draw(ready[3])
    );
    
endmodule
