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
    
    always @(*) begin
        oled_data = 16'h0000;
        
        if (draw_A) oled_data = ((current_row == 2'b00) && (current_col == 2'b00)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_B) oled_data = ((current_row == 2'b00) && (current_col == 2'b01)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_C) oled_data = ((current_row == 2'b00) && (current_col == 2'b10)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_NOT) oled_data = ((current_row == 2'b01) && (current_col == 2'b00)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_OR) oled_data = ((current_row == 2'b01) && (current_col == 2'b01)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_AND) oled_data = ((current_row == 2'b01) && (current_col == 2'b10)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_LBRAC) oled_data = ((current_row == 2'b10) && (current_col == 2'b00)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_RBRAC) oled_data = ((current_row == 2'b10) && (current_col == 2'b01)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_DELETE) oled_data = ((current_row == 2'b10) && (current_col == 2'b10)) ? 16'h07E0 : 16'hFFFF;
        else if (draw_ENTER) oled_data = ((current_row == 2'b10) && (current_col == 2'b11)) ? 16'h07E0 : 16'hFFFF;
    end
endmodule