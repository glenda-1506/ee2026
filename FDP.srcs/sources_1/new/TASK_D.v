`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 01:06:50 AM
// Design Name: 
// Module Name: TASK_D
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


module TASK_D(
    input         clk,
    input         rst,
    input         start,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [127:0] equation_in,
    input         is_msop, 
    output        done,
    output [7:0]  truth_table,
    output reg [15:0] oled_data_reg_D
);

    wire parser_done;
    reg old_in;              
    wire start_parser;   
    
    always @(posedge clk) begin
        old_in <= start; 
    end
    
    assign start_parser = start & ~old_in;

    parser_module parser_inst(
        .equation_in (equation_in),
        .clk         (clk),
        .rst         (rst),
        .start       (start_parser),
        .truth_table (truth_table),
        .done        (parser_done)
    );

endmodule
