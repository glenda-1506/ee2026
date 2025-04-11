`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 02:36:28 PM
// Design Name: 
// Module Name: keyboard_display_no_brac
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


module keyboard_display_no_brac(
    input clk,
    input reset,
    input [6:0] x,
    input [5:0] y,
    input btnU, btnD, btnL, btnR, btnC,
    output reg [15:0] pixel_data,
    output reg [3:0] key_value,
    output reg key_pressed
    );
    
    parameter WHITE  = 16'hFFFF;
    parameter BLACK  = 16'h0000;
    parameter GREEN  = 16'h07E0;
    
    parameter A_X = 3;
    parameter A_Y = 9;
    parameter B_X = 26;
    parameter B_Y = 9;
    parameter C_X = 49;
    parameter C_Y = 9;
    parameter DEL_X = 72;
    parameter DEL_Y = 9;
    parameter TILDA_X = 3;
    parameter TILDA_Y = 32;
    parameter OR_X = 26;
    parameter OR_Y = 32;
    parameter AND_X = 49;
    parameter AND_Y = 32;
    parameter ENT_X = 72;
    parameter ENT_Y = 32;
    
    wire symbol_on_A;
    wire symbol_on_B;
    wire symbol_on_C;
    wire symbol_on_Tilda;
    wire symbol_on_And;
    wire symbol_on_Or;
    wire symbol_on_Delete;
    wire symbol_on_Enter;
    wire grid_on;
    
    reg btnL_prev, btnR_prev, btnU_prev, btnD_prev, btnC_prev;
    wire btnL_edge = btnL && !btnL_prev;
    wire btnR_edge = btnR && !btnR_prev;
    wire btnU_edge = btnU && !btnU_prev;
    wire btnD_edge = btnD && !btnD_prev;
    wire btnC_edge = btnC && !btnC_prev;
    
    parameter [6:0] GRID_X_0 = 3, GRID_X_1 = 26, GRID_X_2 = 49, GRID_X_3 = 72;
    parameter [5:0] GRID_Y_0 = 9, GRID_Y_1 = 32;
    
    reg [1:0] selected_x = 0;
    reg [1:0] selected_y = 0;
    
    reg [6:0] selected_x_pos;
    reg [5:0] selected_y_pos;
    
    reg [3:0] key_map [1:0][3:0]; // [y][x]
    initial begin
        key_map[0][0] = 4'b0000; // A
        key_map[0][1] = 4'b0001; // B
        key_map[0][2] = 4'b0010; // C
        key_map[0][3] = 4'b1010; // delete
        key_map[1][0] = 4'b0100; // ~
        key_map[1][1] = 4'b0101; // .
        key_map[1][2] = 4'b0110; // +
        key_map[1][3] = 4'b1011; // enter
    end
    
    always @(posedge clk) begin
        btnL_prev <= btnL;
        btnR_prev <= btnR;
        btnU_prev <= btnU;
        btnD_prev <= btnD;
    end

    always @(*) begin
        case (selected_x)
            2'd0: selected_x_pos = GRID_X_0;
            2'd1: selected_x_pos = GRID_X_1;
            2'd2: selected_x_pos = GRID_X_2;
            2'd3: selected_x_pos = GRID_X_3;
            default: selected_x_pos = 0;
        endcase
    end

    always @(*) begin
        case (selected_y)
            2'd0: selected_y_pos = GRID_Y_0;
            2'd1: selected_y_pos = GRID_Y_1;
            default: selected_y_pos = 0;
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            selected_x <= 0;
            selected_y <= 0;
        end else begin
            if (btnL_edge && selected_x > 0) begin
                selected_x <= selected_x - 1;
            end else if (btnR_edge && selected_x < 3) begin
                selected_x <= selected_x + 1;
            end else if (btnU_edge && selected_y > 0) begin
                selected_y <= selected_y - 1;
            end else if (btnD_edge && selected_y < 1) begin
                selected_y <= selected_y + 1;
            end
        end
    end
    
    wire selected_key = (x >= selected_x_pos && x < selected_x_pos + 22) &&
                        (y >= selected_y_pos && y < selected_y_pos + 22);

    always @(posedge clk) begin
        if (reset) begin
            key_value   <= 4'b1111;
            key_pressed <= 0;
        end else begin
            if (btnC_edge) begin
                key_value   <= key_map[selected_y][selected_x];
                key_pressed <= 1;
            end else begin
                key_pressed <= 0;
            end
        end
    end
    
    A_nobrac letterA (
        .x(x),
        .y(y),
        .sx(A_X),
        .sy(A_Y),
        .pixel_on(symbol_on_A)
    );
    
    B_nobrac letterB (
        .x(x),
        .y(y),
        .sx(B_X),
        .sy(B_Y),
        .pixel_on(symbol_on_B)
    );
    
    C_nobrac letterC (
        .x(x),
        .y(y),
        .sx(C_X),
        .sy(C_Y),
        .pixel_on(symbol_on_C)
    );
    
    NOT_nobrac letterTilda (
        .x(x),
        .y(y),
        .sx(TILDA_X),
        .sy(TILDA_Y),
        .pixel_on(symbol_on_Tilda)
    );
    
    AND_nobrac letterAnd (
        .x(x),
        .y(y),
        .sx(AND_X),
        .sy(AND_Y),
        .pixel_on(symbol_on_And)
    );
    
    OR_nobrac letterOr (
        .x(x),
        .y(y),
        .sx(OR_X),
        .sy(OR_Y),
        .pixel_on(symbol_on_Or)
    );
    
    DEL_nobrac letterDel (
        .x(x),
        .y(y),
        .sx(DEL_X),
        .sy(DEL_Y),
        .pixel_on(symbol_on_Delete)
    );
    
    ENT_nobrac letterEnt (
        .x(x),
        .y(y),
        .sx(ENT_X),
        .sy(ENT_Y),
        .pixel_on(symbol_on_Enter)
    );
    
    grid_nobrac grid (
        .x(x),
        .y(y),
        .grid(grid_on)
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            pixel_data <= BLACK;
        else begin
            if (symbol_on_A || symbol_on_B || symbol_on_C || symbol_on_Tilda || symbol_on_And || symbol_on_Or || symbol_on_Delete || symbol_on_Enter)
                pixel_data <= (selected_key) ? GREEN : WHITE;
            else if (grid_on)
                pixel_data <= WHITE;
            else
                pixel_data <= BLACK;
        end
    end
endmodule
