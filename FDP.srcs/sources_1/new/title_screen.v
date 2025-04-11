`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 06:46:32 PM
// Design Name: 
// Module Name: title_screen
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


module title_screen(
    input clk,
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] oled_data
    );
    
    parameter WHITE  = 16'hFFFF;
    parameter BLACK  = 16'h0000;
    parameter CYAN = 16'h07ff; 
    
    parameter E1_X = 79;
    parameter E1_Y = 39;
    parameter E2_X = 64;
    parameter E2_Y = 39;
    parameter TWO1_X = 49;
    parameter TWO1_Y = 39;
    parameter ZERO_X = 34;
    parameter ZERO_Y = 39;
    parameter TWO2_X = 19;
    parameter TWO2_Y = 39;
    parameter SIX_X = 4;
    parameter SIX_Y = 39;
    
    parameter C1_X = 79;
    parameter C1_Y = 24;
    parameter I1_X = 67;
    parameter I1_Y = 24;
    parameter R1_X = 55;
    parameter R1_Y = 24;
    parameter C2_X = 43;
    parameter C2_Y = 24;
    parameter U1_X = 31;
    parameter U1_Y = 24;
    parameter I2_X = 19;
    parameter I2_Y = 24;
    parameter T_X = 7;
    parameter T_Y = 24;
    
    parameter B_X = 79;
    parameter B_Y = 12;
    parameter U2_X = 67;
    parameter U2_Y = 12;
    parameter I3_X = 55;
    parameter I3_Y = 12;
    parameter L_X = 43;
    parameter L_Y = 12;
    parameter D_X = 31;
    parameter D_Y = 12;
    parameter E_X = 19;
    parameter E_Y = 12;
    parameter R2_X = 7;
    parameter R2_Y = 12;
            
    wire symbol_on_E1;
    wire symbol_on_E2;
    wire symbol_on_TWO1;
    wire symbol_on_ZERO;
    wire symbol_on_TWO2;
    wire symbol_on_SIX;
    
    wire symbol_on_C1;
    wire symbol_on_I1;
    wire symbol_on_R1;
    wire symbol_on_C2;
    wire symbol_on_U1;
    wire symbol_on_I2;
    wire symbol_on_T;
    
    wire symbol_on_B;
    wire symbol_on_U2;
    wire symbol_on_I3;
    wire symbol_on_L;
    wire symbol_on_D;
    wire symbol_on_E;
    wire symbol_on_R2;
    
    E_title E1 (
        .x(x),
        .y(y),
        .sx(E1_X),
        .sy(E1_Y),
        .pixel_on(symbol_on_E1)
    );
    
    E_title E2 (
        .x(x),
        .y(y),
        .sx(E2_X),
        .sy(E2_Y),
        .pixel_on(symbol_on_E2)
    );
    
    two_title TWO1 (
        .x(x),
        .y(y),
        .sx(TWO1_X),
        .sy(TWO1_Y),
        .pixel_on(symbol_on_TWO1)
    );
    
    zero_title ZERO1 (
        .x(x),
        .y(y),
        .sx(ZERO_X),
        .sy(ZERO_Y),
        .pixel_on(symbol_on_ZERO)
    );
    
    two_title TWO2 (
        .x(x),
        .y(y),
        .sx(TWO2_X),
        .sy(TWO2_Y),
        .pixel_on(symbol_on_TWO2)
    );
    
    six_title SIX (
        .x(x),
        .y(y),
        .sx(SIX_X),
        .sy(SIX_Y),
        .pixel_on(symbol_on_SIX)
    );
    
    C_title C1 (
        .x(x),
        .y(y),
        .sx(C1_X),
        .sy(C1_Y),
        .pixel_on(symbol_on_C1)
    );
    
    I_title I1 (
        .x(x),
        .y(y),
        .sx(I1_X),
        .sy(I1_Y),
        .pixel_on(symbol_on_I1)
    );
    
    R_title R1 (
        .x(x),
        .y(y),
        .sx(R1_X),
        .sy(R1_Y),
        .pixel_on(symbol_on_R1)
    );
    
    C_title C2 (
        .x(x),
        .y(y),
        .sx(C2_X),
        .sy(C2_Y),
        .pixel_on(symbol_on_C2)
    );
    
    U_title U1 (
        .x(x),
        .y(y),
        .sx(U1_X),
        .sy(U1_Y),
        .pixel_on(symbol_on_U1)
    );
    
    I_title I2 (
        .x(x),
        .y(y),
        .sx(I2_X),
        .sy(I2_Y),
        .pixel_on(symbol_on_I2)
    );
    
    T_title T (
        .x(x),
        .y(y),
        .sx(T_X),
        .sy(T_Y),
        .pixel_on(symbol_on_T)
    );
    
    B_title B (
        .x(x),
        .y(y),
        .sx(B_X),
        .sy(B_Y),
        .pixel_on(symbol_on_B)
    );
    
    U_title U2 (
        .x(x),
        .y(y),
        .sx(U2_X),
        .sy(U2_Y),
        .pixel_on(symbol_on_U2)
    );
    
    I_title I3 (
        .x(x),
        .y(y),
        .sx(I3_X),
        .sy(I3_Y),
        .pixel_on(symbol_on_I3)
    );
    
    L_title L (
        .x(x),
        .y(y),
        .sx(L_X),
        .sy(L_Y),
        .pixel_on(symbol_on_L)
    );
    
    D_title D (
        .x(x),
        .y(y),
        .sx(D_X),
        .sy(D_Y),
        .pixel_on(symbol_on_D)
    );
    
    E1_title E (
        .x(x),
        .y(y),
        .sx(E_X),
        .sy(E_Y),
        .pixel_on(symbol_on_E)
    );
    
    R_title R2 (
        .x(x),
        .y(y),
        .sx(R2_X),
        .sy(R2_Y),
        .pixel_on(symbol_on_R2)
    );
    
    always @(posedge clk) begin
        if (symbol_on_E1 || symbol_on_E2 || symbol_on_TWO1 || symbol_on_ZERO || symbol_on_TWO2 || symbol_on_SIX)
            oled_data <= CYAN;
        else if (symbol_on_C1 || symbol_on_I1 || symbol_on_R1 || symbol_on_C2 || symbol_on_U1 || symbol_on_I2 || symbol_on_T || 
          symbol_on_B || symbol_on_U2 || symbol_on_I3 || symbol_on_L || symbol_on_D || symbol_on_E || symbol_on_R2)
            oled_data <= WHITE;
        else 
            oled_data <= BLACK;
    end
    
endmodule
