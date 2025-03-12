`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2025 11:52:29 PM
// Design Name: 
// Module Name: TASK_4A
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


module TASK_4A(
    input clk,
    input [12:0] pixel_index,
    input reset, 
    input btnC,
    input btnU,
    input btnD,
    output reg [15:0] oled_data_reg = 0
    );
    
    wire clk_25mhz;
    wire [6:0] x;
    wire [5:0] y;
    wire btnC_debounced;
    wire btnU_debounced; 
    wire btnD_debounced;
    wire [15:0] oled_display;
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    clock_generator my_25mhz_clk (
        clk, 
        1, 
        clk_25mhz
    );
    
    debouncer top_button_debouncer (
        .clk(clk_25mhz), 
        .pb(btnU), 
        .debounced_pb(btnU_debounced)
    );
    
    debouncer middle_button_debouncer (
        .clk(clk_25mhz), 
        .pb(btnC), 
        .debounced_pb(btnC_debounced)
    );
    
    debouncer bottom_button_debouncer (
        .clk(clk_25mhz),
        .pb(btnD),
        .debounced_pb(btnD_debounced)
    );
    
    main_4a main_display (
        .clk(clk_25mhz),
        .reset(reset),
        .x(x),
        .y(y),
        .btnC(btnC_debounced),
        .btnU(btnU_debounced),
        .btnD(btnD_debounced),
        .oled_display(oled_display)
    );

    always @(posedge clk_25mhz) begin
        oled_data_reg <= oled_display;
    end
    
endmodule
