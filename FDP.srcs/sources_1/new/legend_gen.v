`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 12:47:14 PM
// Design Name: 
// Module Name: legend_gen
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


module legend_gen#(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw,
    output draw_black
    );
    
    localparam integer WIDTH  = 39;
    localparam integer HEIGHT = 29;

    // Identify when we are inside the bounding box
    wire in_range = (x_addr >= x) && (x_addr < x + WIDTH) &&
                    (y_addr >= y) && (y_addr < y + HEIGHT);

    wire [$clog2(HEIGHT)-1:0] row_index = y_addr - y; 
    wire [$clog2(WIDTH)-1:0] column_index = x_addr - x;  

    // A function that returns the pattern for each row
    function [WIDTH-1:0] shape_row;
        input [$clog2(HEIGHT)-1:0] row;
        begin
            case (row)
                0  : shape_row = 39'b111111111111111111111111111111111111111;
                1  : shape_row = 39'b100000000000000000000000000000000000001;
                2  : shape_row = 39'b100000000000000000000000000000000000001;
                3  : shape_row = 39'b100000111010010111101111011110000100001;
                4  : shape_row = 39'b100001001010110000100001000010000100001;
                5  : shape_row = 39'b100001001011110111101101011110000100001;
                6  : shape_row = 39'b100001001011010000101001000010000100001; 
                7  : shape_row = 39'b100000111010010111101111011110111100001; 
                8  : shape_row = 39'b100000000000000000000000000000000000001; 
                9  : shape_row = 39'b100001111111111111111111111111111100001; 
                10 : shape_row = 39'b100000000000000000000000000000000000001;
                11 : shape_row = 39'b100000000000000000000000000000000000001;
                12 : shape_row = 39'b100111110000000111110000000111110000001;
                13 : shape_row = 39'b100000010011000100010011000100010011001;
                14 : shape_row = 39'b100000010011000111110011000111110011001;
                15 : shape_row = 39'b100000010011000100010011000100010011001;
                16 : shape_row = 39'b100111110000000111110000000100010000001;
                17 : shape_row = 39'b100000000000000000000000000000000000001;
                18 : shape_row = 39'b100000000000000000000000000000000000001;
                19 : shape_row = 39'b100111110000000111110000000111110000001;
                20 : shape_row = 39'b100000000000000000000000000000000000001;
                21 : shape_row = 39'b100111110000000111110000000111110000001;
                22 : shape_row = 39'b100000010011000100010011000100010011001;
                23 : shape_row = 39'b100000010011000111110011000111110011001;
                24 : shape_row = 39'b100000010011000100010011000100010011001;
                25 : shape_row = 39'b100111110000000111110000000100010000001;
                26 : shape_row = 39'b100000000000000000000000000000000000001; 
                27 : shape_row = 39'b100000000000000000000000000000000000001; 
                28 : shape_row = 39'b111111111111111111111111111111111111111; 
                default: shape_row = 39'b000000000000000000000000000000000000000;
            endcase
        end
    endfunction

    wire [WIDTH-1:0] row = shape_row(row_index);
    wire pixel_on = in_range ? row[column_index] : 1'b0;

    assign draw = pixel_on;
    assign draw_black = in_range ? ~row[column_index] : 1'b0;
    
endmodule
