`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 08:59:10 PM
// Design Name: 
// Module Name: TASK_A
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


module TASK_A(
    input MAIN_CLOCK,
    input [12:0] pixel_index,
    input [15:0] sw,
    input reset,
    input btnU, btnD, btnL, btnR,
    output reg [15:0] oled_data_reg = 0
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameter and modules
    //////////////////////////////////////////////////////////////////////////////////
       
    // Set local parameters
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    
    // Generate required wires and regs
    wire clk_25M;
    wire [2:0] var_ready;
    
    // Generate clock signals
    clock clk25 (MAIN_CLOCK, 1, clk_25M);
    
    // Generate variable components
    variable_circuit_segment A (
        .pixel_index(pixel_index),
        .x(2),
        .y(2),
        .letter_info(0),
        .not_gate_visability(sw[14]),
        .segment_visability(sw[15]),
        .draw(var_ready[0]));
        
    variable_circuit_segment B (
        .pixel_index(pixel_index),
        .x(23),
        .y(2),
        .letter_info(1),
        .not_gate_visability(sw[12]),
        .segment_visability(sw[13]),
        .draw(var_ready[1]));
        
    variable_circuit_segment C (
        .pixel_index(pixel_index),
        .x(44),
        .y(2),
        .letter_info(2),
        .not_gate_visability(sw[10]),
        .segment_visability(sw[11]),
        .draw(var_ready[2]));
     
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    
    // Instantiate the squares (red and green)
    always @(posedge clk_25M) begin
        oled_data_reg <= var_ready ? WHITE : BLACK;
    end
    
endmodule
