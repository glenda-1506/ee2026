`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_AND
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


module keyboard_AND(
    input [12:0] pixel_index,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_operation_AND operation_AND (
        .pixel_index(pixel_index), 
        .x(56), 
        .y(31), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_AND (
        .pixel_index(pixel_index), 
        .x(48), 
        .y(22), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
