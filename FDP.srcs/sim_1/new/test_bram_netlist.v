`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2025 10:04:27 PM
// Design Name: 
// Module Name: test_bram_netlist
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


module test_bram_netlist(

    );
    parameter NETLIST_WIDTH = 276;
    reg clk = 0;
    reg [7:0] id = 0;
    wire [NETLIST_WIDTH-1:0] out;
    
    always #5 clk = ~clk;
    netlist_generator #(0) dut (clk, id, out);
    
    integer i;
    initial begin
        #5
        for (i = 0; i < 50; i = i + 1) begin
            id = i;
            #10; 
        end
        #20 $finish;
    end
    
    initial begin
        $monitor("At time %t, id=%d out=%h", $time, id, out);
    end
endmodule
