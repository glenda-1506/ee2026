`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 09:02:07 PM
// Design Name: 
// Module Name: test_wire_gate_3_control_MPOS
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


module test_wire_gate_3_control_MPOS(

    );
    reg clk = 0;
    reg rst;
    reg [7:0] func_id;
    
    wire [5:0] wire_id;
    wire [1:0] gate_type;
    wire [2:0] gate_id;
    wire [2:0] num_inputs;
    wire       valid_out;
    
    // Clock generation
    always #1 clk = ~clk;
    
    // Instantiate the circuit_control module (which instantiates var_3_gen internally)
    wire_gate_3_control_MPOS dut (
        .clk(clk),
        .reset(rst),
        .func_id(func_id),
        .wire_id(wire_id),
        .gate_type(gate_type),
        .gate_id(gate_id),
        .input_count(num_inputs),
        .valid(valid_out)
    );
    
    integer i;
    initial begin
          rst = 1; 
          func_id = 0; 
          #5;
          rst = 0;
          // Iterate through function IDs from 0 to 255
          for (i = 159; i < 160; i = i + 1) begin
              func_id = i;
              #1000;
          end
          #1000;
          $finish;
     end
     
     always @(posedge clk) begin
         if (valid_out)
             $display("Time %t: func_id=%0d, gate_type=%h, gate_id=%h, num_inputs=%h, wire_id=%0d", 
                      $time, func_id, gate_type, gate_id, num_inputs, wire_id);
     end
endmodule
