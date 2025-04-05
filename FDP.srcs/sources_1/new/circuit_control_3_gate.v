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
    input btnU, btnD, btnL, btnR, btnC,
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
    parameter MODULE_COUNT = 50;
    
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
    wire [7:0] function_id = sw[15:8];
    reg [7:0] old_func_id;
    wire [2:0] gate_input_count_MSOP, gate_input_count_MPOS, gate_input_count;
    wire [1:0] gate_type_MSOP, gate_type_MPOS, gate_type;
    wire [2:0] gate_id_MSOP, gate_id_MPOS, gate_id;
    wire control_valid_MSOP, control_valid_MPOS, control_valid;
    wire [$clog2(MODULE_COUNT):0] wire_input_id_MSOP, wire_input_id_MPOS, wire_input_id;
    reg current_req;
    reg control_reset;
    reg prev_btnC;
    assign gate_input_count = current_req ? gate_input_count_MPOS : gate_input_count_MSOP;
    assign gate_type = current_req ? gate_type_MPOS : gate_type_MSOP;
    assign gate_id = current_req ? gate_id_MPOS : gate_id_MSOP;
    assign control_valid = current_req ? control_valid_MPOS : control_valid_MSOP;
    assign wire_input_id = current_req ? wire_input_id_MPOS : wire_input_id_MSOP;
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    
    
    // SET THE PIXELS TO BE LIGHTED UP
    always @(posedge clk) begin
        prev_btnC <= btnC;
        control_reset <= 1'b0;
        if ((old_func_id != function_id) || (btnC && !prev_btnC)) begin
            control_reset <= 1'b1;
            current_req <= btnC ? ~current_req : current_req;
        end
        old_func_id <= function_id;
        oled_data_reg <= (|var_ready || |gate_ready || |wire_ready)
                          ? WHITE : BLACK;
    end
    
    //////////////////////////////////////////////////////////////////////////////////
    // WIRE MODULES
    //////////////////////////////////////////////////////////////////////////////////        

    wire_combined_3 #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
        )(
        .clk(clk),
        .reset(control_reset), 
        .x_index(x_index),
        .y_index(y_index),
        .input_id(control_valid ? wire_input_id : 6'd63),
        .wire_ready(wire_ready));

    //////////////////////////////////////////////////////////////////////////////////
    // GATE MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    //*
    combined_gate_3 #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
        )(
        .clk(clk),
        .reset(control_reset),
        .x_index(x_index),
        .y_index(y_index),
        .input_count(control_valid ? gate_input_count : 3'd7),
        .gate_type(control_valid ? gate_type : 2'd0),
        .gate_id(control_valid ? gate_id : 3'd7),
        .wire_id(control_valid ? wire_input_id : 6'd63),
        .var_ready(var_ready),
        .gate_ready(gate_ready));
    //*/
    
    //////////////////////////////////////////////////////////////////////////////////
    // CONTROL MODULE
    ////////////////////////////////////////////////////////////////////////////////// 
    
    wire_gate_3_control_MSOP ctrl (
        .clk(clk),
        .reset(control_reset),
        .func_id(function_id),
        .wire_id(wire_input_id_MSOP),
        .gate_type(gate_type_MSOP),
        .gate_id(gate_id_MSOP),
        .input_count(gate_input_count_MSOP),
        .valid(control_valid_MSOP));
        
    wire_gate_3_control_MPOS ctrl2 (
        .clk(clk),
        .reset(control_reset),
        .func_id(function_id),
        .wire_id(wire_input_id_MPOS),
        .gate_type(gate_type_MPOS),
        .gate_id(gate_id_MPOS),
        .input_count(gate_input_count_MPOS),
        .valid(control_valid_MPOS));
endmodule
