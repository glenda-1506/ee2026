`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 10:53:38 AM
// Design Name: 
// Module Name: circuit_control_3_gate
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


module circuit_control_3_gate(
    input clk,
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
    wire [3:0] pb = {btnU, btnD, btnL, btnR};
    wire [13:0] x_index;
    wire [13:0] y_index;
    
    // Generate the ready flags for items to draw
    wire [2:0] var_ready;
    wire [5:0] gate_ready;
    
    // Generate virtual oled
    virtual_oled_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) v_oled 
                            (clk, reset, pb, x_addr, y_addr, x_index, y_index);
                            
    //////////////////////////////////////////////////////////////////////////////////
    // GATE VARIABLES / WIRES / REGS
    //////////////////////////////////////////////////////////////////////////////////  
    
    // Set parameters
    localparam GATE_TYPE_BIT = 2;
    localparam GATE_OUTPUT_ID_BIT = 6;
    localparam GATE_INPUT_BIT = 3;
    localparam DATA_PACKET_BIT = GATE_TYPE_BIT + GATE_OUTPUT_ID_BIT + GATE_INPUT_BIT;
    
    // Individual regs and wires
    reg [GATE_TYPE_BIT-1:0] g0_gate_type, g1_gate_type, g2_gate_type, g3_gate_type, g4_gate_type, g5_gate_type;
    reg [GATE_OUTPUT_ID_BIT-1:0] g0_out_id_in, g1_out_id_in, g2_out_id_in, g3_out_id_in, g4_out_id_in, g5_out_id_in;
    reg [GATE_INPUT_BIT-1:0] g0_input_lines, g1_input_lines, g2_input_lines, g3_input_lines, g4_input_lines, g5_input_lines;
    wire [GATE_OUTPUT_ID_BIT-1:0] g0_out_id, g1_out_id, g2_out_id, g3_out_id, g4_out_id, g5_out_id;
    
    // Data Packets (immutable)
    wire [DATA_PACKET_BIT-1:0] g0_packet = {g0_out_id, g0_input_lines, g0_gate_type};
    wire [DATA_PACKET_BIT-1:0] g1_packet = {g1_out_id, g1_input_lines, g1_gate_type};
    wire [DATA_PACKET_BIT-1:0] g2_packet = {g2_out_id, g2_input_lines, g2_gate_type};
    wire [DATA_PACKET_BIT-1:0] g3_packet = {g3_out_id, g3_input_lines, g3_gate_type};
    wire [DATA_PACKET_BIT-1:0] g4_packet = {g4_out_id, g4_input_lines, g4_gate_type};
    wire [DATA_PACKET_BIT-1:0] g5_packet = {g5_out_id, g5_input_lines, g5_gate_type};
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    integer i;
    always @(posedge clk) begin
        g0_out_id_in = 6'hXX;
        g1_out_id_in = 6'hXX;
        g2_out_id_in = 6'hXX;
        g3_out_id_in = 6'hXX;
        g4_out_id_in = 6'hXX;
        g5_out_id_in = 6'hXX;
        for (i = 0; i < 6; i = i + 1) begin
            case (i)
                0: begin g0_input_lines = {sw[13:11]}; g0_gate_type = {sw[15:14]}; end
                1: begin g1_input_lines = {sw[13:11]}; g1_gate_type = {sw[15:14]}; end
                2: begin g2_input_lines = {sw[13:11]}; g2_gate_type = {sw[15:14]}; end
                3: begin g3_input_lines = {sw[13:11]}; g3_gate_type = {sw[15:14]}; end
                4: begin g4_input_lines = {sw[13:11]}; g4_gate_type = {sw[15:14]}; end
                5: begin g5_input_lines = {sw[13:11]}; g5_gate_type = {sw[15:14]}; end
            endcase
        end
        
    end
    
    // SET THE PIXELS TO BE LIGHTED UP (SHOULD BE UNCHANGED)
    always @(posedge clk) begin
        oled_data_reg <= (|var_ready || |gate_ready)
                          ? WHITE : BLACK;
    end
            
    //////////////////////////////////////////////////////////////////////////////////
    // WIRE MODULES
    //////////////////////////////////////////////////////////////////////////////////      
    
  
    //////////////////////////////////////////////////////////////////////////////////
    // GATE MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    
    //* Generate variable components
    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) A (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(2),
        .y(2),
        .letter_info(0),
        .not_gate_visability(1), //to-change
        .segment_visability(1), //to-change
        .draw(var_ready[0]));
        
    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) B (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(23),
        .y(2),
        .letter_info(1),
        .not_gate_visability(1), //to-change
        .segment_visability(1), //to-change
        .draw(var_ready[1]));
        
    variable_circuit_segment #(DISPLAY_WIDTH, DISPLAY_HEIGHT) C (
        .x_addr(x_index),
        .y_addr(y_index),
        .x(44),
        .y(2),
        .letter_info(2),
        .not_gate_visability(1), //to-change
        .segment_visability(1), //to-change
        .draw(var_ready[2]));
    
    // Generate the gates
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
        .x(124),
        .y(50),
        .input_lines(g5_input_lines),
        .gate_select(g5_gate_type),
        .output_id_in(g5_out_id_in),
        .draw(gate_ready[5]),
        .output_id(g5_out_id));
endmodule
