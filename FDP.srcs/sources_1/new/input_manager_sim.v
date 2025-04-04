`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2025 04:16:38 PM
// Design Name: 
// Module Name: tb_key_buffer
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


module input_manager_sim;
    reg clk = 0;
    reg reset = 0;
    reg key_pressed = 0;
    reg [3:0] key_value = 4'b0000;
    wire [63:0] buffer_out;
    wire locked;
    
    parameter KEY_A = 4'b0000; 
    parameter KEY_B = 4'b0001; 
    parameter KEY_C = 4'b0010; 
    parameter KEY_NOT = 4'b0100; 
    parameter KEY_OR = 4'b0101; 
    parameter KEY_AND = 4'b0110; 
    parameter KEY_LBRAC = 4'b1000; 
    parameter KEY_RBRAC = 4'b1001; 
    parameter KEY_DELETE = 4'b1010; 
    parameter KEY_ENTER = 4'b1011;

    input_manager manager (
        .clk(clk),
        .reset(reset),
        .selected_key(key_value),
        .key_pressed(key_pressed),
        .buffer_out(buffer_out),
        .locked(locked)
    );

    always #5 clk = ~clk;

    initial begin
    
        reset = 1;
        #20;
        reset = 0;

        press_key(KEY_A); 
        press_key(KEY_NOT); 
        press_key(KEY_OR); 
        press_key(KEY_NOT); 
        press_key(KEY_LBRAC); 
        press_key(KEY_B); 
        press_key(KEY_RBRAC); 
        press_key(KEY_LBRAC); 
        press_key(KEY_AND); 
        press_key(KEY_LBRAC); 
        press_key(KEY_C); 
        press_key(KEY_AND); 
        press_key(KEY_RBRAC); 
        press_key(KEY_B); 
        press_key(KEY_RBRAC); 
        
        press_key(4'b1010);
        press_key(4'b1010);

        press_key(4'b1011);

        press_key(4'b0100);

        #50;
    end

    task press_key(input [3:0] val);
        begin
            key_value = val;
            key_pressed = 1;
            #10;
            key_pressed = 0;
            #10;
        end
    endtask

endmodule
