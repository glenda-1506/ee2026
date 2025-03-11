`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 07:13:58 PM
// Design Name: 
// Module Name: TASK_4C
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


module TASK_4C(
    input MAIN_CLOCK,
    input [12:0] pixel_index,
    input reset,
    input btnC,
    output reg [15:0] oled_data_reg = 0
    );  
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameter and modules
    //////////////////////////////////////////////////////////////////////////////////
    
    // Set local parameters
    parameter BLACK = 16'h0000;
    parameter ORANGE = 16'hFC00;
    
    // Generate required wires and regs
    reg [6:0] r0_size = 11;
    reg [6:0] r1_size = 0;
    reg [6:0] r2_size = 0;
    reg [6:0] r3_size = 0;
    reg [6:0] r4_size = 0;
    reg [6:0] r5_size = 0;
    reg start = 0;
    reg switch_speed = 0;
    wire [5:0] ready;
    wire clk_25M;
    wire clk_45;
    wire clk_15;
    
    // Generate clock signals
    clk_25MHz clk25 (MAIN_CLOCK, clk_25M);
    base_clock clk45 (MAIN_CLOCK, 1_111_110 , clk_45);
    base_clock clk15 (MAIN_CLOCK, 3_333_333 , clk_15);
    
    // Produce the 6 rectangle segments
    rectangle_generator r0 (
        .pixel_index(pixel_index),
        .x_start(85),
        .y_start(0),
        .x_size(11),
        .y_size(r0_size),
        .ready(ready[0]));
        
    rectangle_generator r1 (
        .pixel_index(pixel_index),
        .x_start(85 - r1_size),
        .y_start(54),
        .x_size(r1_size),
        .y_size(11),
        .ready(ready[1]));
        
    rectangle_generator r2 (
        .pixel_index(pixel_index),
        .x_start(41),
        .y_start(54 - r2_size),
        .x_size(11),
        .y_size(r2_size),
        .ready(ready[2]));
        
    rectangle_generator r3 (
        .pixel_index(pixel_index),
        .x_start(52),
        .y_start(30),
        .x_size(r3_size),
        .y_size(11),
        .ready(ready[3]));  

    rectangle_generator r4 (
        .pixel_index(pixel_index),
        .x_start(61),
        .y_start(30 - r4_size),
        .x_size(11),
        .y_size(r4_size),
        .ready(ready[4]));        

    rectangle_generator r5 (
        .pixel_index(pixel_index),
        .x_start(72),
        .y_start(0),
        .x_size(r5_size),
        .y_size(11),
        .ready(ready[5])); 
           
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk_25M) begin
        if (reset) begin 
            start <= 0;
        end
        
        if (btnC && (r0_size == 11)) begin
            start <= 1;
        end 
        
        oled_data_reg <= ready ? ORANGE : BLACK;
    end
    
    always @(posedge clk_45) begin
        r0_size <= start ? ((r0_size == 64) ? r0_size : r0_size + 1) : 11; 
    end
    
    always @ (posedge clk_15) begin
        if (start) begin 
            switch_speed <= (r0_size == 64);
            r1_size <= (switch_speed) ? ((r1_size == 44) ? r1_size : r1_size + 1) : r1_size; 
            r2_size <= (r1_size == 44) ? ((r2_size == 24) ? r2_size : r2_size + 1) : r2_size; 
            r3_size <= (r2_size == 24) ? ((r3_size == 20) ? r3_size : r3_size + 1) : r3_size;
            r4_size <= (r3_size == 20) ? ((r4_size == 30) ? r4_size : r4_size + 1) : r4_size; 
            r5_size <= (r4_size == 30) ? ((r5_size == 13) ? r5_size : r5_size + 1) : r5_size; 
        end
        else begin 
            switch_speed <= 0;
            r1_size <= 0;
            r2_size <= 0;
            r3_size <= 0;
            r4_size <= 0;
            r5_size <= 0;
        end
    end
endmodule
