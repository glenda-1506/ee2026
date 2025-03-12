`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 01:26:41 AM
// Design Name: 
// Module Name: circle4a_design
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


module circle4a_design(
    input [6:0] x,
    input [5:0] y,
    input active,
    input [6:0] outer_diameter,
    input [6:0] inner_diameter,
    output reg [15:0] circle_output
);
    parameter CENTER_X = 48;
    parameter CENTER_Y = 32;
    parameter GREEN = 16'h07E0;

    integer dist_squared, outer_sq, inner_sq;

    always @(*) begin
        dist_squared = (x - CENTER_X) * (x - CENTER_X) + (y - CENTER_Y) * (y - CENTER_Y);
        outer_sq = (outer_diameter / 2) * (outer_diameter / 2);
        inner_sq = (inner_diameter / 2) * (inner_diameter / 2);

        if (active && dist_squared <= outer_sq && dist_squared >= inner_sq)
            circle_output = GREEN;
        else
            circle_output = 16'h0000;
    end
endmodule
