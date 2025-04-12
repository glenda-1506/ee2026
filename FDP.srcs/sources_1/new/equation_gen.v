`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2025 01:44:41 PM
// Design Name: 
// Module Name: equation_gen
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


module equation_gen#(
    parameter MEM_LINE_WIDTH = 148  // # of bits per line in the .mem file
    )(
    input               clk,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input               rst,        // Added to allow full reset
    input               start,      // ASYNCHRONOUS trigger to restart reading
    input               is_msop,    // Select which .mem file to load
    input       [7:0]   truth_table,// Which line in the memory to fetch
    output reg  [127:0]  eqn_out,    // (MSB = first nibble read)
    output [15:0] out
    );
    
    reg [MEM_LINE_WIDTH-1:0] memory_msop [0:255];
    reg [MEM_LINE_WIDTH-1:0] memory_mpos [0:255];
    reg [MEM_LINE_WIDTH-1:0] send_in;
    initial begin
        send_in <= {MEM_LINE_WIDTH{1'b1}};
        $readmemh("msop.mem", memory_msop);
        $readmemh("mpos.mem", memory_mpos);
    end
    
    Display_Typing_D #(40, 319) display_unit(
        .clk(clk), 
        .x_addr(x_addr),
        .y_addr(y_addr),
        .program_locked(0),
        .pixel_data(out),
        .buffer(send_in)
    );
    
    always @(posedge clk) begin
    if (is_msop) send_in <= memory_msop[truth_table];
    else send_in <= memory_mpos[truth_table];
    end
 
endmodule
