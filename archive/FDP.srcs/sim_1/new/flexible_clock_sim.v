`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2025 14:28:52
// Design Name: 
// Module Name: flexible_clock_sim
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


module flexible_clock_sim(

    );
    
    reg clock;
    reg [31:0] constant;
    wire slow_clock;
    
    flexible_clock_divider dut (clock, constant, slow_clock);
    
    initial begin
        clock = 0;
        constant = 32'd7;
    end
    
    always begin
    #5; 
    clock = ~clock;
    end
endmodule
