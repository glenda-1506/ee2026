`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_NOT
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


module keyboard_NOT(
    input [6:0] x_addr,
    input [5:0] y_addr,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_operation_NOT operation_NOT (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(18), 
        .y(31), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_NOT (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(14), 
        .y(22), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
