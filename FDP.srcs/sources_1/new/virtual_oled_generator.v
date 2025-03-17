`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2025 01:49:34 PM
// Design Name: 
// Module Name: virtual_oled_generator
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
// $clog2 function finds out the number of bits required for the operation
//////////////////////////////////////////////////////////////////////////////////

module virtual_oled_generator #(
    parameter OLED_WIDTH = 96,
    parameter OLED_HEIGHT = 64,
    parameter VIRTUAL_WIDTH = 192,
    parameter VIRTUAL_HEIGHT = 128,
    parameter PIXEL_INDEX_BIT = $clog2(OLED_WIDTH * OLED_HEIGHT) - 1,
    parameter VIRTUAL_ADDR_BIT = $clog2(VIRTUAL_WIDTH * VIRTUAL_HEIGHT) - 1,
    parameter MAX_X_OFFSET = VIRTUAL_WIDTH - OLED_WIDTH,
    parameter MAX_Y_OFFSET = VIRTUAL_HEIGHT - OLED_HEIGHT
    )(
    input clk,
    input reset,
    input [3:0] pb, // btnU, btnD, btnL, btnR
    input [PIXEL_INDEX_BIT:0] pixel_index,
    output [VIRTUAL_ADDR_BIT:0] virtual_index
    );
    //////////////////////////////////////////////////////////////////////////////////
    // Generate required wires and regs
    //////////////////////////////////////////////////////////////////////////////////
    reg [VIRTUAL_ADDR_BIT:0] x_offset = 0;
    reg [VIRTUAL_ADDR_BIT:0] y_offset = 0;
    wire [VIRTUAL_ADDR_BIT:0] physical_x = pixel_index % OLED_WIDTH;
    wire [VIRTUAL_ADDR_BIT:0] physical_y = pixel_index / OLED_WIDTH;
    wire [VIRTUAL_ADDR_BIT:0] adjusted_x = (physical_x + x_offset) % VIRTUAL_WIDTH;
    wire [VIRTUAL_ADDR_BIT:0] adjusted_y = (physical_y + y_offset) % VIRTUAL_HEIGHT;
    assign virtual_index = adjusted_x + (adjusted_y * VIRTUAL_WIDTH);
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////  
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_offset <= 0;
            y_offset <= 0;
        end else begin
            if (pb[0] && x_offset < MAX_X_OFFSET) x_offset <= x_offset + 1;
            if (pb[1] && x_offset > 0) x_offset <= x_offset - 1;
            if (pb[2] && y_offset < MAX_Y_OFFSET) y_offset <= y_offset + 1;
            if (pb[3] && y_offset > 0) y_offset <= y_offset - 1;
        end
    end

endmodule
