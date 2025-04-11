`timescale 1ns / 1ps

module update_module(
    input clk,
    input [63:0] buffer,
    input [7:0] mapped_char,
    output [127:0] char_buffer_flat 
);
    reg [7:0] char_buffer [0:15];
    reg [4:0] bit_index;
    reg end_flag;
    reg [3:0] bit_chunk;
    reg [63:0] prev_buffer;
    reg should_store;
    integer i;
    
    assign char_buffer_flat = {
            char_buffer[15], char_buffer[14], char_buffer[13], char_buffer[12],
            char_buffer[11], char_buffer[10], char_buffer[9],  char_buffer[8],
            char_buffer[7],  char_buffer[6],  char_buffer[5],  char_buffer[4],
            char_buffer[3],  char_buffer[2],  char_buffer[1],  char_buffer[0]
        };
        
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
            bit_chunk <= buffer[(63 - bit_index*4) -: 4];
            if (buffer[(63 - bit_index*4) -: 4] == 4'hF)
                end_flag <= 1;
            else
                should_store <= 1;
        end 
    end

endmodule
