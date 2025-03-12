`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 11:05:22 PM
// Design Name: 
// Module Name: clk_25MHz
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


module clk_25MHz(
    input CLOCK,
    output SLOW_CLOCK
    );
    base_clock clk (CLOCK, 1, SLOW_CLOCK);
endmodule
