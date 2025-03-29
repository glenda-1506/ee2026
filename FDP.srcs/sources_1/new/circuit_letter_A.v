`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:07:31 AM
// Design Name: 
// Module Name: circuit_letter_A
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


module circuit_letter_A #(
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
    // Vertical left line of "A"
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L0 (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x1(x), 
        .y1(y), 
        .x2(x), 
        .y2(y + 4), 
        .thickness(line_thickness), 
        .draw(ready[0])
    );
 
    // Horizontal top line of "A"
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L1 (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x1(x), 
        .y1(y), 
        .x2(x + 4), 
        .y2(y), 
        .thickness(line_thickness), 
        .draw(ready[1])
    );
  
    // Crossbar of "A"
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L2 (
        .x_addr(x_addr),
        .y_addr(y_addr), 
        .x1(x), 
        .y1(y + 2), 
        .x2(x + 4), 
        .y2(y + 2), 
        .thickness(line_thickness), 
        .draw(ready[2])
    );
 
    // Vertical right line of "A"
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) L3 (
        .x_addr(x_addr),
        .y_addr(y_addr), 
        .x1(x + 4), 
        .y1(y), 
        .x2(x + 4), 
        .y2(y + 4), 
        .thickness(line_thickness), 
        .draw(ready[3])
    );
    
endmodule