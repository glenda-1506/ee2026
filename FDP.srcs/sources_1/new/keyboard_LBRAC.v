`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_LBRAC
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


module keyboard_LBRAC(
    input [6:0] x_addr,
    input [5:0] y_addr,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_operation_LBRAC operation_LBRAC (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(21), 
        .y(48), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_LBRAC (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(14), 
        .y(43),
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
