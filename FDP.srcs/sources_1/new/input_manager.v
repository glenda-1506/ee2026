`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 10:17:30 PM
// Design Name: 
// Module Name: input_manager
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


module input_manager(
    input clk,
    input reset,
    input key_pressed,
    input [3:0] key_value,
    output reg [63:0] buffer_out
    );
    
    reg [3:0] buffer [15:0];
    reg [4:0] num_keys;
    reg locked;

    reg prev_key_pressed;
    wire key_pressed_edge = key_pressed && !prev_key_pressed;

    always @(posedge clk or posedge reset) begin
        if (reset)
            prev_key_pressed <= 1'b0;
        else
            prev_key_pressed <= key_pressed;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            num_keys <= 0;
            locked <= 0;
            buffer_out <= 64'hFFFFFFFFFFFFFFFF;
            buffer[0]  <= 4'b1111; 
            buffer[1]  <= 4'b1111;
            buffer[2]  <= 4'b1111; 
            buffer[3]  <= 4'b1111;
            buffer[4]  <= 4'b1111; 
            buffer[5]  <= 4'b1111;
            buffer[6]  <= 4'b1111; 
            buffer[7]  <= 4'b1111;
            buffer[8]  <= 4'b1111; 
            buffer[9]  <= 4'b1111;
            buffer[10] <= 4'b1111; 
            buffer[11] <= 4'b1111;
            buffer[12] <= 4'b1111; 
            buffer[13] <= 4'b1111;
            buffer[14] <= 4'b1111; 
            buffer[15] <= 4'b1111;
        end else if (key_pressed_edge && !locked) begin
            if (key_value == 4'b1010) begin
                if (num_keys > 0) begin
                    num_keys <= num_keys - 1;
                    buffer[num_keys - 1] <= 4'b1111;
                end
            end else if (key_value == 4'b1011) begin
                locked <= 1;
            end else if (key_value != 4'b1111 && num_keys < 16) begin
                buffer[num_keys] <= key_value;
                num_keys <= num_keys + 1;
            end
        end
    end
    
    always @(*) begin
        buffer_out =
            {buffer[0], buffer[1], buffer[2], buffer[3],
             buffer[4], buffer[5], buffer[6], buffer[7],
             buffer[8], buffer[9], buffer[10], buffer[11],
             buffer[12], buffer[13], buffer[14], buffer[15]};
    end

endmodule
