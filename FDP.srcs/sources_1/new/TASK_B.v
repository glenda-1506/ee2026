`timescale 1ns / 1ps

module TASK_B(
    input MAIN_CLOCK,
    input [12:0] pixel_index,
    input [15:0] sw,   // Switch inputs to control letter display
    input reset,
    output reg [15:0] oled_data_reg = 0
);

// Define color constants
parameter BLACK = 16'h0000;
parameter WHITE = 16'hFFFF;

// Generate required wires and regs
wire clk_25M;
wire [5:0] letter_ready; // Signals for each letter
reg [3:0] active_count;  // Count of active letters
reg [7:0] start_x;       // Dynamic starting x-position

// Generate 25MHz clock signal
clock clk25 (MAIN_CLOCK, 1, clk_25M);

// Count how many letters are active
always @(*) begin
    active_count = sw[15] + sw[14] + sw[13] + sw[12] + sw[11] + sw[10];
end

// Compute dynamic starting x-position based on active letters
always @(*) begin
    if (active_count == 0)
        start_x = 48; // Center position if no letters are active (X = 48)
    else
        start_x = 48 + ((active_count * 10) / 2); // Center the letters symmetrically around X = 48
end

// Instantiate flipped letter circuits with dynamic X positions
flipped_circuit_letter_A letter_a (pixel_index, start_x, 31, letter_ready[0]);  
flipped_circuit_letter_B letter_b (pixel_index, start_x - 10, 31, letter_ready[1]);    
flipped_circuit_letter_C letter_c (pixel_index, start_x - 20, 31, letter_ready[2]);
flipped_circuit_letter_plus letter_plus (pixel_index, start_x - 30, 31, letter_ready[3]); 
flipped_circuit_letter_dot letter_dot (pixel_index, start_x - 40, 31, letter_ready[4]); 
flipped_circuit_letter_tilde letter_tilde (pixel_index, start_x - 50, 31, letter_ready[5]); 

// Display logic based on switch inputs and letter readiness
always @(posedge clk_25M) begin
    oled_data_reg <= BLACK; // Default to black background

    if (sw[15] == 1 && letter_ready[0]) oled_data_reg <= WHITE; // Display 'A'
    if (sw[14] == 1 && letter_ready[1]) oled_data_reg <= WHITE; // Display 'B'
    if (sw[13] == 1 && letter_ready[2]) oled_data_reg <= WHITE; // Display 'C'
    if (sw[12] == 1 && letter_ready[3]) oled_data_reg <= WHITE; // Display '+'
    if (sw[11] == 1 && letter_ready[4]) oled_data_reg <= WHITE; // Display '.'
    if (sw[10] == 1 && letter_ready[5]) oled_data_reg <= WHITE; // Display '~'
end

endmodule