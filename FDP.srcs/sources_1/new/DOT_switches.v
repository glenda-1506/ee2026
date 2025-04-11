`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 10:17:53 PM
// Design Name: 
// Module Name: DOT_switches
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


module DOT_switches(
    input  [6:0] x,
    input  [5:0] y,
    input  [6:0] sx,
    input  [5:0] sy,
    output reg pixel_on
    );
    
    reg [5:0] row_pattern;
        
    always @(*) begin
        row_pattern = 6'b0;
        pixel_on = 1'b0;
        if ((x >= sx) && (x < sx + 6) &&
            (y >= sy) && (y < sy + 6)) begin
            case (y - sy)
                0: row_pattern = 6'b001100;
                1: row_pattern = 6'b001100;
                2: row_pattern = 6'b000000;
                3: row_pattern = 6'b000000;
                4: row_pattern = 6'b001100;
                5: row_pattern = 6'b001100;
                default: row_pattern = 6'b0;
            endcase
            
            pixel_on = row_pattern[6 - 1 - (x - sx)];
        end
    end
endmodule
