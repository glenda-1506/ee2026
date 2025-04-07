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
    output [3:0] var_ready,
    output [5:0] gate_ready
    );
    
    // Counter to place the final signal line
    wire [10:0] count;
    reg [2:0] last_valid_gate;
    wire  [X_BIT:0] f_signal_x = get_f_x(last_valid_gate);
    wire [Y_BIT:0] f_signal_y = get_f_y(last_valid_gate);
    reg trigger;
    reg f_enable;
    counter #(1000)(clk, 0, trigger && (gate_id == 3'd7), 1, count);
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            f_enable <= 1'b0;
            trigger <= 1'b0;
            last_valid_gate <= 3'd7;
        end else begin
            if (gate_id != 3'd7) begin  last_valid_gate <= gate_id; trigger <= 1'b1;end
            if (count == 1000) f_enable <= 1;
        end
    end
    
    function [X_BIT:0] get_f_x;
        input [2:0] last_valid_gate;
        begin
            case (last_valid_gate)
                3'd0, 3'd1, 3'd2: get_f_x = 85;
                3'd3, 3'd4: get_f_x = 109;
                3'd5: get_f_x = 133;
                default: get_f_x = 0;
            endcase
        end
    endfunction

    function [Y_BIT:0] get_f_y;
        input [2:0] last_valid_gate;
        begin
            case (last_valid_gate)
                3'd0: get_f_y = 25;
                3'd1: get_f_y = 53;
                3'd2: get_f_y = 81;
                3'd3: get_f_y = 39;
                3'd4: get_f_y = 67;
                3'd5: get_f_y = 53;
                default: get_f_y = 0;
            endcase
        end
    endfunction
    
    /*
    A  : [0,6,12,18,24]
    B  : [1,7,13,19,25]
    C  : [2,8,14,20,26]
    ~A : [3,9,15,21,27]
    ~B : [4,10,16,22,28]
    ~C : [5,11,17,23,29]
    gate 0 to gate 3: [30,31,32]
    gate 1 to gate 3: [33,34,35]
    gate 2 to gate 3: [36,37,38]
    gate 0 to gate 4: [39,40,41]
    gate 1 to gate 4: [42,43,44]
    gate 2 to gate 4: [45,46,47]
    gate 3 to gate 5: [48]
    gate 4 to gate 5: [49]
    */
    // Input Line Mapping Logic -> next time wire_ids should be issued in (% max_gate_input)
    reg [2:0] stored_mapping;
    wire [2:0] input_line_value = (input_count == 3'd3) ? 3'b111 : stored_mapping;
    function [2:0] map_wire_to_line;
        input [5:0] w;
        input [GATE_INPUT_BIT-1:0] input_count;
        begin
            case(w)
                6'd0, 6'd3, 6'd6, 6'd9, 6'd12, 6'd15, 6'd18, 6'd21, 6'd24, 6'd27,
                6'd31, 6'd34, 6'd37, 6'd40, 6'd43, 6'd46, 6'd48:
                    map_wire_to_line = 3'b010;
                6'd1, 6'd4, 6'd7, 6'd10, 6'd13, 6'd16, 6'd19, 6'd22, 6'd25, 6'd28,
                6'd30, 6'd33, 6'd36, 6'd39, 6'd42, 6'd45:
                    map_wire_to_line = 3'b100;
                6'd2, 6'd5, 6'd8, 6'd11, 6'd14, 6'd17, 6'd20, 6'd23, 6'd26, 6'd29,
                6'd32, 6'd35, 6'd38, 6'd41, 6'd44, 6'd47, 6'd49:
                    map_wire_to_line = 3'b001;
                default:
                    map_wire_to_line = 3'b0;
            endcase
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
    
    // Segment Visability Logic
    function wire_in_set(input [5:0] w, a, b, c, d, e);
    begin
        wire_in_set = (w == a) || (w == b) || (w == c) || (w == d) || (w == e);
    end
    endfunction     
    
    reg A_visibility, AB_visibility, B_visibility, BB_visibility, C_visibility, CB_visibility;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_visibility <= 0;
            B_visibility <= 0;
            C_visibility <= 0;
            AB_visibility <= 0;
            BB_visibility <= 0;
            CB_visibility <= 0;
        end else begin
            if (wire_in_set(wire_id,0,6,12,18,24) || wire_in_set(wire_id,3,9,15,21,27)) A_visibility <= 1;
            if (wire_in_set(wire_id,1,7,13,19,25) || wire_in_set(wire_id,4,10,16,22,28)) B_visibility <= 1;
            if (wire_in_set(wire_id,2,8,14,20,26) || wire_in_set(wire_id,5,11,17,23,29)) C_visibility <= 1;
            if (wire_in_set(wire_id,3,9,15,21,27)) AB_visibility <= 1;
            if (wire_in_set(wire_id,4,10,16,22,28)) BB_visibility <= 1;
            if (wire_in_set(wire_id,5,11,17,23,29)) CB_visibility <= 1;
        end
    end  
    
                               
    reg [1:0] g0_gate_type, g1_gate_type, g2_gate_type, g3_gate_type, g4_gate_type, g5_gate_type;
    reg [2:0] g0_input_lines, g1_input_lines, g2_input_lines, g3_input_lines, g4_input_lines, g5_input_lines;
    
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
        f_enable <= 1'b0;
        trigger <= 1'b0;
        A_visibility <= 0; B_visibility <= 0; C_visibility <= 0;
        AB_visibility <= 0; BB_visibility <= 0; CB_visibility <= 0;
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
        .not_gate_visability(AB_visibility),
        .segment_visability(A_visibility),  
        .draw(var_ready[0])
    );

    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) B (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(23),
        .y(2),
        .letter_info(1),
        .not_gate_visability(BB_visibility),
        .segment_visability(B_visibility),
        .draw(var_ready[1]));

    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) C (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(44),
        .y(2),
        .letter_info(2),
        .not_gate_visability(CB_visibility),
        .segment_visability(C_visibility),
        .draw(var_ready[2]));

    f_signal #(DISPLAY_WIDTH, DISPLAY_HEIGHT) F (
        .enable(f_enable),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(f_signal_x),
        .y(f_signal_y),
        .draw(var_ready[3]));

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
