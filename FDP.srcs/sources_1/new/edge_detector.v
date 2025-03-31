`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2025 02:16:48 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector #(
    parameter EDGE_TYPE = 0  // 0: rising edge, 1: falling edge
    )(
    input clk,
    input signal,
    output reg pulse
    );

    reg Q;
    
    always @(posedge clk) begin
        Q <= signal;
        if (EDGE_TYPE == 0)
            pulse <= signal & ~Q;  // Rising edge detection
        else
            pulse <= ~signal & Q;  // Falling edge detection
    end
endmodule