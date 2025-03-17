`timescale 1ns / 1ps

module TASK_B(
    input MAIN_CLOCK,
    input [12:0] pixel_index,
    input [15:0] sw,   // Switch inputs to control letter display
    input reset,
    output reg [15:0] oled_data_reg = 0
);

// Define clock parameters
parameter basys3_clk_freq = 100_000_000;
parameter frame_rate = 12;

// Generate required wires and regs
wire clk_25M, clk_frameRate;
wire [15:0] main_screen_out, A , B, C, dot, plus, tilde;
wire [31:0] clk_param;
wire [5:0] letter_ready; // Signals for each letter
reg [3:0] active_count;  // Count of active letters
reg [7:0] start_x;       // Dynamic starting x-position

// Generate clock signals
clock clk25 (MAIN_CLOCK, 1, clk_25M);
clock clkframeRate (MAIN_CLOCK, clk_param, clk_frameRate);

assign clk_param = (basys3_clk_freq / (frame_rate)) - 1;

// Instantiate flipped letter circuits with dynamic X positions
flipped_circuit_letter_A letter_a (clk_frameRate, pixel_index, A);  
flipped_circuit_letter_B letter_b (clk_frameRate, pixel_index, B);   
flipped_circuit_letter_C letter_c (clk_frameRate, pixel_index, C);
flipped_circuit_letter_plus letter_plus (clk_frameRate, pixel_index, plus);
flipped_circuit_letter_dot letter_dot (clk_frameRate, pixel_index, dot);
flipped_circuit_letter_tilde letter_tilde (clk_frameRate, pixel_index, tilde);

// Main starting screen
main_starting_screen main_menu (clk_frameRate, pixel_index, main_screen_out);

// Display logic based on switch inputs and letter readiness
always @(posedge clk_25M) begin
    oled_data_reg <= main_screen_out; // Default to main screen output

    // Only show letter when corresponding switch is active and the letter is ready
    if (sw[15] == 1) oled_data_reg <= A; // Display 'A'
    if (sw[14] == 1) oled_data_reg <= B; // Display 'B'
    if (sw[13] == 1) oled_data_reg <= C; // Display 'C'
    if (sw[12] == 1) oled_data_reg <= plus; // Display '+'
    if (sw[11] == 1) oled_data_reg <= dot; // Display '.'
    if (sw[10] == 1) oled_data_reg <= tilde; // Display '~'
end

endmodule
