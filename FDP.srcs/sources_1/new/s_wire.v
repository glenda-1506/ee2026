`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 12:05:58 PM
// Design Name: 
// Module Name: s_wire
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


module s_wire#(
    parameter DISPLAY_WIDTH  = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter LENGTH_S_BOTTOM = 1,
    parameter LENGTH_VERTICAL = 1,
    parameter LENGTH_S_TOP = 1,
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
    output reg draw
    );
    reg is_used;
    wire [2:0] draw_wire;
    wire [X_BIT:0] midpoint = (x + LENGTH_S_BOTTOM);
    h_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, LENGTH_S_BOTTOM)
                      (x_addr, y_addr, x, y, draw_wire[0]);
    v_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, LENGTH_VERTICAL, 1'b0)
                      (x_addr, y_addr, midpoint, y, draw_wire[1]);
    h_line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT, LENGTH_S_TOP)
                      (x_addr, y_addr, midpoint, (y - (LENGTH_VERTICAL)), draw_wire[2]);
                      
    always @(posedge clk) begin
        if (enable) begin
            is_used <= 1'b1; //latch
        end else if (reset) begin
            is_used <= 1'b0;
        end
        
        draw <= is_used && |draw_wire;
    end
endmodule
