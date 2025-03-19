`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 11:55:26 PM
// Design Name: 
// Module Name: circle_generator_no_mult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Circle generator without using multiplication operators
//              at runtime. Instead, a lookup table (ROM) is used to retrieve
//              the square of a value.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module circle_generator #(
    parameter DISPLAY_WIDTH = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter MAX_SQUARE_DISTANCE = ((DISPLAY_WIDTH-1) * (DISPLAY_WIDTH-1)) + 
                                    ((DISPLAY_HEIGHT-1) * (DISPLAY_HEIGHT-1)),
    parameter DIST_BIT = $clog2(MAX_SQUARE_DISTANCE + 1) - 1,
    parameter SQUARE_SIZE = (1 << (X_BIT+1))
)(
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0] center_x,      
    input [Y_BIT:0] center_y,          
    input [X_BIT:0] radius,    
    input [X_BIT:0] max_diff, // adjust according to the radius
    output draw
);

    reg [DIST_BIT:0] square_rom [0:SQUARE_SIZE-1];
    integer i;
    initial begin
        for (i = 0; i < SQUARE_SIZE; i = i + 1) begin
            square_rom[i] = i * i;
        end
    end

    wire [X_BIT:0] dx = (x_addr >= center_x) ? (x_addr - center_x) : (center_x - x_addr);
    wire [Y_BIT:0] dy = (y_addr >= center_y) ? (y_addr - center_y) : (center_y - y_addr);
    wire [DIST_BIT:0] dx_sq = square_rom[dx];
    wire [DIST_BIT:0] dy_sq = square_rom[dy];
    wire [DIST_BIT:0] dist_sq = dx_sq + dy_sq;
    wire [DIST_BIT:0] radius_sq = square_rom[radius];
    wire [DIST_BIT:0] diff = (dist_sq >= radius_sq) ? (dist_sq - radius_sq) : (radius_sq - dist_sq);
    assign draw = (diff <= max_diff);
    
endmodule
