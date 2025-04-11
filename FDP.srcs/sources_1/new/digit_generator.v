`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 08:27:30 PM
// Design Name: 
// Module Name: digit_generator
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

module digit_generator #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y, 
    input [3:0] id, 
    output draw
    );
    
    localparam integer WIDTH  = 10;
    localparam integer HEIGHT = 10;

    // Identify when we are inside the bounding box
    wire in_range = (x_addr >= x) && (x_addr < x + WIDTH) &&
                    (y_addr >= y) && (y_addr < y + HEIGHT);

    wire [$clog2(HEIGHT)-1:0] row_index = y_addr - y; 
    wire [$clog2(WIDTH)-1:0] column_index = x_addr - x;  
    wire [WIDTH-1:0] row = shape_row(row_index, id);
    wire pixel_on = in_range ? row[column_index] : 1'b0;
    assign draw = pixel_on;

    // A function that returns the pattern for each row
    function [WIDTH-1:0] shape_row;
        input [$clog2(HEIGHT)-1:0] row;
        input [3:0] id; 
        begin
            if (id == 0) begin
                case (row)
                    4'd0 : shape_row = 10'b0011111100;
                    4'd1 : shape_row = 10'b0111111110;
                    4'd2 : shape_row = 10'b1100000011;
                    4'd3 : shape_row = 10'b1100000011;
                    4'd4 : shape_row = 10'b1100000011;
                    4'd5 : shape_row = 10'b1100000011;
                    4'd6 : shape_row = 10'b1100000011;
                    4'd7 : shape_row = 10'b1100000011;
                    4'd8 : shape_row = 10'b0111111110;
                    4'd9 : shape_row = 10'b0011111100; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 1) begin
                case (row)
                    4'd0 : shape_row = 10'b0001110000;
                    4'd1 : shape_row = 10'b0001111000;
                    4'd2 : shape_row = 10'b0001111100;
                    4'd3 : shape_row = 10'b0001111110;
                    4'd4 : shape_row = 10'b0001110000;
                    4'd5 : shape_row = 10'b0001110000;
                    4'd6 : shape_row = 10'b0001110000;
                    4'd7 : shape_row = 10'b0001110000;
                    4'd8 : shape_row = 10'b1111111111;
                    4'd9 : shape_row = 10'b1111111111; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 2) begin
                case (row)
                    4'd0 : shape_row = 10'b1111111111;
                    4'd1 : shape_row = 10'b1111111111;
                    4'd2 : shape_row = 10'b1110000000;
                    4'd3 : shape_row = 10'b1110000000;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b0000000111;
                    4'd7 : shape_row = 10'b0000000111;
                    4'd8 : shape_row = 10'b1111111111;
                    4'd9 : shape_row = 10'b1111111111; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 3) begin
                case (row)
                    4'd0 : shape_row = 10'b1111111111;
                    4'd1 : shape_row = 10'b1111111111;
                    4'd2 : shape_row = 10'b1110000000;
                    4'd3 : shape_row = 10'b1110000000;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b1110000000;
                    4'd7 : shape_row = 10'b1110000000;
                    4'd8 : shape_row = 10'b1111111111;
                    4'd9 : shape_row = 10'b1111111111; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 4) begin
                case (row)
                    4'd0 : shape_row = 10'b1110000111;
                    4'd1 : shape_row = 10'b1110000111;
                    4'd2 : shape_row = 10'b1110000111;
                    4'd3 : shape_row = 10'b1110000111;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b1111111111;
                    4'd7 : shape_row = 10'b1110000000;
                    4'd8 : shape_row = 10'b1110000000;
                    4'd9 : shape_row = 10'b1110000000; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 5) begin
                case (row)
                    4'd0 : shape_row = 10'b1111111111;
                    4'd1 : shape_row = 10'b1111111111;
                    4'd2 : shape_row = 10'b0000000111;
                    4'd3 : shape_row = 10'b0000000111;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b1110000000;
                    4'd7 : shape_row = 10'b1110000000;
                    4'd8 : shape_row = 10'b1111111111;
                    4'd9 : shape_row = 10'b1111111111; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 6) begin
                case (row)
                    4'd0 : shape_row = 10'b1111111111;
                    4'd1 : shape_row = 10'b1111111111;
                    4'd2 : shape_row = 10'b0000000111;
                    4'd3 : shape_row = 10'b0000000111;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b1110000111;
                    4'd7 : shape_row = 10'b1110000111;
                    4'd8 : shape_row = 10'b1111111111;
                    4'd9 : shape_row = 10'b1111111111; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 7) begin
                case (row)
                    4'd0 : shape_row = 10'b1111111111;
                    4'd1 : shape_row = 10'b1111111111;
                    4'd2 : shape_row = 10'b1111111111;
                    4'd3 : shape_row = 10'b1111000000;
                    4'd4 : shape_row = 10'b0111100000;
                    4'd5 : shape_row = 10'b0011110000;
                    4'd6 : shape_row = 10'b0001111000;
                    4'd7 : shape_row = 10'b0000111100;
                    4'd8 : shape_row = 10'b0000011110;
                    4'd9 : shape_row = 10'b0000001111; 
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 8) begin
                case (row)
                    4'd0 : shape_row = 10'b0011111100;
                    4'd1 : shape_row = 10'b0111111110;
                    4'd2 : shape_row = 10'b1100000011;
                    4'd3 : shape_row = 10'b1100000011;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b1100000011;
                    4'd7 : shape_row = 10'b1100000011;
                    4'd8 : shape_row = 10'b0111111110;
                    4'd9 : shape_row = 10'b0011111100;  
                    default: shape_row = 10'b0000000000;
                endcase
            end else if (id == 9) begin
                case (row)
                    4'd0 : shape_row = 10'b1111111111;
                    4'd1 : shape_row = 10'b1111111111;
                    4'd2 : shape_row = 10'b1110000111;
                    4'd3 : shape_row = 10'b1110000111;
                    4'd4 : shape_row = 10'b1111111111;
                    4'd5 : shape_row = 10'b1111111111;
                    4'd6 : shape_row = 10'b1110000000;
                    4'd7 : shape_row = 10'b1110000000;
                    4'd8 : shape_row = 10'b1111111111;
                    4'd9 : shape_row = 10'b1111111111;  
                    default: shape_row = 10'b0000000000;
                endcase
            end else shape_row = 10'b0000000000;
        end
    endfunction
endmodule