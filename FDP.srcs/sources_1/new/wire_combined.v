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
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input clk,
    input reset,
    input [X_BIT:0] x_index,
    input [Y_BIT:0] y_index,
    input [5:0] input_id, // only needs 1 since every clk cycle i deal with only 1
    output [TOTAL_MODULES-1:0] wire_ready
    );

    // Generate the wires
    var_wires_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT)g0_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(25),
        .input_id(), // to-fill
        .draw(wire_ready[0]), 
        .assignment_is_successful());  // to-fill
    
    var_wires_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g1_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(53),
        .input_id(), // to-fill
        .draw(wire_ready[1]), 
        .assignment_is_successful());  // to-fill
        
   var_wires_3 #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g2_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(81),
        .input_id(), // to-fill
        .draw(wire_ready[2]), 
        .assignment_is_successful());  // to-fill
        
    var_wires_3_extended #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g3_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(39),
        .input_id(), // to-fill
        .draw(wire_ready[3]), 
        .assignment_is_successful());  // to-fill
        
            
    var_wires_3_extended #(DISPLAY_WIDTH, DISPLAY_HEIGHT) g4_in (
        .clk(clk),
        .reset(reset),
        .x_addr(x_index),
        .y_addr(y_index),
        .x(4),
        .y(67),
        .input_id(), // to-fill
        .draw(wire_ready[4]), 
        .assignment_is_successful());  // to-fill
    
endmodule
