`timescale 1ns / 1ps

module Display_Typing(
    input clk,
    input program_locked,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [63:0] buffer,
    output [15:0] pixel_data
);

    reg [4:0] bit_index;
    reg end_flag;
    reg [3:0] bit_chunk;
    reg [7:0] char_buffer [0:15];
    reg [63:0] prev_buffer;
    reg should_store;
    wire [7:0] mapped_char;
    wire [127:0] char_buffer_flat;
    wire [2:0] current_row;
    wire [7:0] ascii_output;
    wire [7:0] bitmap_output;
    integer i;

    assign char_buffer_flat = {
        char_buffer[15], char_buffer[14], char_buffer[13], char_buffer[12],
        char_buffer[11], char_buffer[10], char_buffer[9],  char_buffer[8],
        char_buffer[7],  char_buffer[6],  char_buffer[5],  char_buffer[4],
        char_buffer[3],  char_buffer[2],  char_buffer[1],  char_buffer[0]
    };

    // Map 4-bit chunk to each char
    char_mapper map_chars (
        .bit_chunk(bit_chunk),
        .ascii_char(mapped_char)
    );

    // Display rendering
    printing_display print_logic (
        .clk(clk),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .ascii_array_flat(char_buffer_flat),
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
    always @(posedge clk) begin
        if (buffer != prev_buffer) begin
            prev_buffer <= buffer;
            bit_index <= 0;
            end_flag <= 0;
            should_store <= 0;

            for (i = 0; i < 16; i = i + 1)
                char_buffer[i] <= " ";
        end 
        else if (should_store) begin
            char_buffer[bit_index] <= mapped_char;
            bit_index <= bit_index + 1;
            should_store <= 0;
        end 
        else if (!end_flag && bit_index < 16) begin
            bit_chunk <= buffer[(63 - bit_index * 4) -: 4];
            if (buffer[(63 - bit_index * 4) -: 4] == 4'hF)
                end_flag <= 1;
            else
                should_store <= 1;
        end 
    end

endmodule
