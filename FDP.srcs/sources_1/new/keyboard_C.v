`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_C
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


module keyboard_C(
    input [6:0] x_addr,
    input [5:0] y_addr,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_letter_C letter_c (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(52), 
        .y(6), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_C (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(48), 
        .y(1), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
