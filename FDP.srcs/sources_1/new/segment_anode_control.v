`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2025 00:31:10
// Design Name: 
// Module Name: segment_anode_control
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

module seg7_control(
    input clk,
    output reg [7:0] seg,       
    output reg [3:0] an      
);
    
    // Segment patterns for ones, tens, hundreds, and thousands
    parameter ONES     = 8'b10100100;  
    parameter TENS     = 8'b11000000;  
    parameter HUNDREDS = 8'b00110000; 
    parameter THOUSANDS = 8'b10010010;

    // Anode activation patterns
    parameter AN_ONES     = 4'b1110; 
    parameter AN_TENS     = 4'b1101; 
    parameter AN_HUNDREDS = 4'b1011; 
    parameter AN_THOUSANDS = 4'b0111; 
    
    parameter DIGIT_REFRESH_COUNT = 99_999; 

    reg [1:0] digit_select;     
    reg [16:0] digit_timer;     

    always @(posedge clk) begin
        if(digit_timer == DIGIT_REFRESH_COUNT) begin
            digit_timer <= 0;  
            digit_select <= digit_select + 1;
        end else begin
            digit_timer <= digit_timer + 1;
        end
    end
    
    always @(*) begin
        case(digit_select)
            2'b00: begin
                seg = ONES;
                an  = AN_ONES;
            end
            2'b01: begin
                seg = TENS;
                an  = AN_TENS;
            end
            2'b10: begin
                seg = HUNDREDS;
                an  = AN_HUNDREDS;
            end
            2'b11: begin
                seg = THOUSANDS;
                an  = AN_THOUSANDS;
            end
        endcase
    end

endmodule
