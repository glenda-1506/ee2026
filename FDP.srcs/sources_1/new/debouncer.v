`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2025 07:47:35 AM
// Design Name: 
// Module Name: debouncer
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
// Time_delay = count_max / clk_freq 
// Units: seconds
//////////////////////////////////////////////////////////////////////////////////

module debouncer(
    input clk,
    input pb,
    input [31:0] count_max,
    output reg debounced_pb
    );

    reg [31:0] count = 0;

    always @(posedge clk) begin
        if (pb == debounced_pb) begin
            count <= 0;
        end
        else begin
            if (count < count_max)
                count <= count + 1;
            else begin
                debounced_pb <= pb;
                count <= 0;
            end
        end
    end
endmodule