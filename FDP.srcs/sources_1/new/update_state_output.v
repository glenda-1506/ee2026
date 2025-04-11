`timescale 1ns / 1ps

module update_state_output (
    input clk,
    input [127:0] buffer,
    input [7:0] mapped_char,
    output reg [255:0] char_buffer_array
);
    reg [4:0] bit_index;
    reg end_flag;
    reg [3:0] bit_chunk;
    reg [7:0] char_buffer [0:31];
    reg [255:0] prev_buffer;
    reg should_store;
    integer i;
    
    // Map 4-bit chunk to each char
    char_mapper map_chars (
        .bit_chunk(bit_chunk),
        .ascii_char(mapped_char)
    );

    always @(posedge clk) begin
        if (buffer != prev_buffer) begin
            prev_buffer <= buffer;
            bit_index <= 0;
            end_flag <= 0;
            should_store <= 0;
            for (i = 0; i < 32; i = i + 1)
                char_buffer[i] <= " ";
        end 
        else if (should_store) begin
            char_buffer[bit_index] <= mapped_char;
            bit_index <= bit_index + 1;
            should_store <= 0;
        end 
        else if (!end_flag && bit_index < 32) begin
            bit_chunk <= buffer[(127 - bit_index * 4) -: 4];
            if (buffer[(127 - bit_index * 4) -: 4] == 4'hF)
                end_flag <= 1;
            else
                should_store <= 1;
        end 
    end

    always @(*) begin
        char_buffer_array = {
            char_buffer[31], char_buffer[30], char_buffer[29], char_buffer[28],
            char_buffer[27], char_buffer[26], char_buffer[25], char_buffer[24],
            char_buffer[23], char_buffer[22], char_buffer[21], char_buffer[20],
            char_buffer[19], char_buffer[18], char_buffer[17], char_buffer[16],
            char_buffer[15], char_buffer[14], char_buffer[13], char_buffer[12],
            char_buffer[11], char_buffer[10], char_buffer[9],  char_buffer[8],
            char_buffer[7],  char_buffer[6],  char_buffer[5],  char_buffer[4],
            char_buffer[3],  char_buffer[2],  char_buffer[1],  char_buffer[0]
        };
    end

endmodule
