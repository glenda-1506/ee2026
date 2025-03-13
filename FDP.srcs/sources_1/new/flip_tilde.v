`timescale 1ns / 1ps

module flipped_circuit_letter_tilde(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
    
    parameter [3:0] line_thickness = 1;
    wire [2:0] ready;
    assign draw = |ready;

    // First line: Going up with a positive gradient
    line_generator L1 (pixel_index, x, y + 3, x + 4, y + 7, line_thickness, ready[0]);

    // Second line: Going down with a negative gradient
    line_generator L2 (pixel_index, x + 4, y + 7, x + 8, y + 3, line_thickness, ready[1]);

    // Third line: Repeat L1 starting at where L2 ends
    line_generator L3 (pixel_index, x + 8, y + 3, x + 12, y + 7, line_thickness, ready[2]);

endmodule