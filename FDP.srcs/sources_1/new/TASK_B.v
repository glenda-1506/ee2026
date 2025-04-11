`timescale 1ns / 1ps

module TASK_B(
    input MAIN_CLOCK,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [15:0] sw,   // Switch inputs to control letter display    
    input reset,    
    input fb,
    input [3:0] selected_key,
    input key_pressed,
    output led,
    output signal,
    output reg [15:0] oled_data_reg = 0,
    output keyboard_lock,
    input locked,
    input [63:0] buffer,
    output [3:0] last_selected_reg
); 
    wire clk6p25m;
    wire [15:0] out;
   

    Display_Typing display_unit (
        .clk(MAIN_CLOCK), 
       // .reset(sw[0]),
        .fb(fb),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .program_locked(locked),
        //.led(led),
        //.signal(signal),
        .pixel_data(out),
        .keyboard_lock(keyboard_lock),
        .buffer(buffer)
    );

always @(posedge MAIN_CLOCK) begin
    oled_data_reg <= out;
end

endmodule