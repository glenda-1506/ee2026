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
    input SW0,
    input btnC,
    input btnU, btnD, btnL, btnR,
    output [7:0] JXADC
    );
    
    TASK_4D task_4d (clk, SW0, btnC, btnU, btnD, btnL, btnR, JXADC);
endmodule