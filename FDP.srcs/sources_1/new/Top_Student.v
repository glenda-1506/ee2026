`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//
//  FILL IN THE FOLLOWING INFORMATION:
//
//  STUDENT A NAME:  Si Thu Lin Aung
//  STUDENT B NAME:  Joe Tien You
//  STUDENT C NAME:  Liang Xuanyin Glenda
//  STUDENT D NAME:  Goh Aik Haw
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input [15:0] sw,
    input btnU, btnD, btnL, btnR, btnC,
    output [7:0] JA, JB,
    output [15:0] led,
    output [7:0] seg,     
    output [3:0] an
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameter and modules
    //////////////////////////////////////////////////////////////////////////////////
            
    // Set parameters
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF;
    parameter KEY_A      = 4'b0000;
    parameter KEY_B      = 4'b0001;
    parameter KEY_C      = 4'b0010;
    parameter KEY_NOT    = 4'b0100;
    parameter KEY_OR     = 4'b0101;
    parameter KEY_AND    = 4'b0110;
    parameter KEY_LBRAC  = 4'b1000;
    parameter KEY_RBRAC  = 4'b1001;
    parameter KEY_DELETE = 4'b1010;
    parameter KEY_ENTER  = 4'b1011;
    
    // Generate required wires and regs
    reg [15:0] oled_data_right_reg = BLACK; 
    reg [15:0] oled_data_left_reg = BLACK; 
    wire [15:0] oled_data_right = oled_data_right_reg;
    wire [15:0] oled_data_left = oled_data_left_reg;
    wire [1:0] fb;
    wire [12:0] pixel_index_right;
    wire [12:0] pixel_index_left;
    wire [15:0] oled_data_A;
    wire [15:0] oled_data_B;
    wire [15:0] oled_data_C;
    wire [15:0] oled_data_D;
    wire clk_6p25M;
    wire clk_25M;
    wire [1:0] CURRENT_SCREEN = sw[1:0];
    wire [3:0] selected_key;
    wire key_pressed;
    
    // Generate clock signals
    clock clk6p25 (clk, 7, clk_6p25M);
    clock clk25 (clk, 1, clk_25M);
    
    // Instantiate OLED
    Oled_Display oled_right (
        .clk(clk_6p25M), 
        .reset(0), 
        .frame_begin(fb[0]), 
        .sending_pixels(), 
        .sample_pixel(), 
        .pixel_index(pixel_index_right), 
        .pixel_data(oled_data_right), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]), 
        .pmoden(JB[7]));
    
    Oled_Display oled_left (
        .clk(clk_6p25M), 
        .reset(0), 
        .frame_begin(fb[1]), 
        .sending_pixels(), 
        .sample_pixel(), 
        .pixel_index(pixel_index_left), 
        .pixel_data(oled_data_left), 
        .cs(JA[0]), 
        .sdin(JA[1]), 
        .sclk(JA[3]), 
        .d_cn(JA[4]), 
        .resn(JA[5]), 
        .vccen(JA[6]), 
        .pmoden(JA[7]));
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    ////////////////////////////////////////////////////////////////////////////////// 
    always @(posedge clk_25M) begin
        case (CURRENT_SCREEN)
            2'b01: begin
                oled_data_right_reg <= oled_data_A; // c2
                oled_data_left_reg <= oled_data_D; // Aik Haw
            end
            2'b10: begin
                oled_data_right_reg <= oled_data_C; // Glenda
                oled_data_left_reg <= oled_data_B; // Louis
            end
        endcase
    end
    
    // Generate Individual Tasks
    TASK_A task_a (clk, pixel_index_right, sw, !CURRENT_SCREEN[0], btnU, btnD, btnL, btnR, oled_data_A);
    TASK_B task_b (clk, pixel_index_left, sw, !CURRENT_SCREEN[1], oled_data_B);    
    TASK_C task_c (clk, pixel_index_right, !CURRENT_SCREEN[0], btnU, btnD, btnL, btnR, btnC, oled_data_C, selected_key, key_pressed);
        
    assign led [3:0] = selected_key;
endmodule