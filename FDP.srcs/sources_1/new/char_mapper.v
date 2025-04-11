`timescale 1ns / 1ps

module char_mapper(
    input [3:0] bit_chunk,
    output reg [7:0] ascii_char
);

    always @(*) begin
        case (bit_chunk)
            4'h0: ascii_char = "A";
            4'h1: ascii_char = "B";
            4'h2: ascii_char = "C";
            4'h4: ascii_char = "~";
            4'h5: ascii_char = "+";
            4'h6: ascii_char = ".";
            4'h8: ascii_char = "(";
            4'h9: ascii_char = ")";
            default: ascii_char = " ";
        endcase
    end

endmodule
