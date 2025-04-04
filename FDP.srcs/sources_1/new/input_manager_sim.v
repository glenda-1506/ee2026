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

    // Instantiate your key_buffer module
    input_manager uut (
        .clk(clk),
        .reset(reset),
        .key_pressed(key_pressed),
        .key_value(key_value),
        .buffer_out(buffer_out)
    );

    // Clock generation: 100MHz
    always #5 clk = ~clk;

    initial begin
    
        reset = 1;
        #20;
        reset = 0;

        // Type A (0000), B (0001), C (0010)
        press_key(4'b0000); // A
        press_key(4'b0001); // B
        press_key(4'b0010); // C
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        press_key(4'b0010);
        

        // Press DELETE (1010) ? should remove C
        press_key(4'b1010);
        press_key(4'b1010);

        // Press ENTER (1011) ? should lock input
        press_key(4'b1011);

        // Try typing ~ (0100) after lock ? should be ignored
        press_key(4'b0100);

        #50;
    end

    // Helper task to simulate key press
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
