`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 10:17:53 PM
// Design Name: 
// Module Name: ONE_switches
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


module ONE_switches(
    input  [6:0] x,
    input  [5:0] y,
    input  [6:0] sx,
    input  [5:0] sy,
    output reg pixel_on
    );
    
    reg [7:0] row_pattern;
        
    always @(*) begin
        row_pattern = 8'b0;
        pixel_on = 1'b0;
        if ((x >= sx) && (x < sx + 8) &&
            (y >= sy) && (y < sy + 8)) begin
            case (y - sy)
                0: row_pattern = 8'b00011000;
                1: row_pattern = 8'b00111000;
                2: row_pattern = 8'b01111000;
                3: row_pattern = 8'b01111000;
                4: row_pattern = 8'b00011000;
                5: row_pattern = 8'b00011000;
                6: row_pattern = 8'b01111110;
                7: row_pattern = 8'b01111110;
                default: row_pattern = 8'b0;
            endcase
            
            pixel_on = row_pattern[8 - 1 - (x - sx)];
        end
    end
endmodule
