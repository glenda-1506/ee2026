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
    input [5:0] wire_id,
    output [2:0] var_ready,
    output [5:0] gate_ready
    );
    
    /*
    A  : [0,6,12,18,24]
    B  : [1,7,13,19,25]
    C  : [2,8,14,20,26]
    ~A : [3,9,15,21,27]
    ~B : [4,10,16,22,28]
    ~C : [5,11,17,23,29]
    */
    // Input Line Mapping Logic
    reg [2:0] stored_mapping;
    wire [2:0] input_line_value = (input_count == 3'd3) ? 3'b111 : stored_mapping;
    function [2:0] map_wire_to_line;
        input [5:0] w;
        input [GATE_INPUT_BIT-1:0] input_count;
        begin
            if ((w == 0) || (w == 3) || (w == 6) || (w == 9) || (w == 12) ||
                (w == 15) || (w == 18) || (w == 21) || (w == 24) || (w == 27))
                map_wire_to_line = 3'b100;
            else if ((w == 1) || (w == 4) || (w == 7) || (w == 10) || (w == 13) ||
                     (w == 16) || (w == 19) || (w == 22) || (w == 25) || (w == 28))
                map_wire_to_line = 3'b010;
            else if ((w == 2) || (w == 5) || (w == 8) || (w == 11) || (w == 14) ||
                     (w == 17) || (w == 20) || (w == 23) || (w == 26) || (w == 29))
                map_wire_to_line = 3'b001;
            else
                map_wire_to_line = (input_count == 3'd2) ? 3'b110 : 
                                   (input_count == 3'd1) ? 3'b100 : 3'b0;
        end
    endfunction
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_mapping <= 3'b0;
        end else begin
            if (gate_id == 3'd7) begin
                stored_mapping <= stored_mapping | map_wire_to_line(wire_id, input_count);
            end else begin
                stored_mapping <= 3'b0;
            end
        end
    end
                                  
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
        g0_gate_type = 2'b0; g1_gate_type = 2'b0; g2_gate_type = 2'b0;
        g3_gate_type = 2'b0; g4_gate_type = 2'b0; g5_gate_type = 2'b0;
        g0_input_lines = 3'b0; g1_input_lines = 3'b0; g2_input_lines = 3'b0;
        g3_input_lines = 3'b0; g4_input_lines = 3'b0; g5_input_lines = 3'b0;
    end
    endtask
    
    
    initial begin
        init;
        stored_mapping <= 3'b0;
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
