`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  Si Thu Lin Aung
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input sw,
    output [7:0] JXADC
    );
    
    wire clk_6p25;
    wire [12:0] pixel_index;
    wire fb;
    reg [15:0] oled_data = (sw == 1) ? 16'b11111_000000_00000 : 16'h07E0;
    
    flexible_clock_divider clock_6p25 (clk, clk_6p25);
    Oled_Display display (
        .clk(clk_6p25), 
        .reset(0), 
        .frame_begin(fb), 
        .sending_pixels(), 
        .sample_pixel(), 
        .pixel_index(pixel_index), 
        .pixel_data(oled_data), 
        .cs(JXADC[0]), 
        .sdin(JXADC[1]), 
        .sclk(JXADC[3]), 
        .d_cn(JXADC[4]), 
        .resn(JXADC[5]), 
        .vccen(JXADC[6]), 
        .pmoden(JXADC[7]));
        
endmodule