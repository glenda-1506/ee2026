`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 02:25:11 PM
// Design Name: 
// Module Name: TASK_C
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


module TASK_C(
    input clk,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input reset,
    input btnU, btnD, btnL, btnR, btnC,
    output [15:0] oled_data,
    output [3:0] selected_key,
    output key_pressed
    );
    
    wire btnC_debounced;
    wire btnU_debounced; 
    wire btnD_debounced;
    wire btnL_debounced; 
    wire btnR_debounced;
    
    base_debouncer up_button_debouncer (
        .clk(clk), 
        .pb(btnU), 
        .count_max(500_000),
        .debounced_pb(btnU_debounced)
    );

    base_debouncer center_button_debouncer (
        .clk(clk), 
        .pb(btnC), 
        .count_max(500_000),
        .debounced_pb(btnC_debounced)
    );

    base_debouncer down_button_debouncer (
        .clk(clk),
        .pb(btnD),
        .count_max(500_000),
        .debounced_pb(btnD_debounced)
    );
    
    base_debouncer left_button_debouncer (
        .clk(clk), 
        .pb(btnL), 
        .count_max(500_000),
        .debounced_pb(btnL_debounced)
    );

    base_debouncer right_button_debouncer (
        .clk(clk),
        .pb(btnR),
        .count_max(500_000),
        .debounced_pb(btnR_debounced)
    );
    
    keyboard_display display (
        .clk(clk),
        .reset(reset),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .btnU(btnU_debounced), 
        .btnD(btnD_debounced),
        .btnL(btnL_debounced), 
        .btnR(btnR_debounced), 
        .btnC(btnC_debounced),
        .oled_data(oled_data),
        .selected_key(selected_key),
        .key_pressed(key_pressed)
    );
endmodule
