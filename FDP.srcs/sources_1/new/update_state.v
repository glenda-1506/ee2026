`timescale 1ns / 1ps

module Typing_StateUpdate(
    input clk,
    input [127:0] buffer,
    input [7:0] mapped_char,
    output reg [4:0] bit_index,
    output reg end_flag,
    output reg [3:0] bit_chunk,
    output reg [255:0] char_buffer_flat,
    output reg [255:0] prev_buffer,
    output reg should_store
);

    integer i;

    reg [7:0] char_buffer [0:31];

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

        // Flatten the array on every clock tick
        char_buffer_flat <= {
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
