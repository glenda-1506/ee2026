`timescale 1ns / 1ps

module Display_Typing(
    input clk,
    input fb,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [63:0] buffer,
    output [15:0] pixel_data,
    output reg keyboard_lock
);
    // System States
    parameter S_INIT = 2'd0;
    parameter S_RUN  = 2'd1;
    parameter S_DRAW = 2'd2;
    parameter S_DONE = 2'd3;

    reg [1:0] current_state, next_state;
    reg [4:0] pointer;
    reg found_end;
    reg [3:0] nib_in;
    wire [7:0] ascii_char;  
    wire [2:0] current_row;
    reg  [7:0] ascii_array [0:15];
    reg  [63:0] last_buffer;
    wire [7:0] char_bitmap_wire;
    wire [7:0] mapped_char;
    wire [127:0] ascii_array_flat;
    integer idx;
    
    assign ascii_array_flat = {
        ascii_array[15], ascii_array[14], ascii_array[13], ascii_array[12],
        ascii_array[11], ascii_array[10], ascii_array[9], ascii_array[8],
        ascii_array[7], ascii_array[6], ascii_array[5], ascii_array[4],
        ascii_array[3], ascii_array[2], ascii_array[1], ascii_array[0]
    };
    
    // This is a map which maps out what pointer maps to what character
    char_mapper char_mapper_inst (
        .nib(nib_in),
        .ascii_char(mapped_char)
    );
    
    // This is printing out the buffer data
    printing_display display_renderer_inst (
        .clk(clk),
        .x_addr(x_addr),
        .y_addr(y_addr),
        .ascii_array_flat(ascii_array_flat),
        .pixel_data(pixel_data),
        .current_row(current_row),
        .ascii_char(ascii_char),
        .char_bitmap_wire(char_bitmap_wire)
    );

    // This is the standard output of a character on a 8 by 8 grid
    character_bitmap char_bit_map (
        .char(ascii_char),
        .row(current_row),
        .get_character_bitmap(char_bitmap_wire)
    );

    // Initial Readings
    initial begin
        current_state  <= S_INIT;
        next_state     <= S_INIT;
        pointer        <= 0;
        found_end      <= 0;
        nib_in         <= 4'h0;
        keyboard_lock  <= 1'b0;
        last_buffer    <= 64'h0;
    end
    
    // Update for the clk cycles
    always @(posedge clk) begin
        current_state <= next_state;
        last_buffer   <= buffer;
    end

    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_INIT: begin
                // After init, start reading nibbles
                next_state = S_RUN;
            end

            S_RUN: begin
                // If 'F' is encountered or all 16 nibbles have been read, finish
                if (found_end || (pointer >= 16))
                    next_state = S_DONE;
                else
                    next_state = S_DRAW;
            end

            S_DRAW: begin
                // After storing one nibble, go back to S_RUN
                next_state = S_RUN;
            end

            S_DONE: begin
                // Stay in DONE unless the buffer has changed
                if (buffer != last_buffer)
                    next_state = S_INIT;
                else
                    next_state = S_DONE;
            end
        endcase
    end

    //==========================================================================
    // 3) FSM: Output/Sequential Logic (Read from Buffer into ascii_array)
    //==========================================================================
    
    always @(posedge clk) begin
        case (current_state)
            // S_INIT: Clear pointer, flags, and ascii_array
            S_INIT: begin
                pointer       <= 0;
                found_end     <= 0;
                keyboard_lock <= 1'b0;
                for (idx = 0; idx < 16; idx = idx + 1) begin
                    ascii_array[idx] <= " ";
                end
            end

            // S_RUN: Load next nibble from buffer into nib_in.
            // Do not drive ascii_char here to avoid multiple drivers.
            S_RUN: begin
                nib_in <= buffer[(63 - pointer*4) -: 4];
                if (buffer[(63 - pointer*4) -: 4] == 4'hF)
                    found_end <= 1;
            end

            // S_DRAW: Convert nibble (nib_in) to an ASCII character and store it.
            S_DRAW: begin
                if (!found_end && pointer < 16) begin
                    ascii_array[pointer] <= mapped_char;
                    pointer <= pointer + 1;
                end
            end

            // S_DONE: Lock keyboard; remain until buffer changes.
            S_DONE: begin
                keyboard_lock <= 1'b1;
            end
        endcase
    end
endmodule
