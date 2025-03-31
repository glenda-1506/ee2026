`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 01:46:19 PM
// Design Name: 
// Module Name: wire_combined
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


module wire_combined#(
    parameter DISPLAY_WIDTH = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter TOTAL_MODULES = 5,
    parameter GATE_TYPE_BIT = 2,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input clk,
    input start,
    input reset,
    input [X_BIT:0] x_index,
    input [Y_BIT:0] y_index,
    input [GATE_TYPE_BIT:0] gate_type,
    input [5:0] input_id, // only needs 1 since every clk cycle i deal with only 1
    output [TOTAL_MODULES-1:0] wire_ready,
    output reg assignment_done // signal to top module to move on
    );    
    
    localparam MODULE_COUNT_BIT = $clog2(TOTAL_MODULES) - 1;
    reg trigger;
    reg [5:0] wire_id;
    wire [MODULE_COUNT_BIT:0] enable_module;
    wire [TOTAL_MODULES-1:0] assignment_is_successful;
    wire slow_clock;
    clock (clk, 0, slow_clock);
    counter #(TOTAL_MODULES-1)(slow_clock, 0, trigger && !assignment_done, 1, enable_module); // give 2 clock cycles to settle
    
    function [5:0] map_wire;
        input [5:0] input_id;
        input [GATE_TYPE_BIT:0] gate_type;
        reg [5:0] result;
        begin
            result = 6'bXX;
            if (input_id == 0 && !(gate_type == 0)) result = 6'd0; //  A
            if (input_id == 1 && !(gate_type == 0)) result = 6'd1; //  B
            if (input_id == 2 && !(gate_type == 0)) result = 6'd2; //  C
            if (input_id == 0 && gate_type == 0) result = 6'd5;    // ~A
            if (input_id == 1 && gate_type == 0) result = 6'd6;    // ~B
            if (input_id == 2 && gate_type == 0) result = 6'd7;    // ~C
        end
    endfunction

    // Logic
    always @(posedge clk) begin
          if (start) begin assignment_done <= 1'b0; trigger <= 1'b1; end
          else if (trigger) assignment_done <= |assignment_is_successful;
          if (|assignment_is_successful || enable_module == TOTAL_MODULES - 1) trigger <= 0;
          wire_id <= map_wire(input_id, gate_type);
      end

    // Generate the wires
    var_wires_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT)g0_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(25),
        .input_id((enable_module == 0) ? wire_id : 6'bXX),
        .draw(wire_ready[0]), 
        .assignment_is_successful(assignment_is_successful[0]));
    
    var_wires_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g1_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(53),
        .input_id((enable_module == 1) ? wire_id : 6'bXX),
        .draw(wire_ready[1]), 
        .assignment_is_successful(assignment_is_successful[1]));
        
   var_wires_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g2_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(81),
        .input_id((enable_module == 2) ? wire_id : 6'bXX),
        .draw(wire_ready[2]), 
        .assignment_is_successful(assignment_is_successful[2])); 
        
    var_wire_3_extended #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g3_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(39),
        .input_id((enable_module == 3) ? wire_id : 6'bXX),
        .draw(wire_ready[3]), 
        .assignment_is_successful(assignment_is_successful[3])); 
        
            
    var_wire_3_extended #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g4_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(67),
        .input_id((enable_module == 4) ? wire_id : 6'bXX),
        .draw(wire_ready[4]), 
        .assignment_is_successful(assignment_is_successful[4]));
    
endmodule
