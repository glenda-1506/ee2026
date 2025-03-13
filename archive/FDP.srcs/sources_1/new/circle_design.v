`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 22:22:40
// Design Name: 
// Module Name: circle_design
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


module circle_design (
    input [7:0] x,
    input [6:0] y,
    input [2:0] top_counter,
    input [2:0] middle_counter,
    input [2:0] bottom_counter,
    output reg [15:0] oled_out
);

    parameter CIRCLE_X_CENTER = 49;
    parameter CIRCLE_Y_CENTER = 56;
    parameter CIRCLE_RADIUS_SQ = 43;
    parameter ORANGE = 16'b11111_101000_00000;
    parameter RED = 16'b11111_000000_00000;   
    parameter BLACK = 16'b0;                  

    always @(*) begin
        if ((x - CIRCLE_X_CENTER) * (x - CIRCLE_X_CENTER) + 
            (y - CIRCLE_Y_CENTER) * (y - CIRCLE_Y_CENTER) <= CIRCLE_RADIUS_SQ) begin
            if (top_counter == 3'b100 && middle_counter == 3'b100 && bottom_counter == 3'b100) begin
                oled_out = ORANGE;
            end else if (top_counter == 3'b001 && middle_counter == 3'b001 && bottom_counter == 3'b001) begin
                oled_out = RED;
            end else begin
                oled_out = BLACK;
            end
        end else begin
            oled_out = BLACK;
        end
    end

endmodule

