`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 08:07:53 PM
// Design Name: 
// Module Name: E1_title
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


module E1_title(
    input  [6:0] x,
    input  [5:0] y,
    input  [6:0] sx,
    input  [5:0] sy,
    output reg pixel_on
    );
    
    reg [9:0] row_pattern;
    
    always @(*) begin
        row_pattern = 10'b0;
        pixel_on = 1'b0;
        if ((x >= sx) && (x < sx + 10) &&
            (y >= sy) && (y < sy + 10)) begin
            case (y - sy)
                0: row_pattern = 10'b0111111110;
                1: row_pattern = 10'b0111111110;
                2: row_pattern = 10'b0000000110;
                3: row_pattern = 10'b0000000110;
                4: row_pattern = 10'b0000111110;
                5: row_pattern = 10'b0000111110;
                6: row_pattern = 10'b0000000110;
                7: row_pattern = 10'b0000000110;
                8: row_pattern = 10'b0111111110;
                9: row_pattern = 10'b0111111110;
                default: row_pattern = 10'b0;
            endcase
            
            pixel_on = row_pattern[10 - 1 - (x - sx)];
        end
    end
endmodule
