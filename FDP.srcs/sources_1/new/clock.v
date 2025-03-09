`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 11:07:54 AM
// Design Name: 
// Module Name: clock
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
// Uses base clock to compute clock signal BUT with freq input instead
//////////////////////////////////////////////////////////////////////////////////

module clock(
    input CLOCK,
    input [27:0] FREQUENCY,
    output SLOW_CLOCK
    );
    wire [27:0] OVERFLOW_COUNT = (100000000 / FREQUENCY) / 2 - 1;
    base_clock clk (CLOCK, OVERFLOW_COUNT, SLOW_CLOCK);
endmodule
