`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 03:06:51 AM
// Design Name: 
// Module Name: clk_green
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
// Need a 30 Hz clock -> 30 pixels per second
//////////////////////////////////////////////////////////////////////////////////


module clk_green(
    input clock,
    output slow_clock
    );
    
    base_clock clk (clock,1666666,slow_clock);
endmodule
