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


//module input_manager_sim;
//    reg clk = 0;
//    reg reset = 0;
//    reg key_pressed = 0;
//    reg [3:0] key_value = 4'b0000;
//    wire [63:0] buffer_out;
//    wire locked;
    
//    parameter KEY_A = 4'b0000; 
//    parameter KEY_B = 4'b0001; 
//    parameter KEY_C = 4'b0010; 
//    parameter KEY_NOT = 4'b0100; 
//    parameter KEY_OR = 4'b0101; 
//    parameter KEY_AND = 4'b0110; 
//    parameter KEY_LBRAC = 4'b1000; 
//    parameter KEY_RBRAC = 4'b1001; 
//    parameter KEY_DELETE = 4'b1010; 
//    parameter KEY_ENTER = 4'b1011;

//    input_manager manager (
//        .clk(clk),
//        .reset(reset),
//        .selected_key(key_value),
//        .key_pressed(key_pressed),
//        .buffer_out(buffer_out),
//        .locked(locked)
//    );

//    always #5 clk = ~clk;

//    initial begin
    
//        reset = 1;
//        #20;
//        reset = 0;

//        press_key(KEY_A); 
//        press_key(KEY_NOT); 
//        press_key(KEY_OR); 
//        press_key(KEY_NOT); 
//        press_key(KEY_LBRAC); 
//        press_key(KEY_B); 
//        press_key(KEY_RBRAC); 
//        press_key(KEY_LBRAC); 
//        press_key(KEY_AND); 
//        press_key(KEY_LBRAC); 
//        press_key(KEY_C); 
//        press_key(KEY_AND); 
//        press_key(KEY_RBRAC); 
//        press_key(KEY_B); 
//        press_key(KEY_RBRAC); 
        
//        press_key(4'b1010);
//        press_key(4'b1010);

//        press_key(4'b1011);

//        press_key(4'b0100);

//        #50;
//    end

//    task press_key(input [3:0] val);
//        begin
//            key_value = val;
//            key_pressed = 1;
//            #10;
//            key_pressed = 0;
//            #10;
//        end
//    endtask

//endmodule

module input_manager_sim (

    );
    reg clk;
    reg reset;
    reg manual_reset;
    reg [3:0] selected_key;
    reg key_pressed;

    wire [63:0] buffer_out;
    wire locked;

    // Instantiate the module
    input_manager uut (
        .clk(clk),
        .reset(reset),
        .manual_reset(manual_reset),
        .selected_key(selected_key),
        .key_pressed(key_pressed),
        .buffer_out(buffer_out),
        .locked(locked)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task for simulating a key press
    task press_key(input [3:0] key);
    begin
        selected_key = key;
        key_pressed = 1;
        #10; // Wait for 1 clock cycle
        key_pressed = 0;
        #10; // Allow time after pulse
    end
    endtask

    initial begin
        // Initial state
        reset = 0;
        manual_reset = 0;
        selected_key = 4'b1111;
        key_pressed = 0;

        // Start with manual reset
        manual_reset = 1;
        #10;
        manual_reset = 0;
        #10;

        // Insert: A (0000), + (0101), B (0001)
        press_key(4'b0000);  // A
        press_key(4'b0101);  // +
        press_key(4'b0001);  // B

        // Press ENTER
        press_key(4'b1011);  // KEY_ENTER
        $display("After A + B + ENTER: buffer = %h, locked = %b", buffer_out, locked);

        // Try more inputs after locked (should NOT change buffer)
        press_key(4'b0010);  // C
        $display("After trying C when locked: buffer = %h, locked = %b", buffer_out, locked);

        // Toggle reset (not manual reset): unlocks but keeps buffer
        reset = 1;
        #10;
        reset = 0;
        #10;

        press_key(4'b0010);  // Now enter C
        $display("After reset + C: buffer = %h, locked = %b", buffer_out, locked);

        // Now manually reset
        manual_reset = 1;
        #10;
        manual_reset = 0;
        #10;

        $display("After manual reset: buffer = %h, locked = %b", buffer_out, locked);

        $finish;
    end
endmodule
