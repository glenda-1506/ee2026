`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_ENTER
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


module keyboard_ENTER(
    input [6:0] x_addr,
    input [5:0] y_addr,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_function_ENTER function_ENTER (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(70), 
        .y(51), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_ENTER (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .x(65), 
        .y(43), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
