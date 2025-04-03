`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 08:18:43 PM
// Design Name: 
// Module Name: symbolLBrac
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


module symbolLBrac(
    input  [6:0] x,
    input  [5:0] y,
    input  [6:0] sx,
    input  [5:0] sy,
    input  [7:0] symbol,
    output reg pixel_on
    );
    
    reg [19:0] row_pattern;
    
    always @(*) begin
        row_pattern = 20'b0;
        pixel_on = 1'b0;
        if ((x >= sx) && (x < sx + 20) &&
            (y >= sy) && (y < sy + 20)) begin
            case (y - sy)
                0: row_pattern = 20'b00000000000000000000;
                1: row_pattern = 20'b00000000000000000000;
                2: row_pattern = 20'b00000000000000000000;
                3: row_pattern = 20'b00000000000000000000;
                4: row_pattern = 20'b00000000001110000000;
                5: row_pattern = 20'b00000000011110000000;
                6: row_pattern = 20'b00000000111000000000;
                7: row_pattern = 20'b00000000110000000000;
                8: row_pattern = 20'b00000001100000000000;
                9: row_pattern = 20'b00000001100000000000;
                10: row_pattern = 20'b00000001100000000000;
                11: row_pattern = 20'b00000001100000000000;
                12: row_pattern = 20'b00000000110000000000;
                13: row_pattern = 20'b00000000111000000000;
                14: row_pattern = 20'b00000000011110000000;
                15: row_pattern = 20'b00000000001110000000;
                16: row_pattern = 20'b00000000000000000000;
                17: row_pattern = 20'b00000000000000000000;
                18: row_pattern = 20'b00000000000000000000;
                19: row_pattern = 20'b00000000000000000000;
                default: row_pattern = 20'b0;
            endcase
            
            pixel_on = row_pattern[20 - 1 - (x - sx)];
        end
    end
endmodule
