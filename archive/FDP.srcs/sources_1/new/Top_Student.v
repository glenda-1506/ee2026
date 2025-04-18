`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME:  Liang Xuanyin Glenda
//  STUDENT B NAME:  Joe Tien You
//  STUDENT C NAME:  Goh Aik Haw
//  STUDENT D NAME:  Si Thu Lin Aung
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input [15:0] sw,
    input btnU, btnD, btnL, btnR, btnC,
    output [7:0] JB,
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
    parameter GREEN = 16'h07E0;
    parameter RED = 16'hF800;
    parameter PASSWORD_A = 16'b0001001100100111; //  [0, 1, 2, 5, 8, 9, 12]
    parameter PASSWORD_B = 16'b0010000100101111; //  [0, 1, 2, 3, 5, 8, 13]
    parameter PASSWORD_C = 16'b0100000010110111; //  [0, 1, 2, 4, 5, 7, 14]
    parameter PASSWORD_D = 16'b1000000011000111; //  [0, 1, 2, 6, 7, 15]
    
    // Generate required wires and regs
    reg [15:0] oled_data_reg = BLACK; 
    wire [15:0] CURRENT_PASSWORD = sw;
    wire is_idle = (CURRENT_PASSWORD != PASSWORD_A) && 
                   (CURRENT_PASSWORD != PASSWORD_B) &&
                   (CURRENT_PASSWORD != PASSWORD_C) &&
                   (CURRENT_PASSWORD != PASSWORD_D);
    wire fb;
    wire [12:0] pixel_index;
    wire clk_6p25M;
    wire clk_25M;
    wire [15:0] oled_data_A;
    wire [15:0] oled_data_B;
    wire [15:0] oled_data_C;
    wire [15:0] oled_data_D;
    wire [15:0] oled_data = oled_data_reg;
    wire [11:0] blinking_leds; 
    wire group_id_ready;
    wire blinking_control;
    
    // Task 4.E1 & E5
    blinky task_4E5 (clk, CURRENT_PASSWORD, blinking_control);
    assign blinking_leds = blinking_control ? {sw[11:0]} : 0;
    assign led = is_idle ? sw : {{sw[15:12]} , {blinking_leds}};
    
    // Generate clock signals
    clk_6p25MHz clk6p25 (clk, clk_6p25M);
    clk_25MHz clk25 (clk, clk_25M); 
    
   // Instantiate OLED
    Oled_Display oled (
        .clk(clk_6p25M), 
        .reset(0), 
        .frame_begin(fb), 
        .sending_pixels(), 
        .sample_pixel(), 
        .pixel_index(pixel_index), 
        .pixel_data(oled_data), 
        .cs(JB[0]), 
        .sdin(JB[1]), 
        .sclk(JB[3]), 
        .d_cn(JB[4]), 
        .resn(JB[5]), 
        .vccen(JB[6]), 
        .pmoden(JB[7]));
    
    //////////////////////////////////////////////////////////////////////////////////
    // MAIN CODE LOGIC
    ////////////////////////////////////////////////////////////////////////////////// 
    always @(posedge clk_25M) begin
        // Task 4.E2
        if (is_idle) begin
            oled_data_reg <= group_id_ready ? WHITE : BLACK;
        end
        
        // Individual Tasks
        else begin
            case (CURRENT_PASSWORD)
                PASSWORD_A: oled_data_reg <= oled_data_A;
                PASSWORD_B: oled_data_reg <= oled_data_B;
                PASSWORD_C: oled_data_reg <= oled_data_C;
                PASSWORD_D: oled_data_reg <= oled_data_D;
            endcase
        end
    end
    
    // Generate Individual Tasks
    TASK_4A task_4a (clk, pixel_index, (CURRENT_PASSWORD != PASSWORD_A), btnC, btnU, btnD, oled_data_A);
    TASK_4B task_4b (clk, pixel_index, (CURRENT_PASSWORD != PASSWORD_B), btnC, btnU, btnD, oled_data_B);
    TASK_4C task_4c (clk, pixel_index, (CURRENT_PASSWORD != PASSWORD_C), btnC, oled_data_C);
    TASK_4D task_4d (clk, pixel_index, (CURRENT_PASSWORD != PASSWORD_D), btnU, btnD, btnL, btnR, oled_data_D);
    
    // Generate Group ID
    group_generator grp_generator(
        .IDLE_STATE(is_idle),
        .pixel_index(pixel_index),
        .ready(group_id_ready));
    
    // Generate 7-segment display on all anode
    seg7_control seg7_inst (
        .clk(clk),  
        .seg(seg),          
        .an(an)             
    );
    
endmodule
