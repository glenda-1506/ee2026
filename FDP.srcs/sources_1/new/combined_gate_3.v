`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 12:43:44 PM
// Design Name: 
// Module Name: combined_gate
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

module combined_gate_3#(
    parameter DISPLAY_WIDTH       = 96,
    parameter DISPLAY_HEIGHT      = 64,
    parameter GATE_TYPE_BIT       = 2,
    parameter GATE_OUTPUT_ID_BIT  = 6,
    parameter GATE_INPUT_BIT      = 3,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input clk,
    input [X_BIT:0] x_index,
    input [Y_BIT:0] y_index,
    
    // Gate signals for gate container 0
    input [GATE_INPUT_BIT-1:0] g0_input_lines,
    input [GATE_TYPE_BIT-1:0] g0_gate_type,
    input [GATE_OUTPUT_ID_BIT-1:0] g0_out_id_in,
    
    // Gate signals for gate container 1
    input [GATE_INPUT_BIT-1:0] g1_input_lines,
    input [GATE_TYPE_BIT-1:0] g1_gate_type,
    input [GATE_OUTPUT_ID_BIT-1:0] g1_out_id_in,
    
    // Gate signals for gate container 2
    input [GATE_INPUT_BIT-1:0] g2_input_lines,
    input [GATE_TYPE_BIT-1:0] g2_gate_type,
    input [GATE_OUTPUT_ID_BIT-1:0] g2_out_id_in,
    
    // Gate signals for gate container 3
    input [GATE_INPUT_BIT-1:0] g3_input_lines,
    input [GATE_TYPE_BIT-1:0] g3_gate_type,
    input [GATE_OUTPUT_ID_BIT-1:0] g3_out_id_in,
    
    // Gate signals for gate container 4
    input [GATE_INPUT_BIT-1:0] g4_input_lines,
    input [GATE_TYPE_BIT-1:0] g4_gate_type,
    input [GATE_OUTPUT_ID_BIT-1:0] g4_out_id_in,
    
    // Gate signals for gate container 5
    input [GATE_INPUT_BIT-1:0] g5_input_lines,
    input [GATE_TYPE_BIT-1:0] g5_gate_type,
    input [GATE_OUTPUT_ID_BIT-1:0] g5_out_id_in,
    
    // Outputs from variable circuit segments
    output [2:0] var_ready,
    
    // Draw signals and output ids from gate containers
    output [5:0] gate_ready,
    output [GATE_OUTPUT_ID_BIT-1:0] g0_out_id,
    output [GATE_OUTPUT_ID_BIT-1:0] g1_out_id,
    output [GATE_OUTPUT_ID_BIT-1:0] g2_out_id,
    output [GATE_OUTPUT_ID_BIT-1:0] g3_out_id,
    output [GATE_OUTPUT_ID_BIT-1:0] g4_out_id,
    output [GATE_OUTPUT_ID_BIT-1:0] g5_out_id
    );

    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) A (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(2),
        .y(2),
        .letter_info(0),
        .not_gate_visability(1), // to-change as needed
        .segment_visability(1),  // to-change as needed
        .draw(var_ready[0])
    );

    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) B (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(23),
        .y(2),
        .letter_info(1),
        .not_gate_visability(1),
        .segment_visability(1),
        .draw(var_ready[1]));

    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) C (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(44),
        .y(2),
        .letter_info(2),
        .not_gate_visability(1),
        .segment_visability(1),
        .draw(var_ready[2]));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g0 (
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(22),
        .input_lines(g0_input_lines),
        .gate_select(g0_gate_type),
        .output_id_in(g0_out_id_in),
        .draw(gate_ready[0]),
        .output_id(g0_out_id));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g1 (
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(50),
        .input_lines(g1_input_lines),
        .gate_select(g1_gate_type),
        .output_id_in(g1_out_id_in),
        .draw(gate_ready[1]),
        .output_id(g1_out_id));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g2 (
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(78),
        .input_lines(g2_input_lines),
        .gate_select(g2_gate_type),
        .output_id_in(g2_out_id_in),
        .draw(gate_ready[2]),
        .output_id(g2_out_id));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g3 (
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(99),
        .y(36),
        .input_lines(g3_input_lines),
        .gate_select(g3_gate_type),
        .output_id_in(g3_out_id_in),
        .draw(gate_ready[3]),
        .output_id(g3_out_id));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g4 (
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(99),
        .y(64),
        .input_lines(g4_input_lines),
        .gate_select(g4_gate_type),
        .output_id_in(g4_out_id_in),
        .draw(gate_ready[4]),
        .output_id(g4_out_id));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g5 (
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(123),
        .y(50),
        .input_lines(g5_input_lines),
        .gate_select(g5_gate_type),
        .output_id_in(g5_out_id_in),
        .draw(gate_ready[5]),
        .output_id(g5_out_id));
endmodule
