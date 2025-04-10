`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/12/2025 08:59:10 PM
// Design Name: 
// Module Name: TASK_A
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


module TASK_A(
    input clk,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [7:0] id,
    input reset,
    input btnU, btnD, btnL, btnR, btnC,
    output reg [15:0] oled_data_reg = 0,
    output reg [7:0] s3, s2, s1, s0
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameters, wires and regs
    //////////////////////////////////////////////////////////////////////////////////
    parameter SEG_CLEAR = 8'b1_1111111;
    parameter SEG_LETTER_S = 8'b1_0010010;
    parameter SEG_LETTER_O = 8'b1_1000000;
    parameter SEG_LETTER_P = 8'b1_0001100;
       
    // Generate required wires and regs
    wire bU, bD, bL, bR, bC;
    wire [15:0] oled_data_3_gate;
    wire is_mpos;
    
    // Generate delayed pulse buttons
    delay b1(clk, btnU, 200_000, bU);
    delay b2(clk, btnD, 200_000, bD);
    delay b3(clk, btnL, 200_000, bL);
    delay b4(clk, btnR, 200_000, bR);
    single_pulse_debouncer(clk, btnC, bC);

    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk) begin
        handle_segment_display;
        oled_data_reg <= oled_data_3_gate; // use switch cases if there are more
    end

    //////////////////////////////////////////////////////////////////////////////////
    // MAIN MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    circuit_control_3_gate (
        .clk(clk),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .function_id(id),
        .reset(reset),
        .btnU(bU),
        .btnD(bD),
        .btnL(bL),
        .btnR(bR),
        .btnC(bC),
        .oled_data_reg(oled_data_3_gate),
        .current_req(is_mpos));
        
    //////////////////////////////////////////////////////////////////////////////////
    // TASKS / FUNCTIONS
    //////////////////////////////////////////////////////////////////////////////////
    task handle_segment_display;
    begin
        s3 <= SEG_CLEAR;
        s2 <= is_mpos ? SEG_LETTER_P : SEG_LETTER_S;
        s1 <= SEG_LETTER_O;
        s0 <= is_mpos ? SEG_LETTER_S : SEG_LETTER_P;
    end
    endtask
    
endmodule
