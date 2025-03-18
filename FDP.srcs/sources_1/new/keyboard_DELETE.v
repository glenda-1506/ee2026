`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:42:41 PM
// Design Name: 
// Module Name: keyboard_DELETE
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


module keyboard_DELETE(
    input [12:0] pixel_index,
    output draw
    );
    
    wire draw_variable, draw_grid;
    
    keyboard_function_DELETE function_DELETE (
        .pixel_index(pixel_index), 
        .x(54), 
        .y(52), 
        .draw(draw_variable)
    );
    
    keyboard_unit_grid grid_DELETE (
        .pixel_index(pixel_index), 
        .x(48), 
        .y(43), 
        .draw(draw_grid)
    );
    
    assign draw = draw_variable | draw_grid;
endmodule
