`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 02:38:47 PM
// Design Name: 
// Module Name: h_line_generator
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


module h_line_generator#(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter LENGTH = 1,
    parameter [0:0] IS_RIGHT_DIR = 1'b1,
    parameter LINE_THICKNESS = 1,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input [X_BIT:0] x_addr,
    input [Y_BIT:0] y_addr,
    input [X_BIT:0] x,      
    input [Y_BIT:0] y, 
    output draw
    );
    
    localparam integer BOX_WIDTH  = LENGTH + 1;
    localparam integer BOX_HEIGHT = LINE_THICKNESS;
    wire [X_BIT:0] x_end = IS_RIGHT_DIR ? x : (x - LENGTH);
    
    // Identify when inside the bounding box.
    wire in_range = (x_addr >= x_end) && (x_addr < x_end + BOX_WIDTH) &&
                    (y_addr >= y) && (y_addr < y + BOX_HEIGHT);
                    
    // box coordinates
    wire [$clog2(BOX_HEIGHT)-1:0] row_index = y_addr - y;
    wire [$clog2(BOX_WIDTH)-1:0] column_index = x_addr - x_end;
    
    function [BOX_WIDTH-1:0] shape_row;
        input [$clog2(BOX_HEIGHT)-1:0] row;
        begin
            shape_row = {BOX_WIDTH{1'b1}};
        end
    endfunction
    
    wire [BOX_WIDTH-1:0] pattern = shape_row(row_index);
    wire pixel_on = in_range ? pattern[column_index] : 1'b0;
    assign draw = pixel_on;
    
endmodule
