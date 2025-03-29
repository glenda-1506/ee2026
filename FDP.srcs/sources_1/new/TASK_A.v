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
    input [6:0] x_addr,
    input [5:0] y_addr,
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
    parameter DISPLAY_WIDTH = 142; // Change this if require a different dimension
    parameter DISPLAY_HEIGHT = 96; // Change this if require a different dimension
    
    // Generate required wires and regs
    wire clk_25M;
    wire clk_6p25M;
    wire bU, bD, bL,bR;
    wire [3:0] pb = {bU, bD, bL,bR};
    wire [14:0] virtual_index;
    wire [8:0] x_index;
    wire [8:0] y_index;
    
    // Generate the ready flags for items to draw
    wire [2:0] var_ready;
    wire [5:0] gate_ready;
    
    // Generate delayed pulse buttons
    delay s1(MAIN_CLOCK, btnU, 250_000, bU);
    delay s2(MAIN_CLOCK, btnD, 250_000, bD);
    delay s3(MAIN_CLOCK, btnL, 250_000, bL);
    delay s4(MAIN_CLOCK, btnR, 250_000, bR);
    
    // Generate clock signals
    clock clk6p25 (MAIN_CLOCK, 7 , clk_6p25M);
    clock clk25 (MAIN_CLOCK, 1, clk_25M);
    
    // Generate virtual oled
    virtual_oled_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) v_oled 
                            (clk_6p25M, reset, pb, x_addr, y_addr, x_index, y_index);
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk_25M) begin
        oled_data_reg <= (|var_ready || |gate_ready)
                          ? WHITE : BLACK;
    end
            
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    
    //* Generate variable components
    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) A (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(2),
        .y(2),
        .letter_info(0),
        .not_gate_visability(sw[14]),
        .segment_visability(sw[15]),
        .draw(var_ready[0]));
        
    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) B (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(23),
        .y(2),
        .letter_info(1),
        .not_gate_visability(sw[12]),
        .segment_visability(sw[13]),
        .draw(var_ready[1]));
        
    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) C (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(44),
        .y(2),
        .letter_info(2),
        .not_gate_visability(sw[10]),
        .segment_visability(sw[11]),
        .draw(var_ready[2]));
    
    // Generate the gates
    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g0 (
        .clk(MAIN_CLOCK),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(22),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[0]),
        .output_id(0));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g1 (
        .clk(MAIN_CLOCK),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(50),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[1]),
        .output_id(0));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g2 (
        .clk(MAIN_CLOCK),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(78),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[2]),
        .output_id(0));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g3 (
        .clk(MAIN_CLOCK),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(99),
        .y(36),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[3]),
        .output_id(0));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g4 (
        .clk(MAIN_CLOCK),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(99),
        .y(64),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[4]),
        .output_id(0));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g5 (
        .clk(MAIN_CLOCK),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(124),
        .y(50),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[5]),
        .output_id(0));
    
    //*/
    
    //////////////////////////////////////////////////////////////////////////////////
    // TEST CODE
    ////////////////////////////////////////////////////////////////////////////////// 
        
    /* Code below is for test LUT usage. Replace * with /   
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) a1 (x_index, y_index, 10, 10, 10, 20, 1, var_ready[1]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) a2 (x_index, y_index, 30, 30, 50, 30, 1, var_ready[0]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) a3 (x_index, y_index, 60, 60, 75, 85, 1, var_ready[2]);
    //*/
    
endmodule
