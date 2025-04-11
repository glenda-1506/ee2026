`timescale 1ns / 1ps

module Display_Typing(
    input clk,
    input program_locked,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [127:0] buffer,
    output [15:0] pixel_data
);

    reg [4:0] bit_index;
    reg end_flag;
    reg [3:0] bit_chunk;
    reg [7:0] char_buffer [0:31];
    reg [255:0] prev_buffer;
    reg should_store;
    wire [7:0] mapped_char;
    wire [255:0] char_buffer_array;
    wire [2:0] current_row;
    wire [7:0] ascii_output;
    wire [7:0] bitmap_output;
    integer i;

    // Display rendering
    printing_display print_logic (
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
    update_state_output update_next (
        .clk(clk),
        .buffer(buffer),
        .mapped_char(mapped_char),
        .char_buffer_array(char_buffer_array)
    );
endmodule
