`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 04:24:29 PM
// Design Name: 
// Module Name: update_state_output_D
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


module update_state_output_D#(
    parameter CHAR_ARRAY_BIT = 319
    )(
    input clk,
    input [147:0] buffer,
    input [7:0] mapped_char,
    output reg [CHAR_ARRAY_BIT:0] char_buffer_array
);
    reg [5:0] bit_index;
    reg end_flag;
    reg [3:0] bit_chunk;
    reg [7:0] char_buffer [0:39];
    reg [CHAR_ARRAY_BIT:0] prev_buffer;
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
            for (i = 0; i <40; i = i + 1)
                char_buffer[i] <= " ";
        end 
        else if (should_store) begin
            char_buffer[bit_index] <= mapped_char;
            bit_index <= bit_index + 1;
            should_store <= 0;
        end 
        else if (!end_flag && bit_index < 40) begin
            bit_chunk <= buffer[(147 - bit_index * 4) -: 4];
            if (buffer[(147 - bit_index * 4) -: 4] == 4'hF)
                end_flag <= 1;
            else
                should_store <= 1;
        end 
    end

    always @(*) begin
        char_buffer_array = {
            char_buffer[39], char_buffer[38], char_buffer[37], char_buffer[36],
            char_buffer[35], char_buffer[34], char_buffer[33], char_buffer[32],
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