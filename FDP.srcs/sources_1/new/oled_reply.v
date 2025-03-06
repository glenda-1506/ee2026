`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.03.2025 22:58:36
// Design Name: 
// Module Name: oled_reply
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


module button_count (
    input pb,                    
    input clk,
    input reset,                 
    output reg [2:0] state_output,  
    output reg [15:0] display_data  
);
    reg [2:0] state = 3'b000;     
    reg prev_pb = 0;              
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            state_output <= 3'b000; 
            display_data <= 16'b0;  
        end else if (pb && !prev_pb) begin
            if (state == 3'b101) begin
                state <= 3'b000; 
            end else begin
                state <= state + 1;  
            end
            state_output <= state + 1;  
        end
        prev_pb <= pb;
        
        case(state)
            3'b000: display_data = 16'b11111_111111_11111;
            3'b001: display_data = 16'b11111_000000_00000;
            3'b010: display_data = 16'b00000_111111_00000;
            3'b011: display_data = 16'b00000_000000_11111;
            3'b100: display_data = 16'b11111_101000_00000;
            3'b101: display_data = 16'b0;  
            default: display_data = 16'b11111_111111_11111;
        endcase
    end
endmodule
