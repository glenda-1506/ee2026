`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 01:46:19 PM
// Design Name: 
// Module Name: wire_combined_3
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

module wire_combined_3#(
    parameter DISPLAY_WIDTH = 96,
    parameter DISPLAY_HEIGHT = 64,
    parameter TOTAL_MODULES = 50,
    parameter X_BIT = $clog2(DISPLAY_WIDTH) - 1,
    parameter Y_BIT = $clog2(DISPLAY_HEIGHT) - 1,
    parameter MODULE_COUNT_BIT = $clog2(TOTAL_MODULES)
    )(
    input clk,
    input reset,
    input [X_BIT:0] x_index,
    input [Y_BIT:0] y_index,
    input [MODULE_COUNT_BIT:0] input_id,
    output [TOTAL_MODULES-1:0] wire_ready
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // ALL WIRE MODULES
    //////////////////////////////////////////////////////////////////////////////////
    
    // Horizontal inputs to gate 0 (in order of A, B, C, ~A, ~B, ~C)
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 70)  
            (clk, reset, (input_id == 6'd0), x_index, y_index, 4, 25, wire_ready[0]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 49)  
            (clk, reset, (input_id == 6'd1), x_index, y_index, 25, 27, wire_ready[1]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 28)  
            (clk, reset, (input_id == 6'd2), x_index, y_index, 46, 29, wire_ready[2]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 56)  
            (clk, reset, (input_id == 6'd3), x_index, y_index, 18, 25, wire_ready[3]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 35)  
            (clk, reset, (input_id == 6'd4), x_index, y_index, 39, 27, wire_ready[4]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 14)  
            (clk, reset, (input_id == 6'd5), x_index, y_index, 60, 29, wire_ready[5]);

    // Horizontal inputs to gate 1 (in order of A, B, C, ~A, ~B, ~C)   
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 70)  
            (clk, reset, (input_id == 6'd6), x_index, y_index, 4, 53, wire_ready[6]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 49)  
            (clk, reset, (input_id == 6'd7), x_index, y_index, 25, 55, wire_ready[7]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 28)  
            (clk, reset, (input_id == 6'd8), x_index, y_index, 46, 57, wire_ready[8]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 56)  
            (clk, reset, (input_id == 6'd9), x_index, y_index, 18, 53, wire_ready[9]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 35)  
            (clk, reset, (input_id == 6'd10), x_index, y_index, 39, 55, wire_ready[10]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 14)  
            (clk, reset, (input_id == 6'd11), x_index, y_index, 60, 57, wire_ready[11]);

    // Horizontal inputs to gate 2 (in order of A, B, C, ~A, ~B, ~C)   
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 70)  
            (clk, reset, (input_id == 6'd12), x_index, y_index, 4, 81, wire_ready[12]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 49)  
            (clk, reset, (input_id == 6'd13), x_index, y_index, 25, 83, wire_ready[13]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 28)  
            (clk, reset, (input_id == 6'd14), x_index, y_index, 46, 85, wire_ready[14]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 56)  
            (clk, reset, (input_id == 6'd15), x_index, y_index, 18, 81, wire_ready[15]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 35)  
            (clk, reset, (input_id == 6'd16), x_index, y_index, 39, 83, wire_ready[16]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 14)  
            (clk, reset, (input_id == 6'd17), x_index, y_index, 60, 85, wire_ready[17]);
    
    // Horizontal inputs to gate 3 (in order of A, B, C, ~A, ~B, ~C)  
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 94)  
            (clk, reset, (input_id == 6'd18), x_index, y_index, 4, 39, wire_ready[18]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 73)  
            (clk, reset, (input_id == 6'd19), x_index, y_index, 25, 41, wire_ready[19]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 52)  
            (clk, reset, (input_id == 6'd20), x_index, y_index, 46, 43, wire_ready[20]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 80)  
            (clk, reset, (input_id == 6'd21), x_index, y_index, 18, 39, wire_ready[21]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 59)  
            (clk, reset, (input_id == 6'd22), x_index, y_index, 39, 41, wire_ready[22]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 38)  
            (clk, reset, (input_id == 6'd23), x_index, y_index, 60, 43, wire_ready[23]);
 
    
    // Horizontal inputs to gate 4 (in order of A, B, C, ~A, ~B, ~C)  
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 94)  
            (clk, reset, (input_id == 6'd24), x_index, y_index, 4, 39, wire_ready[24]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 73)  
            (clk, reset, (input_id == 6'd25), x_index, y_index, 25, 41, wire_ready[25]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 52)  
            (clk, reset, (input_id == 6'd26), x_index, y_index, 46, 43, wire_ready[26]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 80)  
            (clk, reset, (input_id == 6'd27), x_index, y_index, 18, 39, wire_ready[27]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 59)  
            (clk, reset, (input_id == 6'd28), x_index, y_index, 39, 41, wire_ready[28]);
    h_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 38)  
            (clk, reset, (input_id == 6'd29), x_index, y_index, 60, 43, wire_ready[29]); 
    
    // Wires from gate 0 to gate 3 (middle, top, bottom inputs)
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 14, 8)
            (clk, reset, (input_id == 6'd30), x_index, y_index, 85, 27, wire_ready[30]); 
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 12, 8)
            (clk, reset, (input_id == 6'd31), x_index, y_index, 85, 27, wire_ready[31]); 
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 16, 8)
            (clk, reset, (input_id == 6'd32), x_index, y_index, 85, 27, wire_ready[32]); 
    
    // Wires from gate 1 to gate 3 (middle, top, bottom inputs)
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 14, 8)
            (clk, reset, (input_id == 6'd33), x_index, y_index, 85, 55, wire_ready[33]); 
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 16, 8)
            (clk, reset, (input_id == 6'd34), x_index, y_index, 85, 55, wire_ready[34]); 
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 12, 8)
            (clk, reset, (input_id == 6'd35), x_index, y_index, 85, 55, wire_ready[35]); 
    
    // Wires from gate 2 to gate 3 (middle, top, bottom inputs)
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 42, 8)
            (clk, reset, (input_id == 6'd36), x_index, y_index, 85, 83, wire_ready[36]); 
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 44, 8)
            (clk, reset, (input_id == 6'd37), x_index, y_index, 85, 83,  wire_ready[37]); 
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 40, 8)
            (clk, reset, (input_id == 6'd38), x_index, y_index, 85, 83, wire_ready[38]); 
    
    // Wires from gate 0 to gate 4 (middle, top, bottom inputs)
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 42, 8)
            (clk, reset, (input_id == 6'd39), x_index, y_index, 85, 27, wire_ready[39]); 
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 40, 8)
            (clk, reset, (input_id == 6'd40), x_index, y_index, 85, 27, wire_ready[40]); 
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 44, 8)
            (clk, reset, (input_id == 6'd41), x_index, y_index, 85, 27, wire_ready[41]); 
    
    // Wires from gate 1 to gate 4 (middle, top, bottom inputs)
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 14, 8)
            (clk, reset, (input_id == 6'd42), x_index, y_index, 85, 55, wire_ready[42]); 
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 12, 8)
            (clk, reset, (input_id == 6'd43), x_index, y_index, 85, 55, wire_ready[43]); 
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 16, 8)
            (clk, reset, (input_id == 6'd44), x_index, y_index, 85, 55, wire_ready[44]); 
    
    // Wires from gate 2 to gate 4 (middle, top, bottom inputs)
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 14, 8)
            (clk, reset, (input_id == 6'd45), x_index, y_index, 85, 83, wire_ready[45]); 
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 16, 8)
            (clk, reset, (input_id == 6'd46), x_index, y_index, 85, 83,  wire_ready[46]); 
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 12, 8)
            (clk, reset, (input_id == 6'd47), x_index, y_index, 85, 83, wire_ready[47]); 
    
    // Wire from gate 3 to gate 5
    z_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 12, 8)
            (clk, reset, (input_id == 6'd48), x_index, y_index, 109, 41, wire_ready[48]); 
    
    
    // Wire from gate 4 to gate 5   
    s_wire #(DISPLAY_WIDTH, DISPLAY_HEIGHT, 5, 12, 8)
            (clk, reset, (input_id == 6'd49), x_index, y_index, 109, 69, wire_ready[49]);  

endmodule
