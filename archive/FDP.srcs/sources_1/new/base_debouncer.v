`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 10:25:09 AM
// Design Name: 
// Module Name: base_debouncer
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


module base_debouncer(
    input clk,
    input pb,
    input [31:0] count_max,
    output reg debounced_pb
    );
    
    reg [31:0] count = 0;
    always @(posedge clk) begin
        if (pb || (count != 0 && count < count_max)) begin
            debounced_pb <= 1;
            if (count < count_max) begin
                count <= count + 1;
            end
            else begin
                debounced_pb <= 0;
                count <= 0;
            end
        end
    end
endmodule
