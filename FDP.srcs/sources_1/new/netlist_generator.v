`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 09:52:32 PM
// Design Name: 
// Module Name: netlist_generator
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
// HOW TO DECODE THE BINARY STRING (in the .mem file):
//   Each netlist is stored on a single line, in hex.
//   Information is in packets of 16 bits as follows from left to right:
//     - gate_type (2 bits): 00=NOT, 01=AND, 10=OR, 11=literal
//     - num_inputs (2 bits): (#inputs - 1)
//     - output_id (6 bits)
//     - input_ids (6 bits each)
//////////////////////////////////////////////////////////////////////////////////


module netlist_generator #(
    parameter IS_MSOP = 1,
    parameter NETLIST_WIDTH = 276 // 3-gate has 69 characters -> each char is 4 bits
    )(
    input clk,
    input [7:0] func_id,
    output reg [NETLIST_WIDTH - 1: 0] netlist_data
    );
    
    reg [NETLIST_WIDTH-1:0] memory [0:255];
    
    initial begin
        if (IS_MSOP) begin
            $readmemh("msop_3gate.mem", memory);
        end else begin
            $readmemh("mpos_3gate.mem", memory);
        end
    end

    
    always @(posedge clk) begin
        netlist_data <= memory[func_id];
    end
endmodule
