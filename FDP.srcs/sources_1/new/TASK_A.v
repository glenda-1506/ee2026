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
    // Instantiate parameters, wires and regs
    //////////////////////////////////////////////////////////////////////////////////
       
    // Set local parameters
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    
    // Generate required wires and regs
    wire clk_25M;
    wire clk_6p25M;
    wire bU, bD, bL,bR;
    wire [3:0] pb = {bU, bD, bL,bR};
    wire [14:0] virtual_index;
    wire [8:0] x_index = virtual_index % 192;
    wire [8:0] y_index = virtual_index / 192;
    
    // Generate the ready flags for items to draw
    wire [2:0] var_ready;
    wire [1:0] gate_ready;
    
    // Generate single pulse buttons
    delay s1(MAIN_CLOCK, btnU, 250_000, bU);
    delay s2(MAIN_CLOCK, btnD, 250_000, bD);
    delay s3(MAIN_CLOCK, btnL, 250_000, bL);
    delay s4(MAIN_CLOCK, btnR, 250_000, bR);
    
    // Generate clock signals
    clock clk6p25 (MAIN_CLOCK, 7 , clk_6p25M);
    clock clk25 (MAIN_CLOCK, 1, clk_25M);
    
    // Generate virtual oled
    virtual_oled_generator v_oled (clk_6p25M, reset, pb, pixel_index, virtual_index);
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk_25M) begin
        oled_data_reg <= (|var_ready || |gate_ready)
                          ? WHITE : BLACK;
    end
            
    //////////////////////////////////////////////////////////////////////////////////
    // Modules to draw
    //////////////////////////////////////////////////////////////////////////////////       
    
    // Generate variable components
    variable_circuit_segment #(192, 128) A (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(2),
        .y(2),
        .letter_info(0),
        .not_gate_visability(sw[14]),
        .segment_visability(sw[15]),
        .draw(var_ready[0]));
        
    variable_circuit_segment #(192, 128) B (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(23),
        .y(2),
        .letter_info(1),
        .not_gate_visability(sw[12]),
        .segment_visability(sw[13]),
        .draw(var_ready[1]));
        
    variable_circuit_segment #(192, 128) C (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(44),
        .y(2),
        .letter_info(2),
        .not_gate_visability(sw[10]),
        .segment_visability(sw[11]),
        .draw(var_ready[2]));
    
    // Generate the gates
    OR_gate #(192, 128) o1 (
        .x_addr(x_index),
        .y_addr(y_index),
        .x (75),
        .y (32),
        .draw (gate_ready[0]));
    
    AND_gate #(192, 128) a1 (
        .x_addr(x_index),
        .y_addr(y_index),
        .x (75),
        .y (52),
        .draw (gate_ready[1]));
    
endmodule
