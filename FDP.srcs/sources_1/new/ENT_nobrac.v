`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 02:38:36 PM
// Design Name: 
// Module Name: ENT_nobrac
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


module ENT_nobrac(
    input  [6:0] x,
    input  [5:0] y,
    input  [6:0] sx,
    input  [5:0] sy,
    input  [7:0] symbol,
    output reg pixel_on
    );
    
    reg [21:0] row_pattern; //22 by 22 square
    
    always @(*) begin
        row_pattern = 22'b0;
        pixel_on = 1'b0;
        if ((x >= sx) && (x < sx + 22) &&
            (y >= sy) && (y < sy + 22)) begin
            case (y - sy)
                0: row_pattern = 22'b0000000000000000000000;
                1: row_pattern = 22'b0000000000000000000000;
                2: row_pattern = 22'b0000000000000000000000;
                3: row_pattern = 22'b0000000000000000000000;
                4: row_pattern = 22'b0000000000000011110000;
                5: row_pattern = 22'b0000000000000011110000;
                6: row_pattern = 22'b0000000010000011110000;
                7: row_pattern = 22'b0000000110000011110000;
                8: row_pattern = 22'b0000001110000011110000;
                9: row_pattern = 22'b0000011110000011110000;
                10: row_pattern = 22'b0000111111111111110000;
                11: row_pattern = 22'b0001111111111111110000;
                12: row_pattern = 22'b0001111111111111110000;
                13: row_pattern = 22'b0000111111111111110000;
                14: row_pattern = 22'b0000011110000000000000;
                15: row_pattern = 22'b0000001110000000000000;
                16: row_pattern = 22'b0000000110000000000000;
                17: row_pattern = 22'b0000000010000000000000;
                18: row_pattern = 22'b0000000000000000000000;
                19: row_pattern = 22'b0000000000000000000000;
                20: row_pattern = 22'b0000000000000000000000;
                21: row_pattern = 22'b0000000000000000000000;
                default: row_pattern = 22'b0;
            endcase
            
            pixel_on = row_pattern[22 - 1 - (x - sx)];
        end
    end
endmodule
