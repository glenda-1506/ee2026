`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 03:02:53 PM
// Design Name: 
// Module Name: keyboard_display
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

module keyboard_display(
    input clk,
    input reset,
    input [12:0] pixel_index,
    input btnU, btnD, btnL, btnR, btnC,
    output reg [15:0] oled_data,
    output [3:0] selected_key,
    output key_pressed
);

    wire [1:0] current_row;
    wire [1:0] current_col;
    wire [6:0] x_addr = pixel_index % 96;
    wire [5:0] y_addr = pixel_index / 96;
    
    wire draw_A, draw_B, draw_C, draw_NOT, draw_OR, draw_AND, draw_LBRAC, draw_RBRAC, draw_DELETE, draw_ENTER;

    keyboard_A A_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_A)
    );
    
    keyboard_B B_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_B)
    );
    
    keyboard_C C_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_C)
    );
    
    keyboard_NOT NOT_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_NOT)
    );
    
    keyboard_OR OR_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_OR)
    );
    
    keyboard_AND AND_display(
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_AND)
    );
    
    keyboard_LBRAC LBRAC_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_LBRAC)
    );
    
    keyboard_RBRAC RBRAC_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_RBRAC)
    );
    
    keyboard_DELETE DELETE_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_DELETE)
    );
    
    keyboard_ENTER ENTER_display (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .draw(draw_ENTER)
    );
    
    key_selector selector (
        .clk(clk),
        .reset(reset),
        .btnU(btnU),
        .btnD(btnD),
        .btnL(btnL),
        .btnR(btnR),
        .btnC(btnC),
        .selected_key(selected_key),
        .key_pressed(key_pressed),
        .current_row(current_row),
        .current_col(current_col)
    );
    
    wire selected_A = draw_A && (current_row == 2'b00) && (current_col == 2'b00);
    wire selected_B = draw_B && (current_row == 2'b00) && (current_col == 2'b01);
    wire selected_C = draw_C && (current_row == 2'b00) && (current_col == 2'b10);
    wire selected_NOT = draw_NOT && (current_row == 2'b01) && (current_col == 2'b00);
    wire selected_OR = draw_OR && (current_row == 2'b01) && (current_col == 2'b01);
    wire selected_AND = draw_AND && (current_row == 2'b01) && (current_col == 2'b10);
    wire selected_LBRAC = draw_LBRAC && (current_row == 2'b10) && (current_col == 2'b00);
    wire selected_RBRAC = draw_RBRAC && (current_row == 2'b10) && (current_col == 2'b01);
    wire selected_DELETE = draw_DELETE && (current_row == 2'b10) && (current_col == 2'b10);
    wire selected_ENTER = draw_ENTER && (current_row == 2'b10) && (current_col == 2'b11);
    always @(*) begin
        oled_data = (selected_A || selected_B || selected_C || selected_NOT || selected_OR || selected_AND 
                    || selected_LBRAC || selected_RBRAC || selected_DELETE || selected_ENTER)
                    ? 16'h07E0 // for everything on top
                    : (draw_A || draw_B || draw_C || draw_NOT || draw_OR || draw_AND || draw_LBRAC 
                    || draw_RBRAC || draw_DELETE || draw_ENTER)
                    ? 16'hFFFF // for everything on top until the previous ?
                    : 16'h0000; // else
    end
endmodule