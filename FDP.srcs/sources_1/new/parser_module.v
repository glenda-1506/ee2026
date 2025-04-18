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
    input  [127:0] equation_in,
    input          clk,
    input          rst,
    input          start,
    output reg [7:0] truth_table,
    output reg       done
);

    // Each token is 4 bits, up to 32 tokens
    reg [3:0] tokens [0:31];

    // FSM states
    localparam S_IDLE       = 3'd0,
               S_LOAD       = 3'd1,
               S_EVAL_SETUP = 3'd2,
               S_EVAL       = 3'd3,
               S_FINISH     = 3'd4;

    reg [2:0] current_state, next_state;

    // Counters
    reg [5:0] load_idx;   // 0..31 for storing tokens
    reg [5:0] token_idx;  // 0..32 for evaluating tokens
    reg [2:0] input_idx;  // 0..7 for all (A,B,C) combos

    // Summation / product accumulators
    reg total_sum;
    reg current_product;
    reg [3:0] last_operator;
    reg invert_next;
    reg variable_bit;
    
    // Stack for parentheses
    localparam STACK_DEPTH = 16;
    reg [3:0] stack_pointer;
    reg stack_or [0:STACK_DEPTH-1];
    reg stack_and [0:STACK_DEPTH-1];
    reg [3:0] stack_operator[0:STACK_DEPTH-1];
    reg stack_invert [0:STACK_DEPTH-1];

    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end
    
    // next state logic
    always @(*) begin
        next_state = current_state;
        case (current_state)
            S_IDLE: if (start) next_state = S_LOAD;
            S_LOAD: if (load_idx == 6'd31) next_state = S_EVAL_SETUP;
            S_EVAL_SETUP: next_state = S_EVAL;
            S_EVAL: if (token_idx >= 6'd32) next_state = (input_idx == 3'd7) ? S_FINISH : S_EVAL_SETUP;
            S_FINISH: next_state = S_IDLE;
        endcase
    end

    integer i;
    reg temp_sum;
    reg subexpr_result;
    reg [3:0] current_token;
    reg temp_stack_or, temp_stack_and;
    reg [3:0] temp_stack_operator;
    reg temp_stack_invert;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 1'b0;
            truth_table <= 8'h00;

            for (i = 0; i < 32; i = i + 1) tokens[i] <= 4'hF;

            load_idx <= 6'd0;
            token_idx <= 6'd0;
            input_idx <= 3'd0;

            total_sum <= 1'b0;
            current_product <= 1'b0;
            last_operator <= 4'h5;  // interpret '5' as OR
            invert_next <= 1'b0;

            stack_pointer <= 4'd0;
            for (i = 0; i < STACK_DEPTH; i = i + 1) begin
                stack_or[i] <= 1'b0;
                stack_and[i] <= 1'b0;
                stack_operator[i] <= 4'h5;  // default to OR
                stack_invert[i] <= 1'b0;
            end
        end 
        else begin
            // Default: not done unless we assert it in S_FINISH
            done <= 1'b0;

            case (current_state)
            S_IDLE: begin
                load_idx <= 6'd0;
                token_idx <= 6'd0;
                input_idx <= 3'd0;
                total_sum <= 1'b0;
                current_product <= 1'b0;
                last_operator <= 4'h5; // 'OR'
                invert_next <= 1'b0;
                stack_pointer <= 4'd0;
            end

            S_LOAD: begin
                tokens[load_idx] <= equation_in[(31 - load_idx)*4 +: 4];
                if (load_idx < 6'd31)
                    load_idx <= load_idx + 1;
            end

            S_EVAL_SETUP: begin
                total_sum <= 1'b0;
                current_product <= 1'b0;
                last_operator <= 4'h5; // OR
                invert_next <= 1'b0;
                token_idx <= 6'd0;
                stack_pointer <= 4'd0;
            end

            S_EVAL: begin
                current_token = tokens[token_idx[4:0]];

                // If we've reached an 'F' or no more valid tokens, finalize
                if (current_token == 4'hF) begin
                    token_idx <= 6'd33;  // force the out-of-range
                end 
                else begin
                    // ----------------------------------------------------
                    // 0 => A, 1 => B, 2 => C
                    // 4 => NOT, 5 => OR, 6 => AND
                    // 8 => '(',  9 => ')'
                    // ----------------------------------------------------
                    if (current_token <= 4'h2) begin
                        // It's a variable token A/B/C
                        case (current_token)
                            4'h0: variable_bit = input_idx[2]; // A
                            4'h1: variable_bit = input_idx[1]; // B
                            4'h2: variable_bit = input_idx[0]; // C
                            default: variable_bit = 1'b0;
                        endcase
                        // Apply NOT if flagged
                        if (invert_next) begin
                            variable_bit = ~variable_bit;
                            invert_next  <= 1'b0;
                        end

                        // Accumulate with the last operator
                        if (last_operator == 4'h6) // AND
                            current_product <= current_product & variable_bit;
                        else begin
                            current_product <= variable_bit;
                        end
                    end 
                    else if (current_token == 4'h4) begin
                        // NOT
                        invert_next <= 1'b1;
                    end 
                    else if (current_token == 4'h5) begin
                        total_sum <= total_sum | current_product;
                        last_operator <= 4'h5;
                    end 
                    else if (current_token == 4'h6) begin
                        // AND
                        last_operator <= 4'h6;
                    end 
                    else if (current_token == 4'h8) begin
                        // '(' => push current state onto stack
                        stack_or[stack_pointer] <= total_sum;
                        stack_and[stack_pointer] <= current_product;
                        stack_operator[stack_pointer] <= last_operator;
                        stack_invert[stack_pointer] <= invert_next;
                        stack_pointer <= stack_pointer + 1'b1;

                        // Reset accumulators for the sub-expression
                        total_sum <= 1'b0;
                        current_product <= 1'b0;
                        last_operator <= 4'h5; 
                        invert_next <= 1'b0;
                    end 
                    else if (current_token == 4'h9) begin
                        // ')' => pop stack
                        subexpr_result = total_sum | current_product;
                        // If there's a NOT pending, apply it
                        if (invert_next) begin
                            subexpr_result = ~subexpr_result;
                            invert_next <= 1'b0;
                        end

                        // Restore stack
                        temp_stack_or = stack_or[stack_pointer - 1];
                        temp_stack_and  = stack_and[stack_pointer - 1];
                        temp_stack_operator = stack_operator[stack_pointer - 1];
                        temp_stack_invert = stack_invert[stack_pointer - 1];
                        stack_pointer <= stack_pointer - 1'b1;

                        // Merge subexpr_result back with popped context
                        total_sum <= temp_stack_or;

                        if (temp_stack_operator == 4'h6)  // AND
                            current_product <= temp_stack_and & subexpr_result;
                        else
                            current_product <= subexpr_result;

                        last_operator <= temp_stack_operator;
                        invert_next <= temp_stack_invert;
                    end

                    // Move token index
                    if (token_idx < 6'd32)
                        token_idx <= token_idx + 1;
                end

                if (token_idx >= 6'd32) begin
                    temp_sum = total_sum | current_product;
                    truth_table[input_idx] <= temp_sum;

                    // Move to next combination if not done
                    if (input_idx < 3'd7)
                        input_idx <= input_idx + 1;
                end
            end

            S_FINISH: begin
                done <= 1'b1;
            end

            endcase
        end
    end

endmodule
