`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 02:31:05 PM
// Design Name: 
// Module Name: Display_Typing_D
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


module Display_Typing_D#(
    parameter MAX_CHAR = 40,
    parameter CHAR_ARRAY_BIT = 319
    )(
    input clk,
    input program_locked,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [147:0] buffer,
    output [15:0] pixel_data
);

    reg [5:0] bit_index;
    reg end_flag;
    reg [3:0] bit_chunk;
    reg [7:0] char_buffer [0:MAX_CHAR-1];
    reg [CHAR_ARRAY_BIT:0] prev_buffer;
    reg should_store;
    wire [7:0] mapped_char;
    wire [CHAR_ARRAY_BIT:0] char_buffer_array;
    wire [2:0] current_row;
    wire [7:0] ascii_output;
    wire [7:0] bitmap_output;
    integer i;

    // Display rendering
    printing_display #(MAX_CHAR, CHAR_ARRAY_BIT) print_logic  (
        .clk(clk),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .char_buffer_array(char_buffer_array),
        .pixel_data(pixel_data),
        .current_row(current_row),
        .ascii_char(ascii_output),
        .char_bitmap_wire(bitmap_output),
        .program_locked(program_locked)
    );

    // Bitmap lookup
    character_bitmap bitmap_lut (
        .char(ascii_output),
        .row(current_row),
        .get_character_bitmap(bitmap_output)
    );
    
    // Updating the next state and output
    update_state_output_D  #(CHAR_ARRAY_BIT) update_next(
        .clk(clk),
        .buffer(buffer),
        .mapped_char(mapped_char),
        .char_buffer_array(char_buffer_array)
    );
endmodule
