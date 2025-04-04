`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 12:43:44 PM
// Design Name: 
// Module Name: combined_gate_3
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
    input reset,
    input [X_BIT:0] x_index,
    input [Y_BIT:0] y_index,
    input [GATE_INPUT_BIT-1:0] input_count,
    input [GATE_TYPE_BIT-1:0] gate_type,
    input [2:0] gate_id,
    output [2:0] var_ready,
    output [5:0] gate_ready
    );
    
    wire [2:0] input_line_value = (input_count == 3'd1) ? 3'b100 :
                                  (input_count == 3'd2) ? 3'b110 : 3'b111;
                                  
    reg [1:0] g0_gate_type;
    reg [1:0] g1_gate_type;
    reg [1:0] g2_gate_type;
    reg [1:0] g3_gate_type;
    reg [1:0] g4_gate_type;
    reg [1:0] g5_gate_type;
    reg [2:0] g0_input_lines;
    reg [2:0] g1_input_lines;
    reg [2:0] g2_input_lines;
    reg [2:0] g3_input_lines;
    reg [2:0] g4_input_lines;
    reg [2:0] g5_input_lines;
    
    task init;
    begin
        g0_gate_type = 2'b00; g1_gate_type = 2'b00; g2_gate_type = 2'b00;
        g3_gate_type = 2'b00; g4_gate_type = 2'b00; g5_gate_type = 2'b00;
        g0_input_lines = 3'b000; g1_input_lines = 3'b000; g2_input_lines = 3'b000;
        g3_input_lines = 3'b000; g4_input_lines = 3'b000; g5_input_lines = 3'b000;
    end
    endtask
    
    
    initial begin
        init;
    end
    
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            init;
        end else begin
            g0_gate_type <= (gate_id == 3'd0) ? gate_type : g0_gate_type;
            g1_gate_type <= (gate_id == 3'd1) ? gate_type : g1_gate_type;
            g2_gate_type <= (gate_id == 3'd2) ? gate_type : g2_gate_type;
            g3_gate_type <= (gate_id == 3'd3) ? gate_type : g3_gate_type;
            g4_gate_type <= (gate_id == 3'd4) ? gate_type : g4_gate_type;
            g5_gate_type <= (gate_id == 3'd5) ? gate_type : g5_gate_type;
            g0_input_lines <= (gate_id == 3'd0) ? input_line_value : g0_input_lines;
            g1_input_lines <= (gate_id == 3'd1) ? input_line_value : g1_input_lines;
            g2_input_lines <= (gate_id == 3'd2) ? input_line_value : g2_input_lines;
            g3_input_lines <= (gate_id == 3'd3) ? input_line_value : g3_input_lines;
            g4_input_lines <= (gate_id == 3'd4) ? input_line_value : g4_input_lines;
            g5_input_lines <= (gate_id == 3'd5) ? input_line_value : g5_input_lines;
        end
    end

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
        .reset(reset),
        .enable(gate_id == 3'd0),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(22),
        .input_lines(g0_input_lines),
        .gate_select(g0_gate_type),
        .draw(gate_ready[0]));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g1 (
        .clk(clk),
        .reset(reset),
        .enable(gate_id == 3'd1),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(50),
        .input_lines(g1_input_lines),
        .gate_select(g1_gate_type),
        .draw(gate_ready[1]));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g2 (
        .clk(clk),
        .reset(reset),
        .enable(gate_id == 3'd2),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(75),
        .y(78),
        .input_lines(g2_input_lines),
        .gate_select(g2_gate_type),
        .draw(gate_ready[2]));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g3 (
        .clk(clk),
        .reset(reset),
        .enable(gate_id == 3'd3),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(99),
        .y(36),
        .input_lines(g3_input_lines),
        .gate_select(g3_gate_type),
        .draw(gate_ready[3]));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g4 (
        .clk(clk),
        .reset(reset),
        .enable(gate_id == 3'd4),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(99),
        .y(64),
        .input_lines(g4_input_lines),
        .gate_select(g4_gate_type),
        .draw(gate_ready[4]));

    gate_container #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g5 (
        .clk(clk),
        .reset(reset),
        .enable(gate_id == 3'd5),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(123),
        .y(50),
        .input_lines(g5_input_lines),
        .gate_select(g5_gate_type),
        .draw(gate_ready[5]));
endmodule
