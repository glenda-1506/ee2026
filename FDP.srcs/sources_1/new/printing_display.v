`timescale 1ns / 1ps
// DisplayRenderer.v
module printing_display(
    input clk,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [127:0] ascii_array_flat,
    input [7:0] char_bitmap_wire,
    input program_locked,
    output reg [15:0] pixel_data,
    output reg [2:0] current_row,
    output reg [7:0] ascii_char
);

    reg [7:0] ascii_array [0:15];
    integer i;
    integer idx;
    
    initial begin
        ascii_char     <= " ";
        pixel_data     <= 16'h0000;
    end
    

    // Unpack the flat vector into the array to be printed
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            ascii_array[i] = ascii_array_flat[i*8 +: 8];  
        end
    end

    always @(posedge clk) begin
        pixel_data <= 16'h0000;  // Default: black
        for (idx = 0; idx < 16; idx = idx + 1) begin
            if (idx < 10) begin
                // Top row of characters
                if ((x_addr >= (78 - idx*8)) && (x_addr < (86 - idx*8)) &&
                    (y_addr >= 30) && (y_addr < 38)) begin
                    current_row <= y_addr - 30;
                    ascii_char <= ascii_array[idx];
                    if (char_bitmap_wire[7 - (x_addr - (86 - idx*8))])
                        pixel_data <= (program_locked) ? 16'h07e0: 16'hFFFF;  // White pixel
                end
            end else begin
                // Bottom row of characters (6 remaining)
                if ((x_addr >= (78 - (idx - 8)*8)) && (x_addr < (86 - (idx - 8)*8)) &&
                    (y_addr >= 22) && (y_addr < 30)) begin
                    current_row <= y_addr - 22;
                    ascii_char <= ascii_array[idx];
                    if (char_bitmap_wire[7 - (x_addr - (86 - (idx - 8)*8))])
                        pixel_data <= (program_locked) ? 16'h07e0: 16'hFFFF;  // White pixel
                end
            end
        end
    end

endmodule