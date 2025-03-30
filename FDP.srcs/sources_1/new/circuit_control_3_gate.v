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
    input [13:0] x_addr,
    input [13:0] y_addr,
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
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk) begin
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
        .clk(clk),
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
        .clk(clk),
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
        .clk(clk),
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
        .clk(clk),
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
        .clk(clk),
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
        .clk(clk),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(124),
        .y(50),
        .input_lines({sw[9],sw[8],sw[7]}),
        .gate_select({sw[6],sw[5]}),
        .output_id_in(6'hXX),
        .draw(gate_ready[5]),
        .output_id(0));
endmodule
