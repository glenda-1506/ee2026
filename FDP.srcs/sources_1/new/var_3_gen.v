`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 07:03:05 PM
// Design Name: 
// Module Name: var_3_gen
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
// A     : 0
// B     : 1
// C     : 2
// NOT   : 4
// OR    : 5
// AND   : 6
// START : F
//////////////////////////////////////////////////////////////////////////////////

module var_3_gen#(
    parameter IS_MSOP = 1,
    parameter DATA_WIDTH = 120 // 30 characters -> each char is 4 bits
    )(
    input clk,
    input [7:0] func_id,
    input receive_ready,
    output reg transmit_ready = 0,
    output reg [DATA_WIDTH - 1: 0] data
    );
    
    reg [DATA_WIDTH-1:0] memory [0:255];
    
    initial begin
        if (IS_MSOP) begin
            $readmemh("msop_3_var.mem", memory);
        end else begin
            $readmemh("mpos_3_var.mem", memory);
        end
    end
    
    always @(posedge clk) begin
        if (receive_ready) begin
            data <= memory[func_id];
            transmit_ready <= 1'b1;
        end else begin
            transmit_ready <= 1'b0;
        end
    end
endmodule
