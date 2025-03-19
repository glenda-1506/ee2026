`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/17/2025 07:52:24 PM
// Design Name: 
// Module Name: key_selector
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

module key_selector(
    input clk,
    input reset,
    input btnU, btnD, btnL, btnR, btnC,
    output reg [3:0] selected_key,
    output reg key_pressed,
    output reg [1:0] current_row,
    output reg [1:0] current_col
);

    reg btnU_prev, btnD_prev, btnL_prev, btnR_prev, btnC_prev;
    wire btnU_rise, btnD_rise, btnL_rise, btnR_rise, btnC_rise;

    initial begin
        key_pressed = 0;
        current_row = 2'b00;
        current_col = 2'b00;
    end

    always @(posedge clk) begin
        btnU_prev <= btnU;
        btnD_prev <= btnD;
        btnL_prev <= btnL;
        btnR_prev <= btnR;
        btnC_prev <= btnC;
    end

    assign btnU_rise = btnU && !btnU_prev;
    assign btnD_rise = btnD && !btnD_prev;
    assign btnL_rise = btnL && !btnL_prev;
    assign btnR_rise = btnR && !btnR_prev;
    assign btnC_rise = btnC && !btnC_prev;

    always @(posedge clk) begin
        if (!reset) begin
            if (btnU_rise && current_row > 2'b00) begin
                current_row <= current_row - 1;
                if (current_row == 2'b10 && current_col == 2'b11) begin
                    current_col <= 2'b10;
                end
            end
            
            else if (btnD_rise && current_row < 2'b10) begin
                current_row <= current_row + 1;
                if (current_col > 2'b10) begin
                    current_col <= 2'b10;
                end
            end
            
            else if (btnL_rise) begin
                if (current_row == 2'b10 && current_col == 2'b11) begin
                    current_col <= 2'b10;
                end
                else if (current_col > 2'b00) begin
                    current_col <= current_col - 1;
                end
            end
            
            else if (btnR_rise) begin
                if (current_row != 2'b10 && current_col < 2'b10) begin
                    current_col <= current_col + 1;
                end
                else if (current_row == 2'b10) begin
                    if (current_col == 2'b10) begin
                        current_col <= 2'b11;
                    end
                    else if (current_col < 2'b10) begin
                        current_col <= current_col + 1;
                    end
                end
            end
    
            if (btnC_rise) begin
                selected_key <= {current_row, current_col};
                key_pressed <= 1;
            end
            
            key_pressed <= 0;
        end
    end
endmodule