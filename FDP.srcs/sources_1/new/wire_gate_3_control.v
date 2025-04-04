`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2025 01:33:10 PM
// Design Name: 
// Module Name: wire_gate_3_control
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
    
module wire_gate_3_control#(
    parameter IS_MSOP = 1
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
    reg [7:0] old_func_id = 8'hff;
    wire transmit_ready;
    wire [3:0] char;   
    var_3_gen #(IS_MSOP)(clk, func_id, receive_ready, transmit_ready, char); 
 
    // Storage for product terms
    reg [3:0] product_vars [0:3][0:2];
    reg [1:0] product_count [0:3];
    reg [2:0] total_products;
    reg [2:0] current_product;
    reg parse_done;

    // FSM STATES 
    reg [4:0] state;
    localparam [6:0] IDLE = 5'd0,
                     READ = 5'd1,
                     WAIT_FOR_PARSE = 5'd2,
                     PARSE_COMPLETE = 5'd3,
                     P0_WIRE_OUT = 5'd4,
                     P0_GATE_OUT = 5'd5,
                     P1_WIRE_OUT = 5'd6,
                     P1_GATE_OUT = 5'd7,
                     P2_WIRE_OUT = 5'd8,
                     P2_GATE_OUT = 5'd9,
                     P3_WIRE_OUT = 5'd10,
                     P3_GATE_OUT = 5'd11,
                     OR_SET_UP = 5'd12,
                     OR4_WIRE_OUT = 5'd13,
                     OR4_GATE_OUT = 5'd14,
                     OR5_WIRE_OUT = 5'd15,
                     OR5_GATE_OUT = 5'd16,
                     WAIT_NOT = 5'd17,
                     DONE = 5'd31;
                     
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
            old_func_id <= 8'hFF;
            set_default_output;
            init; // task to re-initialise all
        end else begin
            if (func_id != old_func_id) begin // check if func_id changed
                old_func_id <= func_id;
                valid <= 1'b0;
                init;
            end else begin
                set_default_output;
                
                case (state)
                    IDLE: state <= READ;
                    READ: begin
                        if (transmit_ready) begin
                            if (char == 4'hF) begin // end
                                parse_done <= 1;
                                update_product_count;
                                state <= WAIT_FOR_PARSE;
                            end else if(char == 4'h5) begin // OR
                                update_product_count;
                                current_product <= (current_product < 3) ? current_product + 1 : current_product;
                            end else if(char == 4'h4) begin // NOT
                                state <= WAIT_NOT; // char comes in the next clk
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
                        if (parse_done && total_products > 0) state <= P0_WIRE_OUT;
                        else if(parse_done) state <= DONE;
                    end
                    
                    P0_WIRE_OUT: begin
                        if (wire_output_index < product_count[0])begin
                            output_wire(map_var_wire(product_vars[0][wire_output_index], 3'd0));
                            wire_output_index <= wire_output_index + 1;
                        end else begin
                            wire_output_index <= 0;
                            state <= P0_GATE_OUT; // wire complete, proceed to gate assignment
                        end
                    end
                    
                    P0_GATE_OUT: begin // definitely AND gate
                        output_gate(2'b10, 3'd0, product_count[0]);
                        state <= P1_WIRE_OUT;
                    end
                    
                    P1_WIRE_OUT: begin
                        if(total_products > 1) begin
                            if (wire_output_index < product_count[1])begin
                                output_wire(map_var_wire(product_vars[1][wire_output_index], 3'd1));
                                wire_output_index <= wire_output_index + 1;
                            end else begin
                                wire_output_index <= 0;
                                state <= P1_GATE_OUT; 
                            end
                        end
                    end
                    
                    P1_GATE_OUT: begin // definitely AND gate
                        output_gate(2'b10, 3'd1, product_count[1]);
                        state <= P2_WIRE_OUT;
                    end
                    
                    P2_WIRE_OUT: begin
                        if(total_products > 2) begin
                            if (wire_output_index < product_count[2])begin
                                output_wire(map_var_wire(product_vars[2][wire_output_index], 3'd2));
                                wire_output_index <= wire_output_index + 1;
                            end else begin
                                wire_output_index <= 0;
                                state <= P2_GATE_OUT; 
                            end
                        end
                    end
                    
                    P2_GATE_OUT: begin // definitely AND gate
                        output_gate(2'b10, 3'd2, product_count[2]);
                        state <= P3_WIRE_OUT;
                    end
                    
                    P3_WIRE_OUT: begin
                        if (total_products > 3) begin
                            if (wire_output_index < product_count[3])begin
                                output_wire(map_var_wire(product_vars[3][wire_output_index], 3'd3));
                                wire_output_index <= wire_output_index + 1;
                            end else begin
                            wire_output_index <= 0;
                            state <= P3_GATE_OUT;
                            end
                        end else begin
                            state <= OR_SET_UP;
                        end
                    end
                    
                    P3_GATE_OUT: begin // definitely AND gate
                        output_gate(2'b10, 3'd3, product_count[3]);
                        state <= OR_SET_UP;
                    end
                    
                    OR_SET_UP: begin
                        if (total_products == 1) state <= DONE; // since 1 product means there is no need for OR gate
                        else state <= OR4_WIRE_OUT;
                    end
                    
                    OR4_WIRE_OUT: begin
                        if(wire_output_index == 0) begin 
                            output_wire(map_gate_wire(0,4)); // gate 0 to 4
                            wire_output_index <= wire_output_index + 1;
                        end else if (wire_output_index == 1 && total_products >= 2) begin
                            output_wire(map_gate_wire(1,4)); // gate 1 to 4
                            wire_output_index <= wire_output_index + 1;
                        end else if (wire_output_index == 2 && total_products >= 3) begin
                            output_wire(map_gate_wire(2,4)); // gate 2 to 4
                            wire_output_index <= wire_output_index + 1;
                        end else begin
                            wire_output_index <= 0;
                            state <= OR4_GATE_OUT;
                        end
                    end
                    
                    OR4_GATE_OUT: begin
                        // Can either have an OR with 2 or 3 inputs
                        if(total_products == 2) output_gate(2'b01, 3'd4, 3'd2);
                        else if(total_products == 3 || total_products == 4) output_gate(2'b01, 3'd4, 3'd3);
                        state <= (total_products == 4) ? OR5_WIRE_OUT : DONE; // need another OR gate if there are more than 3 products
                    end
                    
                    OR5_WIRE_OUT: begin
                        if (wire_output_index == 0) begin
                            output_wire(map_gate_wire(3,5));
                            wire_output_index <= wire_output_index + 1;
                        end else if (wire_output_index == 1) begin
                            output_wire(map_gate_wire(4,5));
                            wire_output_index <= wire_output_index + 1;
                            state <= OR5_GATE_OUT;
                        end
                    end
                    
                    OR5_GATE_OUT: begin
                        output_gate(2'b01, 3'd5, 3'd2);
                        state <= DONE;
                    end
                    
                    DONE: receive_ready <= 1'b0;
                endcase
            end
        end
    end

    //////////////////////////////////////////////////////////////////////////////////
    // HELPER LOGIC
    ////////////////////////////////////////////////////////////////////////////////// 
    task init;
        integer i, j;
    begin
        for(i = 0; i < 4; i = i + 1) begin
            product_count[i] = 0;
            for(j = 0; j < 3; j = j + 1) product_vars[i][j] = 4'hF;
        end
        
        for(i = 0; i < 6; i = i + 1) used_gate[i] = 0;
        
        wire_set[0][0] = 18; wire_set[0][1] = 21; wire_set[0][2] = 31; wire_set[0][3] = 34; wire_set[0][4] = 37;
        wire_set[1][0] = 19; wire_set[1][1] = 22; wire_set[1][2] = 30; wire_set[1][3] = 33; wire_set[1][4] = 36;
        wire_set[2][0] = 20; wire_set[2][1] = 23; wire_set[2][2] = 32; wire_set[2][3] = 35; wire_set[2][4] = 38;
        wire_set[3][0] = 24; wire_set[3][1] = 27; wire_set[3][2] = 40; wire_set[3][3] = 43; wire_set[3][4] = 46;
        wire_set[4][0] = 25; wire_set[4][1] = 28; wire_set[4][2] = 39; wire_set[4][3] = 42; wire_set[4][4] = 45;
        wire_set[5][0] = 26; wire_set[5][1] = 29; wire_set[5][2] = 41; wire_set[5][3] = 44; wire_set[5][4] = 47;
                
        total_products = 0;
        current_product = 0;
        parse_done = 0;
        wire_output_index = 0;
        state = IDLE;
        receive_ready = 1'b1;
    end
    endtask
    
    task set_default_output;
    begin
        valid <= 1'b0;
        wire_id <= 6'd63;
        gate_type <= 2'b11;
        gate_id <= 3'b111;
    end
    endtask
    
    task store_variable (input [3:0] var);
    begin
        case (current_product)
            0: if (product_count[0] < 3) begin
                   product_vars[0][product_count[0]] = var;
                   product_count[0] = product_count[0] + 1;
               end
            1: if (product_count[1] < 3) begin
                  product_vars[1][product_count[1]] = var;
                  product_count[1] = product_count[1] + 1;
               end
            2: if (product_count[2] < 3) begin
                  product_vars[2][product_count[2]] = var;
                  product_count[2] = product_count[2] + 1;
               end
            3: if (product_count[3] < 3) begin
                  product_vars[3][product_count[3]] = var;
                  product_count[3] = product_count[3] + 1;
               end
        endcase
    end
    endtask
    
    task update_product_count; // check is needed to determine number of OR gates
    begin
        if(current_product == 0 && product_count[0] > 0) total_products = total_products + 1;
        if(current_product == 1 && product_count[1] > 0) total_products = total_products + 1;
        if(current_product == 2 && product_count[2] > 0) total_products = total_products + 1;
        if(current_product == 3 && product_count[3] > 0) total_products = total_products + 1;
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
                any_wire_used_in_set(wire_set[i][0], wire_set[i][1], wire_set[i][2], wire_set[i][3], wire_set[i][4]))
                conflicts = 1'b1; i = 7;
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
                i = 7;
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
