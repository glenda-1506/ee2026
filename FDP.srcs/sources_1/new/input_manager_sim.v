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

module input_manager_sim (

    );
    
    reg clk;
    reg reset;
    reg manual_reset;
    reg [3:0] selected_key;
    reg key_pressed;
    wire [127:0] buffer_out;
    wire locked;
    
    parameter KEY_A      = 4'b0000;
    parameter KEY_B      = 4'b0001;
    parameter KEY_C      = 4'b0010;
    parameter KEY_NOT    = 4'b0100;
    parameter KEY_OR     = 4'b0101;
    parameter KEY_AND    = 4'b0110;
    parameter KEY_LBRAC  = 4'b1000;
    parameter KEY_RBRAC  = 4'b1001;
    parameter KEY_DELETE = 4'b1010;
    parameter KEY_ENTER  = 4'b1011;

    input_manager uut (
        .clk(clk),
        .reset(reset),
        .manual_reset(manual_reset),
        .selected_key(selected_key),
        .key_pressed(key_pressed),
        .buffer_out(buffer_out),
        .locked(locked)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        manual_reset = 0;
        selected_key = 4'b1111;  
        key_pressed = 0;
        
        manual_reset = 1;
        #10;
        manual_reset = 0;
        #10;
        
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        press_key(KEY_A);
        press_key(KEY_OR);
        press_key(KEY_B);
        press_key(KEY_OR);
        press_key(KEY_B);        
        press_key(KEY_OR);
        press_key(KEY_B);
        press_key(KEY_OR);
        press_key(KEY_B);        
        press_key(KEY_OR);
        press_key(KEY_B);
        press_key(KEY_OR);
        press_key(KEY_B);        
        press_key(KEY_OR);
        press_key(KEY_B);
        press_key(KEY_OR);
        press_key(KEY_B);        
        press_key(KEY_OR);
        press_key(KEY_B);
        press_key(KEY_OR);
        press_key(KEY_B);       
        press_key(KEY_OR);
        press_key(KEY_B);
        press_key(KEY_OR);
        press_key(KEY_B);        
        press_key(KEY_OR);
        press_key(KEY_B);
        
        press_key(KEY_DELETE);
        press_key(KEY_DELETE);
        
        press_key(KEY_ENTER);
        
        press_key(KEY_B);
        
        #50;
        $finish;
    end

    task press_key;
        input [3:0] key_val;
        begin
            selected_key = key_val;
            key_pressed = 1;
            #10;
            key_pressed = 0;
            #20;  
        end
    endtask

endmodule
