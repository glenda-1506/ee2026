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
    parameter OLED_WIDTH        = 96,
    parameter OLED_HEIGHT       = 64,
    parameter VIRTUAL_WIDTH     = 150, 
    parameter VIRTUAL_HEIGHT    = 128,
    parameter OLED_X_BIT = $clog2(OLED_WIDTH) - 1,
    parameter OLED_Y_BIT = $clog2(OLED_HEIGHT) - 1,
    parameter PIXEL_INDEX_BIT = $clog2(OLED_WIDTH * OLED_HEIGHT) - 1,
    parameter OFFSET_BIT      = $clog2(VIRTUAL_WIDTH) - 1,
    parameter VIRTUAL_ADDR_BIT = $clog2(VIRTUAL_WIDTH * VIRTUAL_HEIGHT) - 1
    )(
    input clk,
    input reset,
    input btnU, btnD, btnL, btnR,
    input [PIXEL_INDEX_BIT:0] pixel_index,
    output [15:0] pixel_data
    );
    
    // Generate regs and wires
    reg [OFFSET_BIT:0] x_offset;
    reg [OFFSET_BIT:0] y_offset;
    
    // Generate a map of pixel data for each pixel in the virtual oled
    // Each index on the map is a 16 bit data
    reg [15:0] virtual_oled_map [0: (VIRTUAL_WIDTH * VIRTUAL_HEIGHT) - 1];
    wire [OLED_X_BIT:0] physical_x = pixel_index % OLED_WIDTH;  
    wire [OLED_Y_BIT:0] physical_y = pixel_index / OLED_WIDTH; 
    wire [OFFSET_BIT:0] virtual_x = physical_x + x_offset;
    wire [OFFSET_BIT:0] virtual_y = physical_y + y_offset; 
    wire [VIRTUAL_ADDR_BIT:0] virtual_map_index = virtual_x + (virtual_y * VIRTUAL_WIDTH);
    
    // Assign the pixel data from virtual OLED to physical
    assign pixel_data = virtual_oled_map[virtual_map_index];
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////  
    always @(posedge clk or posedge reset) begin
        if (reset) begin
          x_offset <= 0;
          y_offset <= 0;
        end else begin
          if (btnL && (x_offset > 0)) x_offset <= x_offset - 1;
          if (btnR && (x_offset < VIRTUAL_WIDTH - OLED_WIDTH)) x_offset <= x_offset + 1;
          if (btnU && (y_offset > 0)) y_offset <= y_offset - 1;
          if (btnD && (y_offset < VIRTUAL_HEIGHT - OLED_HEIGHT)) y_offset <= y_offset + 1;
        end
      end
endmodule
