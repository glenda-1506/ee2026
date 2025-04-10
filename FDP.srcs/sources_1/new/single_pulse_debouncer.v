`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 01:54:30 PM
// Design Name: 
// Module Name: single_pulse_debouncer
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

module single_pulse_debouncer#(
    parameter EDGE = 0, // 0: rising, 1: falling
    parameter COUNT = 49_999 // detect every 1 ms (using main clk of 100 MHz)
    )(
    input clk,
    input pb,
    output debounced_pb
    );
    wire d_pb;
    debouncer de (clk, pb, COUNT, d_pb); 
    edge_detector #(EDGE) ed (clk, d_pb, debounced_pb);
endmodule