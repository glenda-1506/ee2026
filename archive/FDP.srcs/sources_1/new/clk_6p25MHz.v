`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2025 11:19:40 PM
// Design Name: 
// Module Name: clk_6p25MHz
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


module clk_6p25MHz(
    input clock,
    output slow_clock
    );
    base_clock clk (clock,7,slow_clock);
endmodule
