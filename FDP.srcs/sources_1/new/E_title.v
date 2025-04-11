`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 07:01:47 PM
// Design Name: 
// Module Name: E_title
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


module E_title(
    input  [6:0] x,
    input  [5:0] y,
    input  [6:0] sx,
    input  [5:0] sy,
    output reg pixel_on
    );
    
    reg [12:0] row_pattern;
    
    always @(*) begin
        row_pattern = 13'b0;
        pixel_on = 1'b0;
        if ((x >= sx) && (x < sx + 13) &&
            (y >= sy) && (y < sy + 13)) begin
            case (y - sy)
                0: row_pattern = 13'b0000000000000;
                1: row_pattern = 13'b0011111111100;
                2: row_pattern = 13'b0011111111100;
                3: row_pattern = 13'b0000000001100;
                4: row_pattern = 13'b0000000001100;
                5: row_pattern = 13'b0000000001100;
                6: row_pattern = 13'b0000011111100;
                7: row_pattern = 13'b0000011111100;
                8: row_pattern = 13'b0000000001100;
                9: row_pattern = 13'b0000000001100;
                10: row_pattern = 13'b0011111111100;
                11: row_pattern = 13'b0011111111100;
                12: row_pattern = 13'b0000000000000;
                default: row_pattern = 13'b0;
            endcase
            
            pixel_on = row_pattern[13 - 1 - (x - sx)];
        end
    end
endmodule
