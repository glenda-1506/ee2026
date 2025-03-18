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
    input [12:0] pixel_index,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_letter_C letter_c (
        .pixel_index(pixel_index), 
        .x(52), 
        .y(6), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_C (
        .pixel_index(pixel_index), 
        .x(48), 
        .y(1), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
