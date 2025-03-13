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


module button_updown(
    input clk,
    input reset,
    input btnU,
    input btnD,
    input active,
    output reg [6:0] outer_diameter = 30,
    output reg [6:0] inner_diameter = 25
);
    reg btnU_prev = 0;
    reg btnD_prev = 0;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            outer_diameter <= 30;
            inner_diameter <= 25;
            btnU_prev <= 0;
            btnD_prev <= 0;
        end else begin
            btnU_prev <= btnU;
            btnD_prev <= btnD;

            if (active) begin
                if (btnU && !btnU_prev && outer_diameter < 50) begin
                    outer_diameter <= outer_diameter + 5;
                    inner_diameter <= inner_diameter + 5;
                end
                if (btnD && !btnD_prev && outer_diameter > 10) begin
                    outer_diameter <= outer_diameter - 5;
                    inner_diameter <= inner_diameter - 5;
                end
            end
        end
    end
endmodule

