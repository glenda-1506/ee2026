`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 01:06:50 AM
// Design Name: 
// Module Name: TASK_D
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


module TASK_D(
    input         clk,
    input         rst,
    input         start,
    input [63:0] equation_in, 
    output        done,
    output [7:0]  truth_table
);

     parser_module parser_inst(
    .equation_in (equation_in),
    .clk         (clk),
    .rst         (rst),
    .start       (start),
    .truth_table (truth_table),
    .done        (done)
);


endmodule
