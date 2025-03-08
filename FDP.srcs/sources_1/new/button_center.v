`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 01:23:30 AM
// Design Name: 
// Module Name: button_updown
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


module button_center(
    input clk,
    input reset,
    input btnC,
    output reg active = 0
);
    reg btnC_prev = 0;
    reg locked = 0;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            active <= 0;
            locked <= 0;
            btnC_prev <= 0;
        end else begin
            btnC_prev <= btnC; 

            if (!btnC_prev && btnC && !locked) begin
                active <= 1;
                locked <= 1;
            end
        end
    end
endmodule
