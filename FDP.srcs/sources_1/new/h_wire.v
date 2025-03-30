`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 12:19:56 AM
// Design Name: 
// Module Name: h_wire
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


module h_wire#(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter LENGTH = 1,
    parameter [0:0] IS_RIGHT_DIR = 1'b1,
    parameter LINE_THICKNESS = 1,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input clk,
    input reset,
    input enable,
    input [X_BIT:0] x_addr,
    input [Y_BIT:0] y_addr,
    input [X_BIT:0] x,      
    input [Y_BIT:0] y, 
    output reg draw,
    output reg is_used
    );
    wire draw_wire;
    h_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, LENGTH)  (x_addr, y_addr, x, y, draw_wire);
    
    always @(posedge clk) begin
        if (enable) begin
            is_used <= 1'b1; //latch
        end else if (reset) begin
            is_used <= 1'b0;
        end
        
        draw <= draw_wire && is_used;
    end
endmodule
