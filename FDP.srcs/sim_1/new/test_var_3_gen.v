`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 08:04:56 PM
// Design Name: 
// Module Name: test_var_3_gen
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


module test_var_3_gen(

    );
    
    reg clk = 0;
    reg [7:0] func_id;
    reg receive_ready;
    wire transmit_ready;
    wire [3:0] char_out;

    always #1 clk = ~clk;

    var_3_gen dut (
        .clk(clk),
        .func_id(func_id),
        .receive_ready(receive_ready),
        .transmit_ready(transmit_ready),
        .char_out(char_out));
        
     integer i;
    initial begin
          receive_ready = 0; #5;
          // Iterate through all function IDs from 0 to 255.
          for (i = 0; i < 256; i = i + 1) begin
              func_id = i;
              receive_ready = 1;
              #10;
              receive_ready = 0;
              #100;
          end
          #20;
          $finish;
     end
     
     always @(posedge clk) begin
             $display("Time %t: func_id=%0d, char_out=%h", 
                      $time, func_id, char_out);
     end
 
endmodule
