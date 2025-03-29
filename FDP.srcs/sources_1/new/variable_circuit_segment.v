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
    parameter [3:0] line_thickness = 1,
    parameter VAR_BIT = 2
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr, 
    input [X_BIT:0] x,  // Left corner of any letter                   
    input [Y_BIT:0] y,  // Left corner of any letter
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
    circuit_letter_A #(DISPLAY_WIDTH, DISPLAY_HEIGHT) letter_a (x_addr, y_addr, x, y, letter_ready[0]);
    circuit_letter_B #(DISPLAY_WIDTH, DISPLAY_HEIGHT) letter_b (x_addr, y_addr, x, y, letter_ready[1]);
    circuit_letter_C #(DISPLAY_WIDTH, DISPLAY_HEIGHT) letter_c (x_addr, y_addr, x, y, letter_ready[2]);
    
    // Generate Lines
    v_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 84) (x_addr, y_addr, x + 2, y + 6, line_ready[0]);
    v_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 78) (x_addr, y_addr, x + 16, y + 12, line_ready[1]);
    h_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 1)  (x_addr, y_addr, x + 3, y + 12, line_ready[2]);

    // Generate NOT Gate
    NOT_gate #(DISPLAY_WIDTH, DISPLAY_HEIGHT) n1 (x_addr, y_addr, x + 5, y + 8, not_gate_ready);
endmodule
