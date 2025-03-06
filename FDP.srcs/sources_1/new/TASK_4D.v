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
    input PASSWORD_IS_CORRECT,
    input btnC,
    input btnU, btnD, btnL, btnR,
    output [7:0] JB
    );  
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameter and modules
    //////////////////////////////////////////////////////////////////////////////////
   
    // Set local parameters
    localparam BLACK = 16'h0000;
    localparam WHITE = 16'hFFFF;
    localparam GREEN = 16'h07E0;
    localparam RED = 16'hF800;
    
    // Generate required wires and regs
    wire [6:0] green_x_val;
    wire [5:0] green_y_val;
    reg [15:0] oled_data_reg = BLACK;
    wire [12:0] pixel_index;
    wire [15:0] oled_data = oled_data_reg;
    wire red_square_ready;
    wire green_square_ready;
    wire group_id_ready;
    wire fb;
    wire clk_25M;
    wire clk_6p25M;
    wire clk_g;
    wire [3:0] pb = {{btnL}, {btnR}, {btnU}, {btnD}};
    
    // Generate clock signals
    clk_25MHz clk25 (MAIN_CLOCK, clk_25M); 
    clk_6p25MHz clk6p25 (MAIN_CLOCK, clk_6p25M);
    clk_green clkG (MAIN_CLOCK, clk_g);
    
    // Instantiate the squares (red and green)
    always @(posedge clk_25M) begin
        if (PASSWORD_IS_CORRECT) begin
            oled_data_reg = red_square_ready ? RED : (green_square_ready ? GREEN : BLACK);
        end
        else begin
            oled_data_reg = group_id_ready ? WHITE : BLACK;
        end
    end
    
    // Generate Group ID
    group_generator grp_generator(
        .password_is_correct(PASSWORD_IS_CORRECT),
        .pixel_index(pixel_index),
        .ready(group_id_ready));
        
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
    
    // Instantiate OLED
    Oled_Display task4D (
        .clk(clk_6p25M), 
        .reset(0), 
        .frame_begin(fb), 
        .sending_pixels(), 
        .sample_pixel(), 
        .pixel_index(pixel_index), 
        .pixel_data(oled_data), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]), 
        .pmoden(JB[7]));
        
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    control move_green (
        .clk(clk_g), 
        .reset(btnC), 
        .pb(pb), 
        .green_x(green_x_val), 
        .green_y(green_y_val));
        
endmodule
