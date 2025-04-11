`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2025 10:00:07 PM
// Design Name: 
// Module Name: switches_screen
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


module switches_screen(
    input clk,
    input [6:0] x,
    input [5:0] y,
    output reg [15:0] oled_data
    );
    
    parameter WHITE  = 16'hFFFF;
    parameter BLACK  = 16'h0000;
    parameter CYAN = 16'h07ff; 
    
    parameter S1_X = 3;
    parameter S1_Y = 15;    
    parameter W1_X = 12;
    parameter W1_Y = 15;    
    parameter ZERO_X = 24;
    parameter ZERO_Y = 15;     
    parameter DOT1_X = 33;
    parameter DOT1_Y = 16; 
    parameter I_X = 45;
    parameter I_Y = 15;    
    parameter N_X = 54;
    parameter N_Y = 15;    
    parameter P1_X = 63;
    parameter P1_Y = 15;    
    parameter U1_X = 72;
    parameter U1_Y = 15;    
    parameter T1_X = 81;
    parameter T1_Y = 15;   
    
    parameter S2_X = 3;
    parameter S2_Y = 39;    
    parameter W2_X = 12;
    parameter W2_Y = 39;    
    parameter TWO_X = 24;
    parameter TWO_Y = 39;    
    parameter DOT2_X = 33;
    parameter DOT2_Y = 40;    
    parameter R_X = 45;
    parameter R_Y = 39;    
    parameter E1_X = 54;
    parameter E1_Y = 39;    
    parameter S3_X = 63;
    parameter S3_Y = 39;    
    parameter E2_X = 72;
    parameter E2_Y = 39;    
    parameter T2_X = 81;
    parameter T2_Y = 39;    
    
    parameter S4_X = 3;
    parameter S4_Y = 27;    
    parameter W3_X = 12;
    parameter W3_Y = 27;    
    parameter ONE_X = 24;
    parameter ONE_Y = 27;    
    parameter DOT3_X = 33;
    parameter DOT3_Y = 28;    
    parameter O_X = 40;
    parameter O_Y = 27;    
    parameter U2_X = 49;
    parameter U2_Y = 27;    
    parameter T3_X = 58;
    parameter T3_Y = 27;    
    parameter P2_X = 67;
    parameter P2_Y = 27;    
    parameter U3_X = 76;
    parameter U3_Y = 27;    
    parameter T4_X = 85;
    parameter T4_Y = 27;
    
    wire symbol_on_S1;
    wire symbol_on_W1;
    wire symbol_on_ZERO;
    wire symbol_on_DOT1;
    wire symbol_on_I;
    wire symbol_on_N;
    wire symbol_on_P1;
    wire symbol_on_U1;
    wire symbol_on_T1;
    
    wire symbol_on_S2;
    wire symbol_on_W2;
    wire symbol_on_TWO;
    wire symbol_on_DOT2;
    wire symbol_on_R;
    wire symbol_on_E1;
    wire symbol_on_S3;
    wire symbol_on_E2;
    wire symbol_on_T2;
    
    wire symbol_on_S4;
    wire symbol_on_W3;
    wire symbol_on_ONE;
    wire symbol_on_DOT3;
    wire symbol_on_O;
    wire symbol_on_U2;
    wire symbol_on_T3;
    wire symbol_on_P2;
    wire symbol_on_U3;
    wire symbol_on_T4;
    
    S_switches S1 (
        .x(x),
        .y(y),
        .sx(S1_X),
        .sy(S1_Y),
        .pixel_on(symbol_on_S1)
    );
    
    S_switches S2 (
        .x(x),
        .y(y),
        .sx(S2_X),
        .sy(S2_Y),
        .pixel_on(symbol_on_S2)
    );
    
    S_switches S3 (
        .x(x),
        .y(y),
        .sx(S3_X),
        .sy(S3_Y),
        .pixel_on(symbol_on_S3)
    );
    
    S_switches S4 (
        .x(x),
        .y(y),
        .sx(S4_X),
        .sy(S4_Y),
        .pixel_on(symbol_on_S4)
    );
    
    W_switches W1 (
        .x(x),
        .y(y),
        .sx(W1_X),
        .sy(W1_Y),
        .pixel_on(symbol_on_W1)
    );
    
    W_switches W2 (
        .x(x),
        .y(y),
        .sx(W2_X),
        .sy(W2_Y),
        .pixel_on(symbol_on_W2)
    );
    
    W_switches W3 (
        .x(x),
        .y(y),
        .sx(W3_X),
        .sy(W3_Y),
        .pixel_on(symbol_on_W3)
    );
    
    ONE_switches ONE (
        .x(x),
        .y(y),
        .sx(ONE_X),
        .sy(ONE_Y),
        .pixel_on(symbol_on_ONE)
    );
    
    ZERO_switches ZERO (
        .x(x),
        .y(y),
        .sx(ZERO_X),
        .sy(ZERO_Y),
        .pixel_on(symbol_on_ZERO)
    );
    
    I_switches I (
        .x(x),
        .y(y),
        .sx(I_X),
        .sy(I_Y),
        .pixel_on(symbol_on_I)
    );
    
    N_switches N (
        .x(x),
        .y(y),
        .sx(N_X),
        .sy(N_Y),
        .pixel_on(symbol_on_N)
    );
    
    P_switches P1 (
        .x(x),
        .y(y),
        .sx(P1_X),
        .sy(P1_Y),
        .pixel_on(symbol_on_P1)
    );
    
    P_switches P2 (
        .x(x),
        .y(y),
        .sx(P2_X),
        .sy(P2_Y),
        .pixel_on(symbol_on_P2)
    );
    
    T_switches T1 (
        .x(x),
        .y(y),
        .sx(T1_X),
        .sy(T1_Y),
        .pixel_on(symbol_on_T1)
    );
    
    T_switches T2 (
        .x(x),
        .y(y),
        .sx(T2_X),
        .sy(T2_Y),
        .pixel_on(symbol_on_T2)
    );
    
    T_switches T3 (
        .x(x),
        .y(y),
        .sx(T3_X),
        .sy(T3_Y),
        .pixel_on(symbol_on_T3)
    );
    
    T_switches T4 (
        .x(x),
        .y(y),
        .sx(T4_X),
        .sy(T4_Y),
        .pixel_on(symbol_on_T4)
    );
    
    O_switches O (
        .x(x),
        .y(y),
        .sx(O_X),
        .sy(O_Y),
        .pixel_on(symbol_on_O)
    );
    
    U_switches U1 (
        .x(x),
        .y(y),
        .sx(U1_X),
        .sy(U1_Y),
        .pixel_on(symbol_on_U1)
    );
    
    U_switches U2 (
        .x(x),
        .y(y),
        .sx(U2_X),
        .sy(U2_Y),
        .pixel_on(symbol_on_U2)
    );
    
    U_switches U3 (
        .x(x),
        .y(y),
        .sx(U3_X),
        .sy(U3_Y),
        .pixel_on(symbol_on_U3)
    );
    
    DOT_switches DOT1 (
        .x(x),
        .y(y),
        .sx(DOT1_X),
        .sy(DOT1_Y),
        .pixel_on(symbol_on_DOT1)
    );
    
    DOT_switches DOT2 (
        .x(x),
        .y(y),
        .sx(DOT2_X),
        .sy(DOT2_Y),
        .pixel_on(symbol_on_DOT2)
    );
    
    DOT_switches DOT3 (
        .x(x),
        .y(y),
        .sx(DOT3_X),
        .sy(DOT3_Y),
        .pixel_on(symbol_on_DOT3)
    );
    
    R_switches R (
        .x(x),
        .y(y),
        .sx(R_X),
        .sy(R_Y),
        .pixel_on(symbol_on_R)
    );
    
    E_switches E1 (
        .x(x),
        .y(y),
        .sx(E1_X),
        .sy(E1_Y),
        .pixel_on(symbol_on_E1)
    );
    
    E_switches E2 (
        .x(x),
        .y(y),
        .sx(E2_X),
        .sy(E2_Y),
        .pixel_on(symbol_on_E2)
    );
    
    TWO_switches TWO (
        .x(x),
        .y(y),
        .sx(TWO_X),
        .sy(TWO_Y),
        .pixel_on(symbol_on_TWO)
    );
    
    always @(posedge clk) begin
        if (symbol_on_S1 || symbol_on_W1 || symbol_on_ZERO || symbol_on_DOT1 || symbol_on_I || symbol_on_N || symbol_on_P1 || symbol_on_U1 || symbol_on_T1 ||
          symbol_on_S4 || symbol_on_W3 || symbol_on_ONE || symbol_on_DOT3 || symbol_on_O || symbol_on_U2 || symbol_on_T3 || symbol_on_P2 || symbol_on_U3 || symbol_on_T4)
            oled_data <= CYAN;
        else if (symbol_on_S2 || symbol_on_W2 || symbol_on_TWO || symbol_on_DOT2 || symbol_on_R || symbol_on_E1 || symbol_on_S3 || symbol_on_E2 || symbol_on_T2)
            oled_data <= WHITE; 
        else
            oled_data <= BLACK;
    end
    
endmodule
