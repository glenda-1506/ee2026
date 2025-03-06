`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  Si Thu Lin Aung
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input [15:0] sw,
    input btnC,
    input btnU, btnD, btnL, btnR,
    output [7:0] JB
    );
    wire PASSWORD = sw[0];
    TASK_4D task_4d (clk, PASSWORD, btnC, btnU, btnD, btnL, btnR, JB);
endmodule