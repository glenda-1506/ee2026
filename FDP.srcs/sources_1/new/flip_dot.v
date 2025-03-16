`timescale 1ns / 1ps

module flipped_circuit_letter_dot(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
    
    parameter [3:0] line_thickness = 1;
    wire ready;
    assign draw = ready;
    
    // Single point for dot (a small circle or a pixel)
    line_generator L0 (pixel_index, x, y, x + 1, y, line_thickness, ready);
    
endmodule