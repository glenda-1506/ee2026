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
    parameter MODULE_COUNT = 5;
    
    // Generate required wires and regs
    wire [3:0] pb = {btnU, btnD, btnL, btnR};
    wire [13:0] x_index;
    wire [13:0] y_index;
    
    // Generate the ready flags for items to draw
    wire [2:0] var_ready;
    wire [5:0] gate_ready;
    wire [MODULE_COUNT-1:0] wire_ready;
    
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
    
    // Data Packets (for lookup)
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
                0: begin g0_input_lines = 3'b1; g0_gate_type = 2'b1; end
                1: begin g1_input_lines = 3'b1; g1_gate_type = 2'b1; end
                2: begin g2_input_lines = 3'b1; g2_gate_type = 2'b1; end
                3: begin g3_input_lines = 3'b1; g3_gate_type = 2'b1; end
                4: begin g4_input_lines = 3'b1; g4_gate_type = 2'b1; end
                5: begin g5_input_lines = 3'b1; g5_gate_type = 2'b1; end
            endcase
        end  
    end
    
    // SET THE PIXELS TO BE LIGHTED UP
    always @(posedge clk) begin
        oled_data_reg <= (|var_ready || |gate_ready || |wire_ready)
                          ? WHITE : BLACK;
    end
    
    //////////////////////////////////////////////////////////////////////////////////
    // WIRE MODULES
    //////////////////////////////////////////////////////////////////////////////////      
//    var_wire_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT)(x_addr, y_addr, 4, 25, 1'b0);

    wire assignment_done;
    reg start_reg = 0;  
    reg [GATE_TYPE_BIT:0] wire_gate_type = 0;
    reg [5:0] wire_input_id = 0;
    
    wire_combined #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
    ) wire_test (
        .clk(clk),
        .start(start_reg),
        .reset(sw[2]),
        .x_index(x_index),
        .y_index(y_index),
        .start_module(0), // to change => figure out where to start (look at pixel mapping)
        .gate_type(wire_gate_type),
        .input_id(wire_input_id),
        .wire_ready(wire_ready),
        .assignment_done(assignment_done)
    );
    wire trigger;
    single_pulse_debouncer (clk, sw[15], trigger);
    always @(posedge clk) begin
        if (!assignment_done)begin
            wire_gate_type <= sw[14:13];
            wire_input_id  <= sw[12:7];
        end
        start_reg <= trigger; 
    end

    //////////////////////////////////////////////////////////////////////////////////
    // GATE MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    //*
    combined_gate #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT),
        .GATE_TYPE_BIT(GATE_TYPE_BIT),
        .GATE_OUTPUT_ID_BIT(GATE_OUTPUT_ID_BIT),
        .GATE_INPUT_BIT(GATE_INPUT_BIT)
        )(
        .clk(clk),
        .x_index(x_index),
        .y_index(y_index),
        .g0_input_lines(g0_input_lines),
        .g0_gate_type(g0_gate_type),
        .g0_out_id_in(g0_out_id_in),
        .g1_input_lines(g1_input_lines),
        .g1_gate_type(g1_gate_type),
        .g1_out_id_in(g1_out_id_in),
        .g2_input_lines(g2_input_lines),
        .g2_gate_type(g2_gate_type),
        .g2_out_id_in(g2_out_id_in),
        .g3_input_lines(g3_input_lines),
        .g3_gate_type(g3_gate_type),
        .g3_out_id_in(g3_out_id_in),
        .g4_input_lines(g4_input_lines),
        .g4_gate_type(g4_gate_type),
        .g4_out_id_in(g4_out_id_in),
        .g5_input_lines(g5_input_lines),
        .g5_gate_type(g5_gate_type),
        .g5_out_id_in(g5_out_id_in),
        .var_ready(var_ready),
        .gate_ready(gate_ready),
        .g0_out_id(g0_out_id),
        .g1_out_id(g1_out_id),
        .g2_out_id(g2_out_id),
        .g3_out_id(g3_out_id),
        .g4_out_id(g4_out_id),
        .g5_out_id(g5_out_id));
    //*/
endmodule
