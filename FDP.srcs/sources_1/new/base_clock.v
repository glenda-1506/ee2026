`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2025 07:35:07 PM
// Design Name: 
// Module Name: base_clock
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
// Additional Comments:
// Frequency of Clock = (main_clock = 100MHz) / [2 * (OVERFLOW_COUNT + 1)]
// Limitation: This code makes it such that the clock has a freq cap of 50mHz 
//////////////////////////////////////////////////////////////////////////////////


module base_clock(
    input CLOCK, 
    input [31:0] OVERFLOW_COUNT,
    output reg SLOW_CLOCK = 0
    );
    
    reg[31:0] COUNT = 0;
    always @ (posedge CLOCK) begin
        COUNT <= (COUNT == OVERFLOW_COUNT) ? 0 : COUNT + 1;
        SLOW_CLOCK <= (COUNT == 0) ? ~SLOW_CLOCK : SLOW_CLOCK;
    end
endmodule
