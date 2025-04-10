`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2025 02:49:14 PM
// Design Name: 
// Module Name: invalid_screen_generator
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


module invalid_screen_generator#(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr,
    input [Y_BIT:0] y_addr,
    output draw
    );

    localparam integer MARGIN = 5;
    localparam integer LETTER_W = 9;
    localparam integer LETTER_H = 8;
    localparam integer NUM_LETTERS = 7;  // I, N, V, A, L, I, D
    localparam integer GAP = 2;
    localparam integer TOTAL_W = (LETTER_W * NUM_LETTERS) + (GAP * (NUM_LETTERS - 1)); // 75
    localparam integer TOTAL_H = LETTER_H; // 8
    localparam integer USABLE_W = DISPLAY_WIDTH - 2 * MARGIN; // 86
    localparam integer USABLE_H = DISPLAY_HEIGHT - 2 * MARGIN; // 54
    localparam integer START_X = MARGIN + (USABLE_W - TOTAL_W) / 2;
    localparam integer START_Y = MARGIN + (USABLE_H - TOTAL_H) / 2; 
    
    // check whether in range of bounding box
    wire in_range = (x_addr >= START_X) && (x_addr < START_X + TOTAL_W) 
                 && (y_addr >= START_Y) && (y_addr < START_Y + TOTAL_H);
    
    // row_in in [0..7], col_in in [0..74]
    wire [2:0] row_in = y_addr - START_Y; // 0..7
    wire [6:0] col_in = x_addr - START_X; // 0..74
    wire [2:0] letter_index = col_in / (LETTER_W + GAP);
    wire [3:0] letter_col = col_in % (LETTER_W + GAP); 
    wire in_letter = (letter_col < LETTER_W);
    
    function [8:0] letter_bitmap;
        input [2:0] letter; // which letter
        input [2:0] row;    // row [0..7]
        begin
            // default blank
            letter_bitmap = 9'b000000000;
            case (letter)
                // 0 => 'I', 5 => 'I' again.
                3'd0, 3'd5: begin
                    case (row)
                        0: letter_bitmap = 9'b111111111;
                        1: letter_bitmap = 9'b111111111;
                        2: letter_bitmap = 9'b000111000;
                        3: letter_bitmap = 9'b000111000;
                        4: letter_bitmap = 9'b000111000;
                        5: letter_bitmap = 9'b000111000;
                        6: letter_bitmap = 9'b111111111;
                        7: letter_bitmap = 9'b111111111;
                    endcase
                end
    
                // 1 => 'N'
                3'd1: begin
                    case (row)
                        0: letter_bitmap = 9'b110000111; 
                        1: letter_bitmap = 9'b110001111;
                        2: letter_bitmap = 9'b110011111;
                        3: letter_bitmap = 9'b110111111;
                        4: letter_bitmap = 9'b111111011;
                        5: letter_bitmap = 9'b111110011;
                        6: letter_bitmap = 9'b111100011;
                        7: letter_bitmap = 9'b111000011;
                    endcase
                end
    
                // 2 => 'V'
                3'd2: begin
                    case (row)
                        0: letter_bitmap = 9'b110000011; 
                        1: letter_bitmap = 9'b110000011;
                        2: letter_bitmap = 9'b111000111;
                        3: letter_bitmap = 9'b011000110;
                        4: letter_bitmap = 9'b011101110;
                        5: letter_bitmap = 9'b001101100;
                        6: letter_bitmap = 9'b001111100;
                        7: letter_bitmap = 9'b000111000;
                    endcase
                end
    
                // 3 => 'A'
                3'd3: begin
                    case (row)
                        0: letter_bitmap = 9'b001111100; 
                        1: letter_bitmap = 9'b011101110;
                        2: letter_bitmap = 9'b111000111;
                        3: letter_bitmap = 9'b110000011;
                        4: letter_bitmap = 9'b111111111;
                        5: letter_bitmap = 9'b111111111;
                        6: letter_bitmap = 9'b110000011;
                        7: letter_bitmap = 9'b110000011;
                    endcase
                end
    
                // 4 => 'L'
                3'd4: begin
                    case (row)
                        0: letter_bitmap = 9'b000000011; 
                        1: letter_bitmap = 9'b000000011;
                        2: letter_bitmap = 9'b000000011;
                        3: letter_bitmap = 9'b000000011;
                        4: letter_bitmap = 9'b000000011;
                        5: letter_bitmap = 9'b000000011;
                        6: letter_bitmap = 9'b111111111;
                        7: letter_bitmap = 9'b111111111;
                    endcase
                end
    
                // 6 => 'D'
                3'd6: begin
                    case (row)
                        0: letter_bitmap = 9'b001111111; 
                        1: letter_bitmap = 9'b011111111;
                        2: letter_bitmap = 9'b111100011;
                        3: letter_bitmap = 9'b111000011;
                        4: letter_bitmap = 9'b111000011;
                        5: letter_bitmap = 9'b111100011;
                        6: letter_bitmap = 9'b011111111;
                        7: letter_bitmap = 9'b001111111;
                    endcase
                end
            endcase
        end
    endfunction
    
    wire [8:0] letter_row_bits = letter_bitmap(letter_index, row_in);
    wire pixel_on = in_range && in_letter && letter_row_bits[letter_col];
    
    assign draw = pixel_on;

endmodule

