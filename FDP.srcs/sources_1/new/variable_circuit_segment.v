`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:33:20 AM
// Design Name: 
// Module Name: variable_circuit_segment
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
// Dimension: 64 x 19 (L x B)
//////////////////////////////////////////////////////////////////////////////////


module variable_circuit_segment#(
    parameter DISPLAY_WIDTH    = 96,
    parameter DISPLAY_HEIGHT   = 64,
    parameter X_BIT            = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT            = $clog2(DISPLAY_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT  = $clog2(DISPLAY_WIDTH * DISPLAY_HEIGHT) - 1,
    parameter [3:0] line_thickness = 1,
    parameter VAR_BIT = 2
    )(
    input [PIXEL_INDEX_BIT:0] pixel_index, 
    input [X_BIT:0]  x,  // Left corner of any letter                   
    input [Y_BIT:0]  y,  // Left corner of any letter
    input [VAR_BIT:0] letter_info,
    input not_gate_visability,
    input segment_visability,
    output draw
    );

    // Generate required wires and regs
    wire [2:0] letter_ready;
    wire not_gate_ready;
    wire [2:0] line_ready;
    wire [2:0] NOT_component = not_gate_visability ? {not_gate_ready, line_ready[2:1]} : 0;
    assign draw = segment_visability ? |{letter_ready[letter_info], line_ready[0], NOT_component} : 0;
    
    // Generate Letters
    circuit_letter_A letter_a (pixel_index, x, y, letter_ready[0]);
    circuit_letter_B letter_b (pixel_index, x, y, letter_ready[1]);
    circuit_letter_C letter_c (pixel_index, x, y, letter_ready[2]);
    
    // Generate Lines
    line_generator v1 (pixel_index, x + 2, y + 6, x + 2, y + 60, line_thickness, line_ready[0]);
    line_generator v2 (pixel_index, x + 16, y + 12, x + 16, y + 60, line_thickness, line_ready[1]);
    line_generator h1 (pixel_index, x + 3, y + 12, x + 4, y + 12, line_thickness, line_ready[2]);

    // Generate NOT Gate
    NOT_gate n1 (pixel_index, x + 5, y + 8, not_gate_ready);
endmodule
