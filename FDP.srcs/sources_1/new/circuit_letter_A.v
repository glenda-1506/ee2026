`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 04:07:31 AM
// Design Name: 
// Module Name: circuit_letter_A
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


module circuit_letter_A #(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    output draw
    );
    
    localparam integer WIDTH  = 5;
    localparam integer HEIGHT = 5;

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
                4'd0 : shape_row = 5'b11111;
                4'd1 : shape_row = 5'b10001;
                4'd2 : shape_row = 5'b11111;
                4'd3 : shape_row = 5'b10001;
                4'd4 : shape_row = 5'b10001;
                default: shape_row = 5'b00000;
            endcase
        end
    endfunction

    wire [WIDTH-1:0] row = shape_row(row_index);
    wire pixel_on = in_range ? row[column_index] : 1'b0;

    assign draw = pixel_on;
endmodule
