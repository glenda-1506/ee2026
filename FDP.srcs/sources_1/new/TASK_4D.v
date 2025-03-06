`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 04:28:01 PM
// Design Name: 
// Module Name: TASK_4D
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


module TASK_4D(
    input MAIN_CLOCK,
    input [12:0] pixel_index,
    input reset,
    input btnU, btnD, btnL, btnR,
    output [7:0] JB,
    output reg [15:0] oled_data_reg = 0
    );  
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameter and modules
    //////////////////////////////////////////////////////////////////////////////////
   
    // Set local parameters
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    parameter GREEN = 16'h07E0;
    parameter RED = 16'hF800;
    
    // Generate required wires and regs
    wire [6:0] green_x_val;
    wire [5:0] green_y_val;
    wire red_square_ready;
    wire green_square_ready;
    wire clk_25M;
    wire clk_g;
    wire [3:0] pb = {{btnL}, {btnR}, {btnU}, {btnD}};
    
    // Generate clock signals
    clk_25MHz clk25 (MAIN_CLOCK, clk_25M); 
    clk_green clkG (MAIN_CLOCK, clk_g);
    
    // Instantiate the squares (red and green)
    always @(posedge clk_25M) begin
        oled_data_reg <= red_square_ready ? RED : (green_square_ready ? GREEN : BLACK);
    end
    
    // Generate Squares from Task 4
    square_generator red_square(
        .pixel_index(pixel_index),
        .x_start(66),
        .y_start(0),
        .size(30),
        .ready(red_square_ready));
    
    square_generator green_square(
        .pixel_index(pixel_index),
        .x_start(green_x_val),
        .y_start(green_y_val),
        .size(10),
        .ready(green_square_ready));
        
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    control move_green (
        .clk(clk_g), 
        .reset(reset), 
        .pb(pb), 
        .green_x(green_x_val), 
        .green_y(green_y_val));
        
endmodule
