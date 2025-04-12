`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 10:53:38 AM
// Design Name: 
// Module Name: circuit_control_3_gate
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


module circuit_control_3_gate(
    input clk,
    input [6:0] x_addr,
    input [5:0] y_addr,
    input [8:0] function_id,
    input reset,
    input btnU, btnD, btnL, btnR, btnC,
    output reg [15:0] oled_data_reg = 0,
    output reg current_req = 0
    );
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameters, wires and regs
    //////////////////////////////////////////////////////////////////////////////////
       
    // Set local parameters
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    parameter DISPLAY_WIDTH = 142; // Change this if require a different dimension
    parameter DISPLAY_HEIGHT = 96; // Change this if require a different dimension
    parameter MODULE_COUNT = 50;
    
    // Generate required wires and regs
    wire [3:0] pb = {btnU, btnD, btnL, btnR};
    wire [13:0] x_index;
    wire [13:0] y_index;
    wire [13:0] x_offset;
    wire [13:0] y_offset;
    
    // Generate the ready flags for items to draw
    wire [3:0] var_ready; // 3 vars and 1 Final signal
    wire [5:0] gate_ready;
    wire legend_ready;
    wire legend_black_ready;
    wire invalid_ready;
    wire [MODULE_COUNT-1:0] wire_ready;
    
    // Generate virtual oled
    virtual_oled_generator #(DISPLAY_WIDTH, DISPLAY_HEIGHT) v_oled 
                            (clk, reset, pb, x_addr, y_addr, x_index, y_index, x_offset, y_offset);
                            
    //////////////////////////////////////////////////////////////////////////////////
    // GATE VARIABLES / WIRES / REGS
    //////////////////////////////////////////////////////////////////////////////////  
    reg [7:0] old_func_id;
    wire [2:0] gate_input_count_MSOP, gate_input_count_MPOS, gate_input_count;
    wire [1:0] gate_type_MSOP, gate_type_MPOS, gate_type;
    wire [2:0] gate_id_MSOP, gate_id_MPOS, gate_id;
    wire control_valid_MSOP, control_valid_MPOS, control_valid;
    wire [$clog2(MODULE_COUNT):0] wire_input_id_MSOP, wire_input_id_MPOS, wire_input_id;
    reg control_reset;
    reg prev_btnC;
    wire true_ready, false_ready;
    assign gate_input_count = current_req ? gate_input_count_MPOS : gate_input_count_MSOP;
    assign gate_type = current_req ? gate_type_MPOS : gate_type_MSOP;
    assign gate_id = current_req ? gate_id_MPOS : gate_id_MSOP;
    assign control_valid = current_req ? control_valid_MPOS : control_valid_MSOP;
    assign wire_input_id = current_req ? wire_input_id_MPOS : wire_input_id_MSOP;
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    //////////////////////////////////////////////////////////////////////////////////    
    
    // SET THE PIXELS TO BE LIGHTED UP
    always @(posedge clk) begin
        set_oled_display;
        prev_btnC <= btnC;
        control_reset <= 1'b0;
        if ((old_func_id != function_id) || (btnC && !prev_btnC)) begin
            control_reset <= 1'b1;
            current_req <= btnC ? ~current_req : current_req;
        end
        old_func_id <= function_id;
    end
    
    //////////////////////////////////////////////////////////////////////////////////
    // WIRE MODULES
    //////////////////////////////////////////////////////////////////////////////////        

    wire_combined_3 #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
        )(
        .clk(clk),
        .reset(control_reset), 
        .x_index(x_index),
        .y_index(y_index),
        .input_id(control_valid ? wire_input_id : 6'd63),
        .wire_ready(wire_ready));

    //////////////////////////////////////////////////////////////////////////////////
    // GATE MODULES
    //////////////////////////////////////////////////////////////////////////////////       
    //*
    combined_gate_3 #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
        )(
        .clk(clk),
        .reset(control_reset),
        .x_index(x_index),
        .y_index(y_index),
        .input_count(control_valid ? gate_input_count : 3'd7),
        .gate_type(control_valid ? gate_type : 2'd0),
        .gate_id(control_valid ? gate_id : 3'd7),
        .wire_id(control_valid ? wire_input_id : 6'd63),
        .var_ready(var_ready),
        .gate_ready(gate_ready));
    //*/
    
    //////////////////////////////////////////////////////////////////////////////////
    // CONTROL MODULE
    ////////////////////////////////////////////////////////////////////////////////// 
    
    wire_gate_3_control_MSOP ctrl (
        .clk(clk),
        .reset(control_reset),
        .func_id(function_id),
        .wire_id(wire_input_id_MSOP),
        .gate_type(gate_type_MSOP),
        .gate_id(gate_id_MSOP),
        .input_count(gate_input_count_MSOP),
        .valid(control_valid_MSOP));
        
    wire_gate_3_control_MPOS ctrl2 (
        .clk(clk),
        .reset(control_reset),
        .func_id(function_id),
        .wire_id(wire_input_id_MPOS),
        .gate_type(gate_type_MPOS),
        .gate_id(gate_id_MPOS),
        .input_count(gate_input_count_MPOS),
        .valid(control_valid_MPOS));
    
    //////////////////////////////////////////////////////////////////////////////////
    // INVALID SCREEN MODULE
    ////////////////////////////////////////////////////////////////////////////////// 
    invalid_screen_generator #(
        .DISPLAY_WIDTH(96),
        .DISPLAY_HEIGHT(64)
        )(
        .x_addr((x_index < 96) ? x_index : 95),
        .y_addr((y_index < 64) ? y_index : 64),
        .draw(invalid_ready));
    
    TRUE_circuit #(
        .DISPLAY_WIDTH(96),
        .DISPLAY_HEIGHT(64)
        )(
        .x((x_index < 96) ? x_index : 95),
        .y((y_index < 64) ? y_index : 64),
        .T(true_ready));
    
    FALSE_circuit #(
        .DISPLAY_WIDTH(96),
        .DISPLAY_HEIGHT(64)
        )(
        .x((x_index < 96) ? x_index : 95),
        .y((y_index < 64) ? y_index : 64),
        .F(false_ready));
    //////////////////////////////////////////////////////////////////////////////////
    // LEGEND MODULE
    ////////////////////////////////////////////////////////////////////////////////// 
    legend_gen #(
        .DISPLAY_WIDTH(DISPLAY_WIDTH),
        .DISPLAY_HEIGHT(DISPLAY_HEIGHT)
        )(
        .x_addr(x_index),
        .y_addr(y_index - y_offset),
        .x(98),
        .y(2),
        .draw(legend_ready),
        .draw_black(legend_black_ready));
    
    //////////////////////////////////////////////////////////////////////////////////
    // HELPERS
    ////////////////////////////////////////////////////////////////////////////////// 
    parameter RED = 16'hf800;   // A
    parameter ORANGE = 16'hf300; // B
    parameter YELLOW = 16'hffe0;  // C
    parameter GREEN = 16'h07e0;    // ~A
    parameter BLUE = 16'h001f;  // ~B
    parameter PURPLE = 16'h701f;   // ~C
    parameter CYAN = 16'h07ff; // gate 0 outs
    parameter PINK = 16'hf81f; // gate 1 outs
    parameter DARK_GREEN = 16'h1a03; // gate 2 outs
    
    task set_oled_display;
    begin 
        if (function_id == 9'd500) begin
            oled_data_reg <= invalid_ready ? ORANGE : BLACK;
        end 
        else if (function_id == 8'd255) begin
            oled_data_reg <= true_ready ? GREEN : BLACK;
        end 
        else if (function_id == 8'd0) begin
            oled_data_reg <= false_ready ? RED : BLACK;
        end 
        else begin
            oled_data_reg <= legend_ready ? map_legend_color(x_index, (y_index - y_offset)) :
                             legend_black_ready ? BLACK :  
                             |wire_ready ? map_wire_color(wire_ready) :
                             (|var_ready || |gate_ready) ? WHITE : BLACK;
        end
    end
    endtask

    function [5:0] current_wire;
        input [MODULE_COUNT:0] wires;
        reg [5:0] i;
        begin
            current_wire = 50;
            for (i = 0; i < 50; i = i + 1) begin
                if (wires[i] == 1'b1 && current_wire == 50)
                    current_wire = i;
            end
        end
    endfunction
    
    function [15:0] map_wire_color;
        input [MODULE_COUNT:0] wires;
        reg [5:0] wire_id;
        begin
            wire_id = current_wire(wire_ready);
            case (wire_id)
                6'd0, 6'd6, 6'd12, 6'd18, 6'd24: map_wire_color = RED;
                6'd1, 6'd7, 6'd13, 6'd19, 6'd25: map_wire_color = ORANGE;
                6'd2, 6'd8, 6'd14, 6'd20, 6'd26: map_wire_color = YELLOW;
                6'd3, 6'd9, 6'd15, 6'd21, 6'd27: map_wire_color = GREEN;
                6'd4, 6'd10, 6'd16, 6'd22, 6'd28: map_wire_color = BLUE;
                6'd5, 6'd11, 6'd17, 6'd23, 6'd29: map_wire_color = PURPLE;
                6'd30, 6'd31, 6'd32, 6'd39, 6'd40, 6'd41: map_wire_color = CYAN;
                6'd33, 6'd34, 6'd35, 6'd42, 6'd43, 6'd44: map_wire_color = PINK;
                6'd36, 6'd37, 6'd38, 6'd45, 6'd46, 6'd47: map_wire_color = DARK_GREEN;
                default: map_wire_color = WHITE;
            endcase
        end
    endfunction
    
    function in_legend_box;
        input [13:0] current_x , current_y, x, y;
        begin
            in_legend_box = 
                ((current_x == x && current_y == y) ||
                (current_x == x && current_y == y + 1) ||
                (current_x == x && current_y == y + 2) ||
                (current_x == x + 1 && current_y == y) ||
                (current_x == x + 1 && current_y == y + 1) ||
                (current_x == x + 1 && current_y == y + 2));
        end
    endfunction
    
    function [15:0] map_legend_color;
        input [13:0] x;
        input [13:0] y;
        begin
            if (in_legend_box(x, y, 101, 15)) map_legend_color = RED;
            else if (in_legend_box(x, y, 113, 15)) map_legend_color = ORANGE;
            else if (in_legend_box(x, y, 125, 15)) map_legend_color = YELLOW;
            else if (in_legend_box(x, y, 101, 24)) map_legend_color = GREEN;
            else if (in_legend_box(x, y, 113, 24)) map_legend_color = BLUE;
            else if (in_legend_box(x, y, 125, 24)) map_legend_color = PURPLE;
            else map_legend_color = WHITE;
        end
    endfunction
        
endmodule
