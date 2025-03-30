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
    input [15:0] sw,
    input reset,
    input btnU, btnD, btnL, btnR,
    output reg [15:0] oled_data_reg = 0
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameters, wires and regs
    //////////////////////////////////////////////////////////////////////////////////
       
    // Generate required wires and regs
    wire bU, bD, bL, bR;
    wire [15:0] oled_data_3_gate;
    wire clk_6p25M;
    
    // Generate delayed pulse buttons
    delay s1(clk, btnU, 250_000, bU);
    delay s2(clk, btnD, 250_000, bD);
    delay s3(clk, btnL, 250_000, bL);
    delay s4(clk, btnR, 250_000, bR);
    
    // Generate clk that matches oled display
    clock clk6p25 (clk, 7 , clk_6p25M);

    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    always @(posedge clk_6p25M) begin
        oled_data_reg <= oled_data_3_gate; // use switch cases if there are more
    end

    //////////////////////////////////////////////////////////////////////////////////
    // MAIN MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    circuit_control_3_gate (
        .clk(clk_6p25M),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .sw(sw),
        .reset(reset),
        .btnU(bU),
        .btnD(bD),
        .btnL(bL),
        .btnR(bR),
        .oled_data_reg(oled_data_3_gate));

    //*/
    //////////////////////////////////////////////////////////////////////////////////
    // TEST CODE
    ////////////////////////////////////////////////////////////////////////////////// 
        
    /* Code below is for test LUT usage. Replace * with /   
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) a1 (x_index, y_index, 10, 10, 10, 20, 1, var_ready[1]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) a2 (x_index, y_index, 30, 30, 50, 30, 1, var_ready[0]);
    line_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) a3 (x_index, y_index, 60, 60, 75, 85, 1, var_ready[2]);
    //*/
    
endmodule
