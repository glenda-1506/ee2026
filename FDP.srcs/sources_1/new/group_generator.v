`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 01:40:23 PM
// Design Name: 
// Module Name: group_generator
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


module group_generator(
    input password_is_correct,
    input [12:0] pixel_index,
    output ready
    );
    
    wire [3:0] zero_ready;
    wire [4:0] two_ready;
    assign ready = password_is_correct ? 0 : (zero_ready || two_ready);
    
    // Produce a '0'
    rectangle_generator zero_left (
        .pixel_index(pixel_index),
        .x_start(9),
        .y_start(9),
        .x_size(6),
        .y_size(46),
        .ready(zero_ready[3]));
        
    rectangle_generator zero_right (
        .pixel_index(pixel_index),
        .x_start(35),
        .y_start(9),
        .x_size(6),
        .y_size(46),
        .ready(zero_ready[2]));
    
    rectangle_generator zero_top (
        .pixel_index(pixel_index),
        .x_start(15),
        .y_start(9),
        .x_size(20),
        .y_size(6),
        .ready(zero_ready[1]));
        
    rectangle_generator zero_bottom (
        .pixel_index(pixel_index),
        .x_start(15),
        .y_start(49),
        .x_size(20),
        .y_size(6),
        .ready(zero_ready[0]));
    
    // Produce a '2'
    rectangle_generator two_top_line (
        .pixel_index(pixel_index),
        .x_start(51),
        .y_start(9),
        .x_size(32),
        .y_size(6),
        .ready(two_ready[4]));
        
   rectangle_generator two_middle_line (
        .pixel_index(pixel_index),
        .x_start(51),
        .y_start(29),
        .x_size(32),
        .y_size(6),
        .ready(two_ready[3]));     
    
    rectangle_generator two_bottom_line (
        .pixel_index(pixel_index),
        .x_start(51),
        .y_start(49),
        .x_size(32),
        .y_size(6),
        .ready(two_ready[2]));
   
   rectangle_generator two_right_line (
        .pixel_index(pixel_index),
        .x_start(77),
        .y_start(15),
        .x_size(6),
        .y_size(14),
        .ready(two_ready[1])); 
        
   rectangle_generator two_left_line (
        .pixel_index(pixel_index),
        .x_start(51),
        .y_start(35),
        .x_size(6),
        .y_size(14),
        .ready(two_ready[0]));                    
endmodule
