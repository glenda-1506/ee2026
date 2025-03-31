`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2025 12:33:40 AM
// Design Name: 
// Module Name: counter
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
// Main functionality is to increament the output.
// Can also be used as a clock but base_clock does the same
// To toggle direction, at a top module, set the toggle as the dir input
//////////////////////////////////////////////////////////////////////////////////
// MODEs:
// 3'b100 : Restart all counts form START_COUNT when start_signal is low
// 3'b010 : Hold all counts when start_signal is low
// 3'b001 : Same as 3'b100 EXCEPT when a boundary is reached, it does not reset 
//          Should only be used when the dir is being toggled from a top module.
// 3'b000 : Restart all counts from MAX/MIN when start_signal is low
// IMPORTANT: To use toggle mode, need to explicitly set start_signal to low for 
//            1 clock cycle.
//////////////////////////////////////////////////////////////////////////////////
// Default Call: (Up counter that does not care about limits or start_signal)
// counter #(MAX, MIN, START, MODE)(clk, 0, 1, 1, out);
//////////////////////////////////////////////////////////////////////////////////

module counter #(
    parameter MAX_COUNT = 49_999_999, // 1Hz if clk is device clk
    parameter MIN_COUNT = 0,    
    parameter START_COUNT = 0,
    parameter [2:0] MODE = 3'b100,
    parameter [0:0] WRAP_ALLOWED = 0, // stays at max/min
    parameter WIDTH_BIT = 31
    )(
    input clk,
    input is_at_limits, // set to 0 if limits don't matter
    input start_signal, // active low (Set to 1 if not required)
    input dir, // 1 : up-counting, 0: down-counting
    output reg [WIDTH_BIT:0] count = START_COUNT
    );
    
    localparam RESTART_AT_START = MODE[2];
    localparam HOLD_STATE = MODE[1];
    localparam REFRESH_STATE = MODE[0]; 
    
    reg prev_signal;
    reg first_time = 1;
    always @ (posedge clk) begin
        prev_signal <= start_signal;
        if (is_at_limits & RESTART_AT_START) begin
            count <= START_COUNT;
        end else if ((prev_signal && !start_signal) && REFRESH_STATE) begin
            first_time <= 1;
        end else if (!start_signal) begin
            if (RESTART_AT_START || first_time) count <= START_COUNT;
            else count <= HOLD_STATE ? count : (dir ? MIN_COUNT : MAX_COUNT);
        end else begin
            first_time <= 0;
            if (dir) count <= (count < MAX_COUNT) ? (count + 1) : WRAP_ALLOWED ? MIN_COUNT : count;
            else count <= (count > MIN_COUNT) ? (count - 1) : WRAP_ALLOWED ? MAX_COUNT : count;
        end
    end
endmodule