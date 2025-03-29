`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2025 05:14:23 PM
// Design Name: 
// Module Name: gate_container
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


module gate_container#(
    parameter DISPLAY_WIDTH = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter GATE_INPUTS = 3,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1
    )(
    input clk,
    input [X_BIT:0] x_addr, 
    input [Y_BIT:0] y_addr,
    input [X_BIT:0] x,                     
    input [Y_BIT:0] y,  
    input [GATE_INPUTS-1:0] input_lines, // [MIDDLE : TOP : BOTTOM]
    input [1:0] gate_select, // 2'b01 : AND , 2'b10: OR
    output draw,
    output [6:0] output_id // available if output_signal is 0
    // note: only need output id !!! -> use input id at top level
    );

    wire draw_and;
    wire draw_or;
    reg buffer;
    assign draw = (gate_select == 2'b1) ? draw_and : (gate_select == 2'b10) ? (draw_or || buffer) : 0;
    // GATES 
    AND_gate #(DISPLAY_WIDTH, DISPLAY_HEIGHT)
              (x_addr, y_addr, x, y, draw_and);
   
    OR_gate #(DISPLAY_WIDTH, DISPLAY_HEIGHT)
             (x_addr, y_addr, x, y, draw_or);
             
    // Assign buffers
   
    always @ (posedge clk) begin
        if (GATE_INPUTS == 3) begin
            buffer <= (input_lines[1] && (y_addr == (y + 3)) && ((x_addr == x) || (x_addr == (x + 1)))) || 
                      (input_lines[2] && (y_addr == (y + 5)) && ((x_addr == x) || (x_addr == (x + 1)) || (x_addr == (x + 2)))) ||
                      (input_lines[0] && (y_addr == (y + 7)) && ((x_addr == x) || (x_addr == (x + 1))));
        end
    end

endmodule
