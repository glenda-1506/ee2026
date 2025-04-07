`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 08:37:50 PM
// Design Name: 
// Module Name: wire_gate_3_control_MPOS
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


module wire_gate_3_control_MPOS #(
    parameter IS_MSOP = 0
    )(
    input clk,
    input reset,
    input [7:0] func_id,
    output reg [5:0] wire_id,
    output reg [1:0] gate_type,
    output reg [2:0] gate_id,
    output reg [2:0] input_count,
    output reg valid
    );
    
    // Wires / Regs / Other modules  
    reg receive_ready;
    wire transmit_ready;
    wire [3:0] char; 
    var_3_gen #(IS_MSOP) gen (clk, func_id, receive_ready, transmit_ready, char); 
    
    // Storage for sum terms
    reg [3:0] sum_vars [0:3][0:2];
    reg [1:0] sum_count [0:3];
    reg [2:0] total_sums;
    reg [2:0] current_sum;
    reg parse_done;
    
    // Finite State Machine states
    reg [4:0] state;
    localparam [4:0] IDLE           = 5'd0,
                     READ           = 5'd1,
                     WAIT_FOR_PARSE = 5'd2,
                     PARSE_COMPLETE = 5'd3,
                     S0_WIRE_OUT    = 5'd4,
                     S0_GATE_OUT    = 5'd5,
                     S1_WIRE_OUT    = 5'd6,
                     S1_GATE_OUT    = 5'd7,
                     S2_WIRE_OUT    = 5'd8,
                     S2_GATE_OUT    = 5'd9,
                     S3_WIRE_OUT    = 5'd10,
                     S3_GATE_OUT    = 5'd11,
                     AND_SET_UP     = 5'd12,
                     AND4_WIRE_OUT  = 5'd13,
                     AND4_GATE_OUT  = 5'd14,
                     AND5_WIRE_OUT  = 5'd15,
                     AND5_GATE_OUT  = 5'd16,
                     WAIT_NOT       = 5'd17,
                     DONE           = 5'd31;
    
    // Track wire and gate use 
    reg [2:0] wire_output_index;
    reg used_gate [0:5];
    reg wire_used [0:49];
    
    // Wire conflicts (Once 1 used, all others disabled)
    reg [5:0] wire_set [0:5][0:4];
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////  
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            set_default_output();
            init(); // task to re-initialise all
        end else begin
            set_default_output();
            case (state)
                IDLE:begin state <= READ; receive_ready <= 1'b1; end
                READ: begin
                    if (transmit_ready) begin
                        if (char == 4'hF) begin // end
                            parse_done <= 1;
                            update_sum_count();
                            state <= WAIT_FOR_PARSE;
                        end else if(char == 4'h6) begin // AND
                            update_sum_count();
                            current_sum <= (current_sum < 3) ? current_sum + 1 : current_sum;
                        end else if(char == 4'h4) begin // NOT
                            state <= WAIT_NOT; // char comes in the next clk
                        end else if (char == 4'h5) begin // OR GATE -> just continue
                        end else begin // 0,1,2 -> A, B, C 
                            if (char <= 4'h2) store_variable(char);
                        end
                    end
                end
                
                WAIT_NOT: begin
                    if (transmit_ready) begin
                        case (char) 
                            4'd0: store_variable(4'd3); // ~A
                            4'd1: store_variable(4'd4); // ~B
                            4'd2: store_variable(4'd5); // ~C
                        endcase
                        state <= READ;
                    end
                end
                
                WAIT_FOR_PARSE: state <= PARSE_COMPLETE;
                PARSE_COMPLETE: begin
                    if (parse_done && total_sums > 0) state <= S0_WIRE_OUT;
                    else if(parse_done) state <= DONE;
                end
                
                S0_WIRE_OUT: begin
                    if (wire_output_index < sum_count[0])begin
                        output_wire(map_var_wire(sum_vars[0][wire_output_index], 3'd0));
                        wire_output_index <= wire_output_index + 1;
                    end else begin
                        wire_output_index <= 0;
                        state <= S0_GATE_OUT; // wire complete, proceed to gate assignment
                    end
                end
                
                S0_GATE_OUT: begin // definitely OR gate
                    output_gate(2'b1, 3'd0, sum_count[0]);
                    state <= S1_WIRE_OUT;
                end
                
                S1_WIRE_OUT: begin
                    if(total_sums > 1) begin
                        if (wire_output_index < sum_count[1])begin
                            output_wire(map_var_wire(sum_vars[1][wire_output_index], 3'd1));
                            wire_output_index <= wire_output_index + 1;
                        end else begin
                            wire_output_index <= 0;
                            state <= S1_GATE_OUT; 
                        end
                    end
                end
                
                S1_GATE_OUT: begin // definitely OR gate
                    output_gate(2'b1, 3'd1, sum_count[1]);
                    state <= (total_sums > 2) ? S2_WIRE_OUT : AND_SET_UP;
                end
                
                S2_WIRE_OUT: begin
                    if(total_sums > 2) begin
                        if (wire_output_index < sum_count[2])begin
                            output_wire(map_var_wire(sum_vars[2][wire_output_index], 3'd2));
                            wire_output_index <= wire_output_index + 1;
                        end else begin
                            wire_output_index <= 0;
                            state <= S2_GATE_OUT; 
                        end
                    end
                end
                
                S2_GATE_OUT: begin // definitely OR gate
                    output_gate(2'b1, 3'd2, sum_count[2]);
                    state <= (total_sums > 3) ? S3_WIRE_OUT : AND_SET_UP ;
                end
                
                S3_WIRE_OUT: begin
                    if (total_sums > 3) begin
                        if (wire_output_index < sum_count[3])begin
                            output_wire(map_var_wire(sum_vars[3][wire_output_index], 3'd3));
                            wire_output_index <= wire_output_index + 1;
                        end else begin
                        wire_output_index <= 0;
                        state <= S3_GATE_OUT;
                        end
                    end else begin
                        state <= AND_SET_UP;
                    end
                end
                
                S3_GATE_OUT: begin // definitely OR gate
                    output_gate(2'b1, 3'd3, sum_count[3]);
                    state <= AND_SET_UP;
                end
                
                AND_SET_UP: begin
                    if (total_sums == 1) state <= DONE; // since 1 product means there is no need for OR gate
                    else state <= AND4_WIRE_OUT;
                end
                
                AND4_WIRE_OUT: begin
                    if(wire_output_index == 0) begin 
                        output_wire(map_gate_wire(0,4)); // gate 0 to 4
                        wire_output_index <= wire_output_index + 1;
                    end else if (wire_output_index == 1 && total_sums >= 2) begin
                        output_wire(map_gate_wire(1,4)); // gate 1 to 4
                        wire_output_index <= wire_output_index + 1;
                    end else if (wire_output_index == 2 && total_sums >= 3) begin
                        output_wire(map_gate_wire(2,4)); // gate 2 to 4
                        wire_output_index <= wire_output_index + 1;
                    end else begin
                        wire_output_index <= 0;
                        state <= AND4_GATE_OUT;
                    end
                end
                
                AND4_GATE_OUT: begin
                    // Can either have an OR with 2 or 3 inputs
                    if(total_sums == 2) output_gate(2'b10, 3'd4, 3'd2);
                    else if(total_sums == 3 || total_sums == 4) output_gate(2'b10, 3'd4, 3'd3);
                    state <= (total_sums == 4) ? AND5_WIRE_OUT : DONE; // need another AND gate if there are more than 3 sums
                end
                
                AND5_WIRE_OUT: begin
                    if (wire_output_index == 0) begin
                        output_wire(map_gate_wire(3,5));
                        wire_output_index <= wire_output_index + 1;
                    end else if (wire_output_index == 1) begin
                        output_wire(map_gate_wire(4,5));
                        wire_output_index <= 0;
                        state <= AND5_GATE_OUT;
                    end
                end
                
                AND5_GATE_OUT: begin
                    output_gate(2'b10, 3'd5, 3'd2);
                    state <= DONE;
                end
                
                DONE: receive_ready <= 1'b0;
            endcase
        end
    end
    
    //////////////////////////////////////////////////////////////////////////////////
    // HELPER LOGIC
    ////////////////////////////////////////////////////////////////////////////////// 
    task init;
        integer i, j;
    begin
        for(i = 0; i < 4; i = i + 1) begin
            sum_count[i] = 0;
            for(j = 0; j < 3; j = j + 1) sum_vars[i][j] = 4'hF;
        end
        
        for(i = 0; i < 6; i = i + 1) used_gate[i] = 0;
        for(i = 0; i < 50; i = i + 1) wire_used[i] = 1'b0;
        
        wire_set[0][0] = 18; wire_set[0][1] = 21; wire_set[0][2] = 31; wire_set[0][3] = 34; wire_set[0][4] = 37;
        wire_set[1][0] = 19; wire_set[1][1] = 22; wire_set[1][2] = 30; wire_set[1][3] = 33; wire_set[1][4] = 36;
        wire_set[2][0] = 20; wire_set[2][1] = 23; wire_set[2][2] = 32; wire_set[2][3] = 35; wire_set[2][4] = 38;
        wire_set[3][0] = 24; wire_set[3][1] = 27; wire_set[3][2] = 40; wire_set[3][3] = 43; wire_set[3][4] = 46;
        wire_set[4][0] = 25; wire_set[4][1] = 28; wire_set[4][2] = 39; wire_set[4][3] = 42; wire_set[4][4] = 45;
        wire_set[5][0] = 26; wire_set[5][1] = 29; wire_set[5][2] = 41; wire_set[5][3] = 44; wire_set[5][4] = 47;
                
        total_sums = 0;
        current_sum = 0;
        parse_done = 0;
        wire_output_index = 0;
        state = IDLE;
        receive_ready = 1'b0;
    end
    endtask
    
    task set_default_output;
    begin
        valid <= 1'b0;
        wire_id <= 6'd63;
        gate_type <= 2'b11;
        gate_id <= 3'b111;
        input_count <= 3'b111;
    end
    endtask
    
    task store_variable (input [3:0] var);
    begin
        case (current_sum)
            0: if (sum_count[0] < 3) begin
                   sum_vars[0][sum_count[0]] = var;
                   sum_count[0] = sum_count[0] + 1;
               end
            1: if (sum_count[1] < 3) begin
                  sum_vars[1][sum_count[1]] = var;
                  sum_count[1] = sum_count[1] + 1;
               end
            2: if (sum_count[2] < 3) begin
                  sum_vars[2][sum_count[2]] = var;
                  sum_count[2] = sum_count[2] + 1;
               end
            3: if (sum_count[3] < 3) begin
                  sum_vars[3][sum_count[3]] = var;
                  sum_count[3] = sum_count[3] + 1;
               end
        endcase
    end
    endtask
    
    task update_sum_count; // check is needed to determine number of AND gates
    begin
        if ((current_sum == 0) && (sum_count[0] > 0)) total_sums = total_sums + 1;
        if ((current_sum == 1) && (sum_count[1] > 0)) total_sums = total_sums + 1;
        if ((current_sum == 2) && (sum_count[2] > 0)) total_sums = total_sums + 1;
        if ((current_sum == 3) && (sum_count[3] > 0)) total_sums = total_sums + 1;
    end
    endtask
    
    // Conflict Checking Logic (Wires that cannot be used together)
    function wire_in_set(input [5:0] w, a, b, c, d, e);
    begin
        wire_in_set = (w == a) || (w == b) || (w == c) || (w == d) || (w == e);
    end
    endfunction
    
    function any_wire_used_in_set (input [5:0] a, b, c, d, e);
    begin
        any_wire_used_in_set = (wire_used[a] || wire_used[b] || wire_used[c] || wire_used[d] || wire_used[e]);
    end
    endfunction
    
    function conflicts(input [5:0] w);
        integer i;
    begin
        conflicts = 1'b0;
        for(i = 0; i < 6; i = i + 1) begin
            if (wire_in_set(w, wire_set[i][0], wire_set[i][1], wire_set[i][2], wire_set[i][3], wire_set[i][4]) &&
                any_wire_used_in_set(wire_set[i][0], wire_set[i][1], wire_set[i][2], wire_set[i][3], wire_set[i][4])) begin
                conflicts = 1'b1; 
            end
        end  
    end
    endfunction
    
    task mark_used_wire_set (input [5:0] a, b, c, d, e);
    begin
        wire_used[a] = 1; 
        wire_used[b] = 1;
        wire_used[c] = 1;
        wire_used[d] = 1;
        wire_used[e] = 1;
    end
    endtask
    
    task disable_wires(input [5:0] w);
        integer i;
    begin
        for (i = 0; i < 6; i = i + 1) begin
            if (wire_in_set(w, wire_set[i][0], wire_set[i][1], 
                wire_set[i][2], wire_set[i][3], wire_set[i][4])) begin
                mark_used_wire_set(wire_set[i][0], wire_set[i][1], wire_set[i][2], wire_set[i][3], wire_set[i][4]);
            end
        end 
    end
    endtask
    
    // Output tasks
    task output_wire (input [5:0] id);
    begin
       valid <= 1'b1;
       wire_id <= id;
       wire_used[id] = 1'b1;
       disable_wires(id);
    end
    endtask
    
    task output_gate (
       input [1:0] type, input [2:0] id, num_of_in);
    begin
       valid <= 1'b1;
       gate_type <= type;
       gate_id <= id;
       input_count <= num_of_in;
       used_gate[id] = 1;
    end
    endtask
    
    // Map variable to gate wires
    function [5:0] map_var_wire (
       input [3:0] var, // 0: A, 1: B, 2: C, 3: ~A, 4: ~B, 5: ~C
       input [2:0] gate_id );
       /*
       A  : [0,6,12,18,24]
       B  : [1,7,13,19,25]
       C  : [2,8,14,20,26]
       ~A : [3,9,15,21,27]
       ~B : [4,10,16,22,28]
       ~C : [5,11,17,23,29]
       */
    begin
       if (gate_id < 5) map_var_wire = 6 * gate_id + var;
    end
    endfunction     
    
    // Map gate to gate wires
    function [5:0] map_gate_wire (
        input[2:0] start_gate, end_gate);
        /* Logic: Assign the wire only if the wire is not used 
           and there is no other wires in that line in circuit drawing
           0 to 3: [30,31,32]
           1 to 3: [33,34,35]
           2 to 3: [36,37,38]
           0 to 4: [39,40,41]
           1 to 4: [42,43,44]
           2 to 4: [45,46,47]
           3 to 5: [48]
           4 to 5: [49]
        */
    begin
        map_gate_wire = 6'd63;
        if (start_gate == 0 && end_gate == 3) begin // 0 to 3
            if(!wire_used[30] && !conflicts(30)) map_gate_wire = 30;
            else if(!wire_used[31] && !conflicts(31)) map_gate_wire = 31;
            else if(!wire_used[32] && !conflicts(32)) map_gate_wire = 32;
        end
        else if (start_gate == 1 && end_gate == 3) begin // 1 to 3
            if(!wire_used[33] && !conflicts(33)) map_gate_wire = 33;
            else if(!wire_used[34] && !conflicts(34)) map_gate_wire = 34;
            else if(!wire_used[35] && !conflicts(35)) map_gate_wire = 35;
        end
        else if (start_gate == 2 && end_gate == 3) begin // 2 to 3
            if(!wire_used[36] && !conflicts(36)) map_gate_wire = 36;
            else if(!wire_used[37] && !conflicts(37)) map_gate_wire = 37;
            else if(!wire_used[38] && !conflicts(38)) map_gate_wire = 38;
        end
        else if (start_gate == 0 && end_gate == 4) begin // 0 to 4
            if(!wire_used[39] && !conflicts(39)) map_gate_wire = 39;
            else if(!wire_used[40] && !conflicts(40)) map_gate_wire = 40;
            else if(!wire_used[41] && !conflicts(41)) map_gate_wire = 41;
        end
        else if (start_gate == 1 && end_gate == 4) begin // 1 to 4
            if(!wire_used[42] && !conflicts(42)) map_gate_wire = 42;
            else if(!wire_used[43] && !conflicts(43)) map_gate_wire = 43;
            else if(!wire_used[44] && !conflicts(44)) map_gate_wire = 44;
        end
        else if (start_gate == 2 && end_gate == 4) begin // 2 to 4
            if(!wire_used[45] && !conflicts(45)) map_gate_wire = 45;
            else if(!wire_used[46] && !conflicts(46)) map_gate_wire = 46;
            else if(!wire_used[47] && !conflicts(47)) map_gate_wire = 47;
        end
        else if (start_gate == 3 && end_gate == 5 & !wire_used[48]) map_gate_wire = 48; // nothing to conflict
        else if (start_gate == 4 && end_gate == 5 & !wire_used[49]) map_gate_wire = 49; // nothing to conflict
    end
    endfunction
    
endmodule