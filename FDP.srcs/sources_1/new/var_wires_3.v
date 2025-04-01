`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 03:48:07 PM
// Design Name: 
// Module Name: var_wires_3
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


module var_wires_3#(
    parameter DISPLAY_WIDTH   = 96,
    parameter DISPLAY_HEIGHT  = 64,
    parameter GATE_INPUTS = 3,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input clk,
    input reset,
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0]  x,                     
    input [Y_BIT:0]  y,  
    input [5:0] input_id,
    output draw,
    output reg assignment_is_successful
    );
    
    // Set parameters
    localparam [5:0] A_ID = 4'd0;
    localparam [5:0] B_ID = 4'd1;
    localparam [5:0] C_ID = 4'd2;
    localparam [5:0] A_BAR_ID = 4'd5;
    localparam [5:0] B_BAR_ID = 4'd6;
    localparam [5:0] C_BAR_ID = 4'd7;
    
    // generate the 6 wires
    wire [5:0] wire_ready;
    wire [5:0] is_used;
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 70)  
            (clk, reset, (input_id == A_ID), x_addr, y_addr, x, y, wire_ready[0], is_used[0]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 49)  
            (clk, reset, (input_id == B_ID), x_addr, y_addr, x + 21, y + 2, wire_ready[1], is_used[1]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 28)  
            (clk, reset, (input_id == C_ID), x_addr, y_addr, x + 42, y + 4, wire_ready[2], is_used[2]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 56)  
            (clk, reset, (input_id == A_BAR_ID), x_addr, y_addr, x + 14, y, wire_ready[3], is_used[3]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 35)  
            (clk, reset, (input_id == B_BAR_ID), x_addr, y_addr, x + 35, y + 2, wire_ready[4], is_used[4]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 14)  
            (clk, reset, (input_id == C_BAR_ID), x_addr, y_addr, x + 56, y + 4, wire_ready[5], is_used[5]);
    
    assign draw = |wire_ready;
    always @(posedge clk) begin
        assignment_is_successful <= 1'b0;
        case (input_id) 
            A_ID: assignment_is_successful <=  !is_used[0];
            B_ID: assignment_is_successful <=  !is_used[1];
            C_ID: assignment_is_successful <=  !is_used[2];
            A_BAR_ID: assignment_is_successful <=  !is_used[3];
            B_BAR_ID: assignment_is_successful <=  !is_used[4];
            C_BAR_ID: assignment_is_successful <=  !is_used[5];
            default: assignment_is_successful <= 1'b0;
        endcase
    end
endmodule
