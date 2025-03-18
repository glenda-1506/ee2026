`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_RBRAC
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


module keyboard_RBRAC(
    input [12:0] pixel_index,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_operation_RBRAC operation_RBRAC (
        .pixel_index(pixel_index), 
        .x(38), 
        .y(48), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_RBRAC (
        .pixel_index(pixel_index), 
        .x(31), 
        .y(43), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
