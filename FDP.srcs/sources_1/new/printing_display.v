`timescale 1ns / 1ps

module printing_display #(
    parameter MAX_CHAR = 32,
    parameter CHAR_ARRAY_BIT = 255
    )(
    input clk,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [CHAR_ARRAY_BIT:0] char_buffer_array,  
    input [7:0] char_bitmap_wire,
    input program_locked,
    output reg [15:0] pixel_data,
    output reg [2:0] current_row,
    output reg [7:0] ascii_char
);

    reg [7:0] ascii_array [0:MAX_CHAR - 1];
    wire [15:0] left_disp;
    integer i;
    integer pos;
    integer row, col;
    integer j;  

    initial begin
        ascii_char     <= " ";
        pixel_data     <= 16'h0000;
    end
    
    initial_left_display init_left_disp (
        .x_addr(x_addr),
        .y_addr(y_addr),
        .pixel_data(left_disp)
    );

    always @(*) begin
        for (i = 0; i < MAX_CHAR; i = i + 1) begin
            ascii_array[i] = char_buffer_array[i*8 +: 8];  
        end
    end

    always @(posedge clk) begin
        pixel_data <= left_disp;
        
        for (pos = 0; pos < MAX_CHAR; pos = pos + 1) begin
            row = pos / 8;
            col = pos % 8;
            j = 38 - (row * 8);
            if ((x_addr >= (70 - col*8)) && (x_addr < (78 - col*8)) &&
                (y_addr >= j) && (y_addr < (j + 8))) begin
                current_row <= y_addr - j;
                ascii_char <= ascii_array[pos];
                if (char_bitmap_wire[7 - (x_addr - (78 - col*8))])
                    pixel_data <= (program_locked) ? 16'h07e0 : 16'hFFFF;
            end
        end
    end

endmodule
