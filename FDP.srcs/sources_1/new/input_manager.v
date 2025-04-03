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
    input key_pressed,        // Signals when a new key is pressed
    input [3:0] selected_key, // The current selected key (A, B, C, DEL, ENTER, etc.)
    output reg [15:0] text_output, // Output the final text (16 characters max)
    output reg [3:0] current_input // The current key (A, B, C, DEL, ENTER)
    );

    // FIFO buffer for the text box (16 characters)
    reg [3:0] buffer [15:0];  // Buffer to store the last 16 characters
    reg [3:0] write_ptr = 0;  // Write pointer to store new characters
    reg [3:0] read_ptr = 0;   // Read pointer for displaying text
    reg [3:0] char_count = 0; // Count of characters currently in the text box

    // Key definitions
    parameter KEY_A      = 4'b0100; 
    parameter KEY_B      = 4'b0101; 
    parameter KEY_C      = 4'b0110; 
    parameter KEY_TILDA  = 4'b1000;
    parameter KEY_PLUS   = 4'b1001;
    parameter KEY_DOT    = 4'b1010;
    parameter KEY_LBRAC  = 4'b1100;
    parameter KEY_RBRAC  = 4'b1101;
    parameter KEY_DEL    = 4'b1110; 
    parameter KEY_ENTER  = 4'b1111;

    // Handle the key press
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            write_ptr <= 0;
            char_count <= 0;
            text_output <= 16'b0; // Clear the output text
        end
        else if (key_pressed) begin
            if (selected_key != KEY_DEL && selected_key != KEY_ENTER) begin
                // Insert the new character into the buffer if it's not DEL or ENTER
                if (char_count < 16) begin
                    buffer[write_ptr] <= selected_key;  // Store character at write_ptr
                    write_ptr <= write_ptr + 1;         // Increment write pointer
                    char_count <= char_count + 1;       // Increase the character count
                end
            end
            else if (selected_key == KEY_DEL && char_count > 0) begin
                // Delete the most recent character
                write_ptr <= write_ptr - 1;          // Move write pointer back
                char_count <= char_count - 1;        // Decrease the character count
            end
            else if (selected_key == KEY_ENTER) begin
                // Lock the input, finalize the text box content
                // For now, we just finalize the current text
                text_output <= {buffer[0], buffer[1], buffer[2], buffer[3], 
                                buffer[4], buffer[5], buffer[6], buffer[7], 
                                buffer[8], buffer[9], buffer[10], buffer[11], 
                                buffer[12], buffer[13], buffer[14], buffer[15]};
            end
        end
    end

    // Assign the current input key to output register for display purposes
    always @(*) begin
        case (selected_key)
            KEY_A: current_input = KEY_A;
            KEY_B: current_input = KEY_B;
            KEY_C: current_input = KEY_C;
            KEY_TILDA: current_input = KEY_TILDA;
            KEY_PLUS: current_input = KEY_PLUS;
            KEY_DOT: current_input = KEY_DOT;
            KEY_LBRAC: current_input = KEY_LBRAC;
            KEY_RBRAC: current_input = KEY_RBRAC;
            KEY_DEL: current_input = KEY_DEL;
            KEY_ENTER: current_input = KEY_ENTER;
            default: current_input = 4'b0000; // Empty input case
        endcase
    end

endmodule
