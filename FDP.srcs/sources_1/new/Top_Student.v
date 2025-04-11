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

    parameter KEY_A = 4'b0000;
    parameter KEY_B = 4'b0001;
    parameter KEY_C = 4'b0010;
    parameter KEY_NOT = 4'b0100;
    parameter KEY_OR = 4'b0101;
    parameter KEY_AND = 4'b0110;
    parameter KEY_LBRAC = 4'b1000;
    parameter KEY_RBRAC = 4'b1001;
    parameter KEY_DELETE = 4'b1010;
    parameter KEY_ENTER = 4'b1011;
    parameter SEG_DIGIT_5 = 8'b1_0010010;
    parameter SEG_DIGIT_3_DP = 8'b0_0110000;
    parameter SEG_DIGIT_0 = 8'b1_1000000;
    parameter SEG_DIGIT_2 = 8'b1_0100100;
    
    // Generate required wires and regs
    reg [15:0] oled_data_right_reg = BLACK; 
    reg [15:0] oled_data_left_reg = BLACK; 
    wire [15:0] oled_data_right = oled_data_right_reg;
    wire [15:0] oled_data_left = oled_data_left_reg;
    wire [1:0] fb;
    wire [12:0] pixel_index_left;
    wire [12:0] pixel_index_right;
    wire [6:0] x_addr_right =  pixel_index_right % 96;
    wire [5:0] y_addr_right = pixel_index_right / 96;
    wire [6:0] x_addr_left =  pixel_index_right % 96;
    wire [5:0] y_addr_left = pixel_index_right / 96;
    wire [15:0] oled_data_A;
    wire [15:0] oled_data_B;
    wire [15:0] oled_data_C;
    wire [15:0] oled_data_D;
    wire clk_6p25M;
    wire [1:0] CURRENT_SCREEN = sw[1:0];
    wire [3:0] selected_key;
    wire key_pressed;
    wire [63:0] buffer_out;
    wire keyboard_locked;
    wire locked;
    wire [7:0] truth_table;
    wire tt_done;
    wire [3:0] last_selected_reg;
    reg [7:0] func_id;
    
    wire manual_reset;
    single_pulse_debouncer reset_debouncer (clk, sw[2], manual_reset);
    
    // Generate clock signals
    clock clk6p25 (clk, 7, clk_6p25M);
    
    // Segment Display
    reg [7:0] s_main [0:3]; // main segments
    wire [7:0] sA [0:3]; // Segments from Task A (c2)
    segment_display #(4999, 0) display (clk, s_main[3], s_main[2], s_main[1], s_main[0], seg, an);
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    ////////////////////////////////////////////////////////////////////////////////// 
    always @(posedge clk_6p25M) begin
        manage_func_id;
        case (CURRENT_SCREEN)
            2'b01: begin
                set_segment_task_A;
                
                oled_data_right_reg <= oled_data_A; // c2
                oled_data_left_reg <= oled_data_D; // Aik Haw
            end
            2'b10: begin
                default_segment_outputs;
                oled_data_right_reg <= oled_data_C; // Glenda
                oled_data_left_reg <= oled_data_B; // Louis
            end
            default: default_outputs;
        endcase
    end
    
    initial begin
        func_id <= 8'd255;
    end
    
    // Generate Individual Tasks

    TASK_A task_a (clk_6p25M, x_addr_right, y_addr_right, func_id, !CURRENT_SCREEN[0],
                  btnU, btnD, btnL, btnR, btnC, oled_data_A, sA[3], sA[2], sA[1], sA[0]);
    TASK_B task_b (clk_6p25M, x_addr_left, y_addr_left, !CURRENT_SCREEN[1], oled_data_B, locked, buffer_out);   
    TASK_C task_c (clk_6p25M, x_addr_right, y_addr_right, !CURRENT_SCREEN[1], manual_reset, btnU, btnD, btnL, 
                   btnR, btnC, oled_data_C, selected_key, key_pressed, buffer_out, locked);
    TASK_D task_d (
        .clk         (clk_6p25M),
        .rst         (!locked),
        .start       (locked),
        .equation_in (buffer_out), 
        .done        (tt_done),
        .truth_table (truth_table)
    );

    
    assign led [3:0] = selected_key;
    assign led [4] = keyboard_locked;
    assign led [5] = locked;
    assign led [13:6] = truth_table;
    
    //////////////////////////////////////////////////////////////////////////////////
    // OLED MODULES
    ////////////////////////////////////////////////////////////////////////////////// 
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
    // Tasks / Functions
    ////////////////////////////////////////////////////////////////////////////////// 
    task default_outputs;
    begin
        default_segment_outputs;
    end
    endtask
    
    task default_segment_outputs;
    begin
        s_main[3] <= SEG_DIGIT_5;
        s_main[2] <= SEG_DIGIT_3_DP;
        s_main[1] <= SEG_DIGIT_0;
        s_main[0] <= SEG_DIGIT_2;
    end
    endtask
   
    task set_segment_task_A;
    begin
        s_main[3] <= sA[3];
        s_main[2] <= sA[2];
        s_main[1] <= sA[1];
        s_main[0] <= sA[0];
    end
    endtask
    
    task manage_func_id;
    begin
        // Latch to valid ids
        func_id <= sw[15:8];
        //if (locked) func_id <= truth_table;
    end
    endtask
endmodule