`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2025 04:53:27 PM
// Design Name: 
// Module Name: check_validity
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


module check_validity(
    input [3:0] selected_key,
    input [3:0] last_selected_key,
    input [4:0] cursor_pos,
    input [4:0] open_brac_count,
    input [4:0] prev_brac_count,
    output reg check_validity
    );

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

    always @(*) begin
        check_validity = 1;  // Default to valid

        if (selected_key == KEY_ENTER) begin
            if (last_selected_key != KEY_A && last_selected_key != KEY_B && last_selected_key != KEY_C && last_selected_key != KEY_RBRAC) begin
                check_validity = 0;
            end
        end
        else if (cursor_pos == 0) begin
            if (!(selected_key == KEY_NOT || selected_key == KEY_A || selected_key == KEY_B || 
                  selected_key == KEY_C || selected_key == KEY_LBRAC)) begin
                check_validity = 0;
            end
        end
        else if (last_selected_key == KEY_NOT) begin
            if (!(selected_key == KEY_A || selected_key == KEY_B || selected_key == KEY_C || selected_key == KEY_LBRAC)) begin
                check_validity = 0;
            end
        end
        else if (last_selected_key == KEY_A || last_selected_key == KEY_B || last_selected_key == KEY_C) begin
            if (!(selected_key == KEY_AND || selected_key == KEY_OR || selected_key == KEY_RBRAC)) begin
                check_validity = 0;
            end
            if (selected_key == KEY_RBRAC && prev_brac_count == open_brac_count) begin
                check_validity = 0;
            end
        end
        else if (last_selected_key == KEY_AND || last_selected_key == KEY_OR) begin
            if (!(selected_key == KEY_A || selected_key == KEY_B || selected_key == KEY_C || selected_key == KEY_NOT || selected_key == KEY_LBRAC)) begin
                check_validity = 0;
            end
        end
        else if (last_selected_key == KEY_LBRAC) begin
            if (!(selected_key == KEY_A || selected_key == KEY_B || selected_key == KEY_C || selected_key == KEY_NOT)) begin
                check_validity = 0;
            end
        end
        else if (last_selected_key == KEY_RBRAC) begin
            if (!(selected_key == KEY_AND || selected_key == KEY_OR)) begin
                check_validity = 0;
            end
        end
        else if (last_selected_key == KEY_DELETE) begin
            check_validity = 1;
        end

        if (cursor_pos == 15) begin
            if (selected_key == KEY_AND || selected_key == KEY_OR || selected_key == KEY_NOT || selected_key == KEY_LBRAC) begin
                check_validity = 0;
            end
        end
    end
endmodule
