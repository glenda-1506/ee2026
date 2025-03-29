`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2025 01:10:01 PM
// Design Name: 
// Module Name: test_decoder_3
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


module test_decoder_3(

    );
    
    reg clk = 0;
    reg [7:0] func_id;
    wire [1:0] gate_type;
    wire [1:0] num_inputs;
    wire [5:0] output_id;
    wire [5:0] input_id0, input_id1, input_id2;
    wire valid_gate;
    
    always #1 clk = ~clk;    
    
    netlist_decoder_3 dut (clk, func_id, 1, gate_type, num_inputs, output_id, 
                           input_id0, input_id1, input_id2, valid_gate);
    
    integer i;
    initial begin
        #5;
        for (i = 0; i < 256; i = i + 1) begin
            func_id = i;
            #200;  // give time to decode multiple gates
        end
        #20 $finish;
    end

    always @(posedge clk) begin
        if (valid_gate) begin
            $display("At time %t | func_id=%0d | gate_type=%b, num_inputs=%b, output_id=%0d, i0=%0d, i1=%0d, i2=%0d, valid=%0d",
                     $time, func_id, gate_type, num_inputs, output_id, input_id0, input_id1, input_id2, valid_gate);
        end
    end

endmodule
