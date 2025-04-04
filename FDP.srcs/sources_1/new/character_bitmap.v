`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2025 04:56:33 PM
// Design Name: 
// Module Name: character_bitmap
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


module character_bitmap(
    input [7:0] char,
    input [2:0] row,
    output reg [7:0] get_character_bitmap
    );
    
    always @(*) begin
        case (char)
            "A": case (row)
                7: get_character_bitmap = 8'b00111100;
                6: get_character_bitmap = 8'b01100110;
                5: get_character_bitmap = 8'b01100110;
                4: get_character_bitmap = 8'b01111110;
                3: get_character_bitmap = 8'b01100110;
                2: get_character_bitmap = 8'b01100110;
                1: get_character_bitmap = 8'b01100110;
                0: get_character_bitmap = 8'b00000000;
                endcase
            "B": case (row)
                7: get_character_bitmap = 8'b00111110;
                6: get_character_bitmap = 8'b01100110;
                5: get_character_bitmap = 8'b01100110;
                4: get_character_bitmap = 8'b00111110;
                3: get_character_bitmap = 8'b01100110;
                2: get_character_bitmap = 8'b01100110;
                1: get_character_bitmap = 8'b00111110;
                0: get_character_bitmap = 8'b00000000;
                endcase
             "C": case (row)
                7: get_character_bitmap = 8'b00111110;
                6: get_character_bitmap = 8'b00111110;
                5: get_character_bitmap = 8'b00000110;
                4: get_character_bitmap = 8'b00000110;
                3: get_character_bitmap = 8'b00000110;
                2: get_character_bitmap = 8'b00111110;
                1: get_character_bitmap = 8'b00111110;
                0: get_character_bitmap = 8'b00000000;
                endcase 
             ".": case (row)
               7: get_character_bitmap = 8'b00000000;
               6: get_character_bitmap = 8'b00000000;
               5: get_character_bitmap = 8'b00111100;
               4: get_character_bitmap = 8'b00111100;
               3: get_character_bitmap = 8'b00111100;
               2: get_character_bitmap = 8'b00111100;
               1: get_character_bitmap = 8'b00000000;
               0: get_character_bitmap = 8'b00000000;
               endcase           
            "+": case (row)
                7: get_character_bitmap = 8'b00011000;
                6: get_character_bitmap = 8'b00011000;
                5: get_character_bitmap = 8'b01111110;
                4: get_character_bitmap = 8'b00011000;
                3: get_character_bitmap = 8'b00011000;
                2: get_character_bitmap = 8'b00000000;
                1: get_character_bitmap = 8'b00000000;
                0: get_character_bitmap = 8'b00000000;
                endcase
            "~": case (row)
                7: get_character_bitmap = 8'b00000000;
                6: get_character_bitmap = 8'b00000000;
                5: get_character_bitmap = 8'b10001000;
                4: get_character_bitmap = 8'b01010100;
                3: get_character_bitmap = 8'b00100010;
                2: get_character_bitmap = 8'b00000000;
                1: get_character_bitmap = 8'b00000000;
                0: get_character_bitmap = 8'b00000000;
                endcase
            "(": case (row)
                7: get_character_bitmap = 8'b00000000;
                6: get_character_bitmap = 8'b00111000;
                5: get_character_bitmap = 8'b00011100;
                4: get_character_bitmap = 8'b00000110;
                3: get_character_bitmap = 8'b00000110;
                2: get_character_bitmap = 8'b00011100;
                1: get_character_bitmap = 8'b00111000;
                0: get_character_bitmap = 8'b00000000;
                endcase
            ")": case (row)
                7: get_character_bitmap = 8'b00000000;
                6: get_character_bitmap = 8'b00011100;
                5: get_character_bitmap = 8'b00111000;
                4: get_character_bitmap = 8'b01100000;
                3: get_character_bitmap = 8'b01100000;
                2: get_character_bitmap = 8'b00111000;
                1: get_character_bitmap = 8'b00011100;
                0: get_character_bitmap = 8'b00000000;
                endcase
            " ": case (row)
                7: get_character_bitmap = 8'b00000000;
                6: get_character_bitmap = 8'b00000000;
                5: get_character_bitmap = 8'b00000000;
                4: get_character_bitmap = 8'b00000000;
                3: get_character_bitmap = 8'b00000000;
                2: get_character_bitmap = 8'b00000000;
                1: get_character_bitmap = 8'b00000000;
                0: get_character_bitmap = 8'b00000000;
                endcase
            default: get_character_bitmap = 8'b00000000;  // Return 0 for any other characters
        endcase
    end
endmodule
