`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2025 12:26:47 PM
// Design Name: 
// Module Name: segment_display
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
// The 4 segment inputs can also be the same wire!
// eg. segment_display #(4999, 0) display (clk, s0, s0, s0, s0, seg, an);
// Take note, clock speed matters when you want to animate displays. A mismatch 
// can result in showing segments that are not meant to be shown. (eg. ghosting)
//////////////////////////////////////////////////////////////////////////////////
// Copy to main module:
// wire [7:0] s3 = 8'b(value); // left most
// wire [7:0] s2 = 8'b(value);
// wire [7:0] s1 = 8'b(value);
// wire [7:0] s0 = 8'b(value);
// segment_display #(4999, 0) display (clk, s3, s2, s1, s0, seg, an);
//////////////////////////////////////////////////////////////////////////////////
// Reminder that input into seg is LITTLE ENDIAN
//    --a--
//   |     |
//   f     b
//   |     |
//    --g--
//   |     |
//   e     c
//   |     |
//    --d--
//////////////////////////////////////////////////////////////////////////////////

module segment_display #(
    parameter COUNT = 49_999, // 1,000 Hz
    parameter DIR = 1'b0 // left to right
    )(
    input clk,
    input [7:0] seg_3, seg_2, seg_1, seg_0,
    output reg [7:0] seg,
    output reg [3:0] an = 4'b1111
    );
    
    // Generate wires and regs
    wire slow_clock;
    reg [1:0] state = DIR ? 0 : 3;
    reg [7:0] blank_seg = 8'b11111111;
    reg [3:0] off_all_an = 4'b1111;
    
    // Generate clocks
    clock slow (clk, COUNT, slow_clock);
    
    // Main Code
    always @(posedge slow_clock) begin
        state <= DIR ? state + 1 :  state - 1;
        case (state)
            0: begin seg <= seg_0; an  <= (seg_0 == blank_seg) ? off_all_an : 4'b1110; end
            1: begin seg <= seg_1; an  <= (seg_1 == blank_seg) ? off_all_an : 4'b1101; end
            2: begin seg <= seg_2; an  <= (seg_2 == blank_seg) ? off_all_an : 4'b1011; end
            3: begin seg <= seg_3; an  <= (seg_3 == blank_seg) ? off_all_an : 4'b0111; end            
        endcase
    end
endmodule

/////////////////////////////////////////////////////////////////////////////
// In an 8-bit segment display, the MSB is for the dp (dot).
// (Active-low logic: 0 = segment ON, 1 = segment OFF)
/////////////////////////////////////////////////////////////////////////////
// ******************* Without dp (dp off, MSB = 1) *******************
/////////////////////////////////////////////////////////////////////////////
// parameter SEG_CLEAR        = 8'b1_1111111; // Clears all segments (dp off)
// parameter SEG_DIGIT_0      = 8'b1_1000000; // 0 -> gfedcba = 1000000
// parameter SEG_DIGIT_1      = 8'b1_1111001; // 1 -> gfedcba = 1111001
// parameter SEG_DIGIT_2      = 8'b1_0100100; // 2 -> gfedcba = 0100100
// parameter SEG_DIGIT_3      = 8'b1_0110000; // 3 -> gfedcba = 0110000
// parameter SEG_DIGIT_4      = 8'b1_0011001; // 4 -> gfedcba = 0011001
// parameter SEG_DIGIT_5      = 8'b1_0010010; // 5 -> gfedcba = 0010010
// parameter SEG_DIGIT_6      = 8'b1_0000010; // 6 -> gfedcba = 0000010
// parameter SEG_DIGIT_7      = 8'b1_1111000; // 7 -> gfedcba = 1111000
// parameter SEG_DIGIT_8      = 8'b1_0000000; // 8 -> gfedcba = 0000000
// parameter SEG_DIGIT_9      = 8'b1_0010000; // 9 -> gfedcba = 0010000
//
// parameter SEG_LETTER_A     = 8'b1_0001000; // A -> gfedcba = 0001000
// parameter SEG_LETTER_B     = 8'b1_0000011; // B -> gfedcba = 0000011
// parameter SEG_LETTER_c     = 8'b1_0100111; // c -> gfedcba = 0100111
// parameter SEG_LETTER_d     = 8'b1_0100001; // d -> gfedcba = 0100001
// parameter SEG_LETTER_E     = 8'b1_0000110; // E -> gfedcba = 0000110
// parameter SEG_LETTER_H     = 8'b1_0001001; // H -> gfedcba = 0001001
// parameter SEG_LETTER_J     = 8'b1_1100001; // J -> gfedcba = 1100001
// parameter SEG_LETTER_L     = 8'b1_1000111; // L -> gfedcba = 1000111
// parameter SEG_LETTER_l     = 8'b1_1001111; // l -> gfedcba = 1001111
// parameter SEG_LETTER_M     = 8'b1_1101010; // M -> gfedcba = 1101010
// parameter SEG_LETTER_N     = 8'b1_0101011; // N -> gfedcba = 0101011
// parameter SEG_LETTER_r     = 8'b1_0101111; // r -> gfedcba = 0101111
// parameter SEG_LETTER_R     = 8'b1_0101111; // R -> gfedcba = 0101111
// parameter SEG_LETTER_U     = 8'b1_1000001; // U -> gfedcba = 1000001
// parameter SEG_LETTER_u     = 8'b1_1110000; // u -> gfedcba = 1110000
// parameter SEG_LETTER_W     = 8'b1_1010101; // W -> gfedcba = 1010101
// parameter SEG_LETTER_X     = 8'b1_0001001; // X -> gfedcba = 0001001
// parameter SEG_LETTER_Y     = 8'b1_0010001; // Y -> gfedcba = 0010001
////////////////////////////////////////////////////////////////////////////
// ********************* With dp (dp on, MSB = 0) *********************
////////////////////////////////////////////////////////////////////////////
// parameter SEG_CLEAR_DP     = 8'b0_1111111; // Clears all segments (dp on)
// parameter SEG_DIGIT_0_DP   = 8'b0_1000000; // 0 -> gfedcba = 1000000
// parameter SEG_DIGIT_1_DP   = 8'b0_1111001; // 1 -> gfedcba = 1111001
// parameter SEG_DIGIT_2_DP   = 8'b0_0100100; // 2 -> gfedcba = 0100100
// parameter SEG_DIGIT_3_DP   = 8'b0_0110000; // 3 -> gfedcba = 0110000
// parameter SEG_DIGIT_4_DP   = 8'b0_0011001; // 4 -> gfedcba = 0011001
// parameter SEG_DIGIT_5_DP   = 8'b0_0010010; // 5 -> gfedcba = 0010010
// parameter SEG_DIGIT_6_DP   = 8'b0_0000010; // 6 -> gfedcba = 0000010
// parameter SEG_DIGIT_7_DP   = 8'b0_1111000; // 7 -> gfedcba = 1111000
// parameter SEG_DIGIT_8_DP   = 8'b0_0000000; // 8 -> gfedcba = 0000000
// parameter SEG_DIGIT_9_DP   = 8'b0_0010000; // 9 -> gfedcba = 0010000
//
// parameter SEG_LETTER_A_DP  = 8'b0_0001000; // A -> gfedcba = 0001000
// parameter SEG_LETTER_B_DP  = 8'b0_0000011; // B -> gfedcba = 0000011
// parameter SEG_LETTER_c_DP  = 8'b0_0100111; // c -> gfedcba = 0100111
// parameter SEG_LETTER_d_DP  = 8'b0_0100001; // d -> gfedcba = 0100001
// parameter SEG_LETTER_E_DP  = 8'b0_0000110; // E -> gfedcba = 0000110
// parameter SEG_LETTER_H_DP  = 8'b0_0001001; // H -> gfedcba = 0001001
// parameter SEG_LETTER_J_DP  = 8'b0_1100001; // J -> gfedcba = 1100001
// parameter SEG_LETTER_L_DP  = 8'b0_1000111; // L -> gfedcba = 1000111
// parameter SEG_LETTER_l_DP  = 8'b0_1001111; // l -> gfedcba = 1001111
// parameter SEG_LETTER_M_DP  = 8'b0_1101010; // M -> gfedcba = 1101010
// parameter SEG_LETTER_N_DP  = 8'b0_0101011; // N -> gfedcba = 0101011
// parameter SEG_LETTER_r_DP  = 8'b0_0101111; // r -> gfedcba = 0101111
// parameter SEG_LETTER_R_DP  = 8'b0_0101111; // R -> gfedcba = 0101111
// parameter SEG_LETTER_U_DP  = 8'b0_1000001; // U -> gfedcba = 1000001
// parameter SEG_LETTER_u_DP  = 8'b0_1110000; // u -> gfedcba = 1110000
// parameter SEG_LETTER_W_DP  = 8'b0_1010101; // W -> gfedcba = 1010101
// parameter SEG_LETTER_X_DP  = 8'b0_0001001; // X -> gfedcba = 0001001
// parameter SEG_LETTER_Y_DP  = 8'b0_0010001; // Y -> gfedcba = 0010001
////////////////////////////////////////////////////////////////////////////