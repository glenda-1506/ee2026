`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 18:07:18
// Design Name: 
// Module Name: TASK_4B
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

module TASK_4B (
    input clk,
    input [12:0] pixel_index,
    input reset, 
    input btnC,
    input btnU,
    input btnD,
    output [7:0] JB,
    output reg [15:0] oled_data_reg = 0
    );

    wire clk6p25mhz;
    wire clk_25mhz;
    wire fb;
    wire [6:0] x;
    wire [5:0] y;
    wire [15:0] top_square;
    wire [15:0] middle_square;
    wire [15:0] bottom_square;
    wire [2:0] top_button_state;
    wire [2:0] middle_button_state;
    wire [2:0] bottom_button_state;
    wire btnC_debounced;
    wire btnU_debounced; 
    wire btnD_debounced;
    wire [15:0] oled_display;
    
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
    
    //Generate all the clocks needed
    clock_generator my_6p25mhz_clk (
        clk, 
        7, 
        clk6p25mhz
    );

    clock_generator my_25mhz_clk (
        clk, 
        1, 
        clk_25mhz
    );
    
    //Create all the debouncer factor 
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
    
    //Count number of times each button is pressed and display
    button_count top_button_count (
        .clk(clk), 
        .pb(btnU_debounced), 
        .reset(reset),
        .display_data(top_square), 
        .state_output(top_button_state)
    );
    
    button_count middle_button_count (
        .clk(clk), 
        .pb(btnC_debounced), 
        .reset(reset), 
        .display_data(middle_square), 
        .state_output(middle_button_state)
    );
    
    button_count bottom_button_count (
        .clk(clk),
        .pb(btnD_debounced), 
        .reset(reset),
        .display_data(bottom_square), 
        .state_output(bottom_button_state)
    );
     
    //Main function to control output
    main entry_point (
        .clk(clk_25mhz),
        .x(x),
        .y(y),
        .top_oled_data(top_square),
        .middle_oled_data(middle_square),
        .bottom_oled_data(bottom_square),
        .top_counter(top_button_state),
        .middle_counter(middle_button_state),
        .bottom_counter(bottom_button_state),
        .oled_display(oled_display)
    );

    //Feed data back to oled_data
    always @(posedge clk_25mhz) begin
        oled_data_reg <= oled_display;  
    end
    
endmodule

