`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:38:34
// Design Name: 
// Module Name: clock_generator
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


module clock_generator (input clk, input wire [31:0] COUNTER, output reg out = 0);

    reg [31:0] count = 0;
    always @ (posedge clk) begin
        count <= (count >= COUNTER) ? 0 : count + 1;
        out <= (count == 0) ? ~out : out;
    end
endmodule
