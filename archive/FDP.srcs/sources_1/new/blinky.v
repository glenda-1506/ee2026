`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2025 11:30:29 AM
// Design Name: 
// Module Name: blinky
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


module blinky(
    input CLOCK,
    input [15:0] PASSWORD,
    output ready
    );
    
    // Set Parameters
    parameter PASSWORD_A = 16'b0001001100100111; //  [0, 1, 2, 5, 8, 9, 12]
    parameter PASSWORD_B = 16'b0010000100101111; //  [0, 1, 2, 3, 5, 8, 13]
    parameter PASSWORD_C = 16'b0100000010110111; //  [0, 1, 2, 4, 5, 7, 14]
    parameter PASSWORD_D = 16'b1000000011000111; //  [0, 1, 2, 6, 7, 15]
    
    // Generate Regs
    reg control_A = 0;
    reg control_B = 0;
    reg control_C = 0;
    reg control_D = 0;
    
    // Generate wires
    wire A_clock;
    wire B_clock;
    wire C_clock;
    wire D_clock;
    
    // Generate Clocks
    // To blink at x Hz, i need the clocks to be of 2x Hz since i need it to on and off
    base_clock clock_A (CLOCK, 4_166_665, A_clock); // 12Hz
    base_clock clock_B (CLOCK, 6_249_999, B_clock); // 8Hz
    base_clock clock_C (CLOCK, 4_999_999, C_clock); // 10Hz
    base_clock clock_D (CLOCK, 3_571_427, D_clock); // 14Hz
    
    // Main code
    assign ready = control_A || control_B || control_C || control_D;
    
    always @ (posedge A_clock) begin
        control_A = (PASSWORD == PASSWORD_A) ? ~control_A : 0;
    end
    
    always @ (posedge B_clock) begin
        control_B = (PASSWORD == PASSWORD_B) ? ~control_B : 0;
    end
    
    always @ (posedge C_clock) begin
        control_C = (PASSWORD == PASSWORD_C) ? ~control_C : 0;
    end
    
    always @ (posedge C_clock) begin
        control_D = (PASSWORD == PASSWORD_D) ? ~control_D : 0;
    end
    
endmodule
