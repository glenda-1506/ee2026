`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2025 02:38:13 AM
// Design Name: 
// Module Name: control
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


module control(
    input clk,
    input reset,
    input [3:0]pb, // left, right, up, down (3, 2, 1, 0)
    output reg [6:0] green_x, // top left
    output reg [5:0] green_y  // top_left
    );
    
    //////////////////////////////////////////////////////////////////////////////////
    // Instantiate parameter and modules
    //////////////////////////////////////////////////////////////////////////////////
    // Set initial position of green square
    parameter GREEN_SIZE = 10;
    parameter INIT_X = 0;
    parameter INIT_Y = 54;
    
    // Set direction parameters
    parameter DIR_NONE = 3'd0;
    parameter DIR_LEFT = 3'd1;
    parameter DIR_RIGHT = 3'd2;
    parameter DIR_UP = 3'd3;
    parameter DIR_DOWN = 3'd4;
    reg [2:0] dir = DIR_NONE;
    
    // Define boundary function
    function is_within_boundary;
        input [6:0] new_x;
        input [5:0] new_y;
        reg first_check;
        reg second_check;
        begin
            first_check = (new_x >= 0 && new_x <= 56 && new_y >= 0 && new_y <= 54);
            second_check = (new_x >= 0 && new_x <= 86 && new_y >= 30 && new_y <= 54);
            is_within_boundary = first_check || second_check;
        end
    endfunction
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            green_x <= INIT_X;
            green_y <= INIT_Y;
            dir <= DIR_NONE;
        end 
        else begin
            case (pb)
                4'b1000: dir <= DIR_LEFT;
                4'b0100: dir <= DIR_RIGHT;
                4'b0010: dir <= DIR_UP;
                4'b0001: dir <= DIR_DOWN;
                default: dir <= dir;
            endcase
            
            case (dir)
                DIR_LEFT: if (is_within_boundary(green_x - 1, green_y)) green_x <= green_x - 1;
                DIR_RIGHT: if (is_within_boundary(green_x + 1, green_y)) green_x <= green_x + 1;
                DIR_UP: if (is_within_boundary(green_x, green_y - 1)) green_y <= green_y -1;
                DIR_DOWN: if (is_within_boundary(green_x, green_y + 1)) green_y <= green_y + 1;
                default: ;
            endcase
            
        end
    end
    
    
endmodule
