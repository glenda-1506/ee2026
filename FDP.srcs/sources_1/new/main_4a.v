`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2025 12:12:20 AM
// Design Name: 
// Module Name: main_4a
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


module main_4a(
    input clk,
    input reset,
    input [6:0] x,
    input [5:0] y,
    input btnC,
    input btnU,
    input btnD,
    output reg [15:0] oled_display
    );
    
    wire [15:0] border_output;
    wire active;
    wire [5:0] outer_diameter, inner_diameter;
    wire [15:0] circle_output;
    
    border_design border (
        .x(x), 
        .y(y),
        .oled_out(border_output)
    );
        
    button_center center (
        .clk(clk),
        .reset(reset),
        .btnC(btnC),
        .active(active)
    );

    button_updown up_down (
        .clk(clk),
        .reset(reset),
        .btnU(btnU),
        .btnD(btnD),
        .active(active),
        .outer_diameter(outer_diameter),
        .inner_diameter(inner_diameter)
    );

    circle4a_design circle (
        .x(x),
        .y(y),
        .active(active),
        .outer_diameter(outer_diameter),
        .inner_diameter(inner_diameter),
        .circle_output(circle_output)
    );
    
    always @(posedge clk) begin
        if (border_output == 16'b11111_000000_00000)
            oled_display <= border_output;
        else if (active)
            oled_display <= circle_output;
        else
            oled_display <= 16'b0;
    end
endmodule
