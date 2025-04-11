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
    input manual_reset,
    input [3:0] selected_key,
    input key_pressed,
    output reg [127:0] buffer_out,
    output reg locked
    );
    
    reg [3:0] input_buffer [0:31];
    reg [5:0] write_ptr;
    reg [3:0] last_selected_key;
    reg [4:0] open_brac_count;
    reg [4:0] close_brac_count;

    wire is_valid;

    integer i;

    always @(*) begin
        buffer_out = {input_buffer[0], input_buffer[1], input_buffer[2], input_buffer[3],
                      input_buffer[4], input_buffer[5], input_buffer[6], input_buffer[7],
                      input_buffer[8], input_buffer[9], input_buffer[10], input_buffer[11],
                      input_buffer[12], input_buffer[13], input_buffer[14], input_buffer[15],
                      input_buffer[16], input_buffer[17], input_buffer[18], input_buffer[19],
                      input_buffer[20], input_buffer[21], input_buffer[22], input_buffer[23],
                      input_buffer[24], input_buffer[25], input_buffer[26], input_buffer[27],
                      input_buffer[28], input_buffer[29], input_buffer[30], input_buffer[31]};
    end

    check_validity validity_check (
        .selected_key(selected_key),
        .last_selected_key(last_selected_key),
        .cursor_pos(write_ptr),
        .open_brac_count(open_brac_count),
        .prev_brac_count(close_brac_count),
        .check_validity(is_valid)
    );
    
    wire trigger;
    single_pulse_debouncer d (clk, key_pressed, trigger);
//    assign trigger = key_pressed;    //test code for simulator

    always @(posedge clk or posedge manual_reset) begin
        if (manual_reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                input_buffer[i] <= 4'b1111;
            end
            write_ptr <= 0;
            locked <= 0;
            last_selected_key <= 4'b1111;
            open_brac_count <= 0;
            close_brac_count <= 0;
        end 
        else if (trigger) begin
            locked <= 0;

            case (selected_key)
                4'b1010: begin
                    if (write_ptr > 0) begin
                        case (input_buffer[write_ptr-1])
                            4'b1000: open_brac_count <= open_brac_count - 1;
                            4'b1001: close_brac_count <= close_brac_count - 1;
                        endcase
                        
                        input_buffer[write_ptr-1] <= 4'b1111;
                        write_ptr <= write_ptr - 1;
                        
                        last_selected_key <= (write_ptr > 1) ? input_buffer[write_ptr-2] : 4'b1111;
                    end
                end
                4'b1011: begin // KEY_ENTER
                    locked <= (is_valid && (open_brac_count == close_brac_count));
                end
                default: begin
                    if (is_valid && write_ptr < 32) begin
                        if (selected_key == 4'b1000) begin 
                            open_brac_count <= open_brac_count + 1;
                        end
                        else if (selected_key == 4'b1001) begin
                            close_brac_count <= close_brac_count + 1;
                        end
                        
                        input_buffer[write_ptr] <= selected_key;
                        write_ptr <= write_ptr + 1;
                        last_selected_key <= selected_key;
                    end
                end
            endcase
        end
    end
endmodule
