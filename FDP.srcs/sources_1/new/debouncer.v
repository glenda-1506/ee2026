`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 19:16:17
// Design Name: 
// Module Name: debounce
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

module debouncer (
    input clk,               
    input pb,               
    output reg debounced_pb    
);
    reg state = 0;
    reg [31:0] count = 0;
    
    always @(posedge clk) begin
        if (pb) begin
            state <= 1;
        end else if (count < 5_000_000 && count >= 1) begin
            state <= 1;
        end else begin
            state <= 0;
        end
        
        if (state) begin
            if (count < 5_000_000) begin
                count <= count + 1;
            end else begin
                count <= 5_000_000;
            end
        end else begin
            count <= 0;
        end
        
        debounced_pb <= state;
    end
endmodule




