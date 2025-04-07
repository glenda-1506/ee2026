`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 06:29:20 PM
// Design Name: 
// Module Name: new_keyboard
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


module keyboard_display(
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
    
    parameter A_X = 1;
    parameter A_Y = 1;
    parameter B_X = 22;
    parameter B_Y = 1;
    parameter C_X = 43;
    parameter C_Y = 1;
    parameter TILDA_X = 1;
    parameter TILDA_Y = 22;
    parameter OR_X = 22;
    parameter OR_Y = 22;
    parameter AND_X = 43;
    parameter AND_Y = 22;
    parameter LBRAC_X = 1;
    parameter LBRAC_Y = 43;
    parameter RBRAC_X = 22;
    parameter RBRAC_Y = 43;
    parameter DEL_X = 43;
    parameter DEL_Y = 43;
    parameter ENT_X = 75;
    parameter ENT_Y = 43;
    
    wire symbol_on_A;
    wire symbol_on_B;
    wire symbol_on_C;
    wire symbol_on_Tilda;
    wire symbol_on_And;
    wire symbol_on_Or;
    wire symbol_on_LBrac;
    wire symbol_on_RBrac;
    wire symbol_on_Delete;
    wire symbol_on_Enter;
    wire grid_on;
    
    reg btnL_prev, btnR_prev, btnU_prev, btnD_prev, btnC_prev;
    wire btnL_edge = btnL && !btnL_prev;
    wire btnR_edge = btnR && !btnR_prev;
    wire btnU_edge = btnU && !btnU_prev;
    wire btnD_edge = btnD && !btnD_prev;
    wire btnC_edge = btnC && !btnC_prev;
    
    parameter [6:0] GRID_X_0 = 1, GRID_X_1 = 22, GRID_X_2 = 43, GRID_X_3 = 75;
    parameter [5:0] GRID_Y_0 = 1, GRID_Y_1 = 22, GRID_Y_2 = 43, GRID_Y_3 = 43;
    
    reg [1:0] selected_x = 0;
    reg [1:0] selected_y = 0;
    
    reg [6:0] selected_x_pos;
    reg [5:0] selected_y_pos;
    
    reg [3:0] key_map [2:0][3:0];
    initial begin
        key_map[0][0] = 4'b0000; // A
        key_map[0][1] = 4'b0001; // B
        key_map[0][2] = 4'b0010; // C
        key_map[1][0] = 4'b0100; // ~
        key_map[1][1] = 4'b0101; // .
        key_map[1][2] = 4'b0110; // +
        key_map[2][0] = 4'b1000; // (
        key_map[2][1] = 4'b1001; // )
        key_map[2][2] = 4'b1010; // delete
        key_map[2][3] = 4'b1011; // enter
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
            2'd2: selected_y_pos = GRID_Y_2;
            2'd3: selected_y_pos = GRID_Y_3;
            default: selected_y_pos = 0;
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            selected_x <= 0;
            selected_y <= 0;
        end else begin
            if (btnL_edge) begin
                if (selected_x == 3 && selected_y == 2) 
                    selected_x <= 2;
                else if (selected_x > 0) 
                    selected_x <= selected_x - 1;
            end 
            
            else if (btnR_edge) begin
                if (selected_x == 2 && selected_y == 2) 
                    selected_x <= 3;
                else if (selected_x < 2) 
                    selected_x <= selected_x + 1;
            end 
            
            else if (btnU_edge && selected_y > 0) begin
                if (selected_x == 3 && selected_y == 2) begin
                    selected_x <= 2;
                    selected_y <= 1;
                end else begin
                    selected_y <= selected_y - 1;
                end
            end 
            
            else if (btnD_edge && selected_y < 2) begin
                selected_y <= selected_y + 1;
            end
    
            if (selected_x == 3 && selected_y != 2) 
                selected_x <= 2;
        end
    end
    
    wire selected_key = (x >= selected_x_pos && x < selected_x_pos + 20) &&
                        (y >= selected_y_pos && y < selected_y_pos + 20);
    
    always @(posedge clk) begin
        if (!reset) begin
            if (btnC_edge) begin
                key_value <= key_map[selected_y][selected_x];
                key_pressed <= 1;
            end else if (key_pressed) begin
                key_pressed <= 1;
            end else begin
                key_pressed <= 0;
            end     
        end else begin
            key_value <= 4'b1111;
        end
    end
    
    symbolA letterA (
        .x(x),
        .y(y),
        .sx(A_X),
        .sy(A_Y),
        .pixel_on(symbol_on_A)
    );
    
    symbolB letterB (
        .x(x),
        .y(y),
        .sx(B_X),
        .sy(B_Y),
        .pixel_on(symbol_on_B)
    );
    
    symbolC letterC (
        .x(x),
        .y(y),
        .sx(C_X),
        .sy(C_Y),
        .pixel_on(symbol_on_C)
    );
    
    symbolTilda letterTilda (
        .x(x),
        .y(y),
        .sx(TILDA_X),
        .sy(TILDA_Y),
        .pixel_on(symbol_on_Tilda)
    );
    
    symbolAnd letterAnd (
        .x(x),
        .y(y),
        .sx(AND_X),
        .sy(AND_Y),
        .pixel_on(symbol_on_And)
    );
    
    symbolOr letterOr (
        .x(x),
        .y(y),
        .sx(OR_X),
        .sy(OR_Y),
        .pixel_on(symbol_on_Or)
    );
    
    symbolLBrac letterLBrac (
        .x(x),
        .y(y),
        .sx(LBRAC_X),
        .sy(LBRAC_Y),
        .pixel_on(symbol_on_LBrac)
    );
    
    symbolRBrac letterRBrac (
        .x(x),
        .y(y),
        .sx(RBRAC_X),
        .sy(RBRAC_Y),
        .pixel_on(symbol_on_RBrac)
    );
    
    symbolDel letterDel (
        .x(x),
        .y(y),
        .sx(DEL_X),
        .sy(DEL_Y),
        .pixel_on(symbol_on_Delete)
    );
    
    symbolEnt letterEnt (
        .x(x),
        .y(y),
        .sx(ENT_X),
        .sy(ENT_Y),
        .pixel_on(symbol_on_Enter)
    );
    
    grid_display grid (
        .x(x),
        .y(y),
        .grid(grid_on)
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            pixel_data <= BLACK;
        else begin
            if (symbol_on_A || symbol_on_B || symbol_on_C || symbol_on_Tilda || symbol_on_And || symbol_on_Or || symbol_on_LBrac || symbol_on_RBrac || symbol_on_Delete || symbol_on_Enter)
                pixel_data <= (selected_key) ? GREEN : WHITE;
            else if (grid_on)
                pixel_data <= WHITE;
            else
                pixel_data <= BLACK;
        end
    end

endmodule
    
