`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 07:03:05 PM
// Design Name: 
// Module Name: var_3_gen
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
// A     : 0
// B     : 1
// C     : 2
// NOT   : 4
// OR    : 5
// AND   : 6
// START : F
//////////////////////////////////////////////////////////////////////////////////

module var_3_gen#(
    parameter IS_MSOP = 1,
    parameter DATA_WIDTH = 124  // e.g. 30 hex characters (30*4 bits)
    )(
    input clk,
    input [7:0] func_id,
    input receive_ready,
    output reg transmit_ready = 0,
    output reg [3:0] char_out
    );

    // Calculate number of hex characters in a line.
    localparam NUM_CHARS = DATA_WIDTH / 4;
    
    // FSM state definitions.
    localparam IDLE   = 2'd0,
               SEARCH = 2'd1,
               SEND   = 2'd2,
               DONE   = 2'd3;
    
    reg [1:0] state = IDLE;
    reg [$clog2(NUM_CHARS)-1:0] index;
    reg [DATA_WIDTH-1:0] expression;
    reg [DATA_WIDTH-1:0] memory [0:255];
    
    wire [3:0] current_hex;
    wire reset;
    assign reset = ~receive_ready;
    assign current_hex = (expression >> (((NUM_CHARS - 1 - index) * 4))) & 4'hF;
    
    initial begin
        if (IS_MSOP)
            $readmemh("msop_3_var.mem", memory);
        else
            $readmemh("mpos_3_var.mem", memory);
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            index <= 0;
            state <= IDLE;
            transmit_ready <= 0;
        end else begin
            case(state)
                IDLE: begin
                    transmit_ready <= 0;
                    if (receive_ready) begin
                        expression <= memory[func_id];
                        index <= 0;
                        state <= SEARCH;
                    end
                end
                
                SEARCH: begin
                    transmit_ready <= 0;
                    if (current_hex == 4'hF) begin
                        if (index < NUM_CHARS - 1) begin
                            index <= index + 1;
                            state <= SEND;
                        end else begin
                            state <= DONE;
                        end
                    end else begin
                        if (index < NUM_CHARS - 1) begin
                            index <= index + 1;
                            state <= SEARCH;
                        end else begin
                            state <= DONE;
                        end
                    end
                end
    
                SEND: begin
                    char_out <= current_hex;
                    transmit_ready <= 1;
                    if (index < NUM_CHARS - 1) begin
                        index <= index + 1;
                        state <= SEND;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    transmit_ready <= 0;
                    state <= IDLE;
                end
    
                default: state <= IDLE;
            endcase
        end
    end
endmodule
