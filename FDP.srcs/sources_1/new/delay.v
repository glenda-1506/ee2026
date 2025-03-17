`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 06:36:23 PM
// Design Name: 
// Module Name: single_pulse_debouncer
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
// time_in_s = 1 / clk * delay_count
//////////////////////////////////////////////////////////////////////////////////

module delay(
    input clk,
    input in,
    input [31:0] delay_count,
    output reg pulse_out
    );
    
    reg [31:0] count = 0;
    always @(posedge clk) begin
        if (!in) begin
            count <= 0;
            pulse_out <= 0;
        end else begin
            if (count < delay_count) begin
                count <= count + 1;
                pulse_out <= 0;
            end else begin
                pulse_out <= 1;
                count <= 0;
            end
        end
    end
endmodule
