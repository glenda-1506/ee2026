`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2025 11:46:47 AM
// Design Name: 
// Module Name: netlist_decoder_3
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

module netlist_decoder_3 #(
    parameter IS_MSOP = 1,
    parameter NETLIST_WIDTH = 368,
    parameter PACKET_SIZE = 28, // 3-input gates have 28 bits for each instruction. 
    parameter FUNCTION_BIT = 7
    )(
    input clk,
    input [FUNCTION_BIT:0] func_id,
    input top_ready,
    output reg [1:0] gate_type,
    output reg [1:0] num_inputs,
    output reg [5:0] output_id,
    output reg [5:0] input_id0,
    output reg [5:0] input_id1,
    output reg [5:0] input_id2,
    output reg valid_gate = 0
    );
    
    // Set parameters
    localparam STATE_BIT = 2;
    localparam IDLE = 3'd0;
    localparam WAIT_LINE = 3'd1;
    localparam SEARCH = 3'd2;
    localparam DECODE = 3'd3;
    localparam OUTPUT = 3'd4;
    localparam DONE = 3'd5;
    localparam NETLIST_INDEX_BIT = $clog2(NETLIST_WIDTH) - 1;
    
    // Set Regs and Wires
    reg [FUNCTION_BIT:0] old_func_id = 8'hFF;
    wire [NETLIST_WIDTH-1:0] netlist_data;
    wire transmit_ready;
    reg receive_ready = 1'b0;
    reg [NETLIST_WIDTH-1:0] data_reg;
    reg [STATE_BIT:0] state;
    reg [NETLIST_INDEX_BIT:0] bit_index, search_index;
    reg [PACKET_SIZE-1:0] current_packet;
    
    netlist_generator #(
        .IS_MSOP (IS_MSOP),
        .NETLIST_WIDTH (NETLIST_WIDTH)
    ) generator (
        .clk (clk),
        .func_id (func_id),
        .receive_ready (receive_ready),
        .transmit_ready (transmit_ready),
        .netlist_data (netlist_data));
        
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////  
    always @(posedge clk) begin
        if (old_func_id != func_id) begin
            old_func_id <= func_id;
            receive_ready <= 1'b1; 
            state <= IDLE;  
        end
        
        case (state)
            IDLE: begin
                if (transmit_ready) begin
                    data_reg <= netlist_data;
                    search_index <= NETLIST_WIDTH - 1;
                    state <= WAIT_LINE;
                end
            end
            
            WAIT_LINE: begin
                receive_ready <= 1'b0;
                state <= SEARCH;
            end
            
            SEARCH: begin
                if (search_index >= PACKET_SIZE) begin
                    if (data_reg[search_index -: 4] == 4'hF) begin
                        // found start signal
                        if (search_index >= (PACKET_SIZE + 3)) begin
                            bit_index <= search_index - 4;
                            state <= DECODE;
                        end else begin
                            state <= DONE;
                        end
                    end
                    else begin
                        if (search_index >= 4) 
                            search_index <= search_index - 4;
                        else
                            state <= DONE;
                    end
                end
                else begin
                    state <= DONE;
                end
            end
            
            DECODE: begin
                if (valid_gate == 1'b1) begin
                    valid_gate <= 1'b0;
                end
                if (top_ready) begin
                    if (bit_index >= (PACKET_SIZE - 1)) begin
                        current_packet <= data_reg[bit_index -: PACKET_SIZE];
                        if (!(bit_index + 1 == PACKET_SIZE)) begin
                            bit_index <= bit_index - PACKET_SIZE;
                        end else begin
                            bit_index <= 0;
                        end
                        state <= OUTPUT;
                    end else begin
                        state <= DONE;
                    end 
                end           
            end
            
            OUTPUT: begin // PROBLEM!!!
                gate_type = current_packet[27:26];
                num_inputs = current_packet[25:24];
                output_id = current_packet[23:18];
                input_id0 = current_packet[17:12];
                input_id1 = (num_inputs > 2'b0) ? current_packet[11:6] : 6'hFF;
                input_id2 = (num_inputs > 2'b1) ? current_packet[5:0] : 6'hFF;
                valid_gate = 1'b1;
                state = DECODE;
            end
            
            DONE: begin
                receive_ready <= 1'b1;
            end
            
            default: begin
                valid_gate <= 1'b0;
                gate_type <= 2'b0;
                num_inputs <= 2'b0;
                output_id <= 6'b0;
                input_id0 <= 6'b0;
                input_id1 <= 6'b0;
                input_id2 <= 6'b0;
            end
        endcase
    end
    
    initial begin
        state = IDLE;
    end

endmodule