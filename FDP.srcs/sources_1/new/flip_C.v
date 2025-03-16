`timescale 1ns / 1ps

module flipped_circuit_letter_C(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
    
    parameter [3:0] line_thickness = 1;
    wire [2:0] ready;
    assign draw = |ready;
    
    // Flip y-coordinates using (64 - y)
    line_generator L0 (pixel_index, x + 4, 64 - (y + 4), x + 4, 64 - y, line_thickness, ready[0]);  // Vertical line (left side)
    line_generator L1 (pixel_index, x, 64 - y, x + 4, 64 - y, line_thickness, ready[1]);  // Top horizontal line
    line_generator L2 (pixel_index, x, 64 - (y + 4), x + 4, 64 - (y + 4), line_thickness, ready[2]);  // Bottom horizontal line
    
endmodule