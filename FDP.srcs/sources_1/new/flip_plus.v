`timescale 1ns / 1ps

module flipped_circuit_letter_plus(
    input [12:0] pixel_index, 
    input [6:0]  x,                     
    input [5:0]  y,  
    output draw
    );
    
    parameter [3:0] line_thickness = 1;
    wire [4:0] ready;
    assign draw = |ready;
    
    // Vertical line of plus sign
    line_generator L0 (pixel_index, x + 2, y, x + 2, y + 4, line_thickness, ready[0]);
    
    // Horizontal line of plus sign
    line_generator L1 (pixel_index, x, y + 2, x + 4, y + 2, line_thickness, ready[1]);
    
endmodule