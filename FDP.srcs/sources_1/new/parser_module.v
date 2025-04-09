`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2025 01:13:10 AM
// Design Name: 
// Module Name: parser_module
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


module parser_module(
    input  [63:0] equation_in, // 16 tokens x 4 bits
    input         clk,
    input         rst,
    input         start,
    output reg [7:0] truth_table,
    output reg     done
);

    // We'll store the 16 nibbles in an array
    reg [3:0] tokens [0:15];

    // Simple state machine using localparams
    localparam IDLE   = 2'd0,
               LOAD   = 2'd1,
               EVAL   = 2'd2,
               FINISH = 2'd3;

    reg [1:0] current_state, next_state;

    // Some registers for parsing
    integer i, t;
    reg       temp_result;     // partial result for current i
    reg [3:0] tk;              // current token
    reg [3:0] last_op;         // which operator we used last (+ or .)
    reg       next_op_is_not;  // if we saw '~'
    reg       var_bit;         // the current operand's value

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE:   if (start) next_state = LOAD;
            LOAD:   next_state = EVAL;
            EVAL:   next_state = FINISH;
            FINISH: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done        <= 1'b0;
            truth_table <= 8'h00;
            // Initialize tokens
            for (i=0; i<16; i=i+1) begin
                tokens[i] <= 4'hF; // default to F
            end
        end
        else begin
            case (current_state)

            //-------------------------------------------------------
            // IDLE: do nothing, wait for `start`
            IDLE: begin
                done <= 1'b0;
            end

            //-------------------------------------------------------
            // LOAD: copy 64-bit into tokens[]
            LOAD: begin
                for (i=0; i<16; i=i+1) begin
                    // tokens[0] = eq_in[63:60], tokens[1] = eq_in[59:56], ...
                    tokens[i] <= equation_in[(15 - i)*4 +: 4];
                end
            end

            //-------------------------------------------------------
            // EVAL: for each i in 0..7 => (A,B,C) = (i[2], i[1], i[0])
            // parse the tokens in a nested loop
            EVAL: begin
                for (i=0; i<8; i=i+1) begin
                    // Initialize parse for combo i
                    temp_result    = 1'b0;  // start with 0
                    last_op        = 4'h3;  // treat as '+' initially
                    next_op_is_not = 1'b0;

                    // We'll parse up to 16 tokens, or until we see 4'hF
                    begin : PARSE_BLOCK
                        for (t=0; t<16; t=t+1) begin
                            tk = tokens[t];
                            if (tk == 4'hF) begin
                                // end of expression => break out
                                disable PARSE_BLOCK;
                            end
                            else if (tk <= 4'h2) begin
                                // operand => A=0, B=1, C=2
                                case (tk)
                                    4'h0: var_bit = i[2]; // A
                                    4'h1: var_bit = i[1]; // B
                                    4'h2: var_bit = i[0]; // C
                                    default: var_bit = 1'b0;
                                endcase

                                // If we saw '~', invert the next operand
                                if (next_op_is_not) begin
                                    var_bit        = ~var_bit;
                                    next_op_is_not = 1'b0;
                                end

                                // Apply last_op to combine with temp_result
                                if (last_op == 4'h3) begin
                                    // '+' => OR
                                    temp_result = temp_result | var_bit;
                                end
                                else if (last_op == 4'h4) begin
                                    // '.' => AND
                                    temp_result = temp_result & var_bit;
                                end
                            end
                            else if (tk == 4'h3) begin
                                // '+' => OR
                                last_op = 4'h3;
                            end
                            else if (tk == 4'h4) begin
                                // '.' => AND
                                last_op = 4'h4;
                            end
                            else if (tk == 4'h5) begin
                                // '~' => invert next operand
                                next_op_is_not = 1'b1;
                            end
                        end // for(t)
                    end // PARSE_BLOCK

                    // Store final result for combo i
                    truth_table[i] <= temp_result;
                end // for i
            end // EVAL

            //-------------------------------------------------------
            // FINISH
            FINISH: begin
                done <= 1'b1;
            end

            endcase
        end
    end

endmodule
