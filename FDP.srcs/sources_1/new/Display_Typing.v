`timescale 1ns / 1ps

module Display_Typing(
    input clk,
//input reset,
    input fb,
    input [3:0] selected_key, // The selected key (A, B, etc.)
    input [6:0] x_addr, // X coordinate for the pixel
    input [5:0] y_addr, // Y coordinate for the pixel
    input key_pressed,
    output reg led, //led15
    output reg signal, //led14
    output reg [15:0] pixel_data,
    output reg keyboard_lock
);
    // Define the characters for the keys
    parameter KEY_A      = 4'b0000;
    parameter KEY_B      = 4'b0001;
    parameter KEY_C      = 4'b0010;
    parameter KEY_NOT    = 4'b0100;
    parameter KEY_OR     = 4'b0101;
    parameter KEY_AND    = 4'b0110;
    parameter KEY_LBRAC  = 4'b1000;
    parameter KEY_RBRAC  = 4'b1001;
    
    parameter KEY_DELETE = 4'b1010;
    parameter KEY_ENTER = 4'b1011;

    // Character buffer to hold the sequence of characters
    reg [7:0] char_buffer [0:15];  // Display 10 characters max
//    integer cursor_pos = 0;       // Cursor position for entering new characters
    reg [7:0] char_bitmap;        // Bitmap for the current character
    integer i;
    reg [3:0] last_selected_key;  // Store the last selected key
//    reg keyboard_lock;  
//    integer open_brac_count = 0;
//    integer close_brac_count = 0;
//    integer prev_brac_count = 0;
    
    reg [4:0] cursor_pos = 0;       // Cursor position for entering new characters
    reg [4:0] open_brac_count = 0;
    reg [4:0] close_brac_count = 0;
    reg [4:0] prev_brac_count = 0;

    wire is_valid;
    reg [7:0] current_char;
    reg [2:0] current_row;
    wire [7:0] char_bitmap_wire;
    
    check_validity validity_checker (
        .selected_key(selected_key),
        .last_selected_key(last_selected_key),
        .cursor_pos(cursor_pos),
        .open_brac_count(open_brac_count),
        .prev_brac_count(prev_brac_count),
        .check_validity(is_valid)
    );
    
    character_bitmap char_bit_map (
        .char(current_char),
        .row(current_row),
        .get_character_bitmap(char_bitmap_wire)
    );
    
    // Initialize the char buffer
    initial begin
        for (i = 0; i < 16; i = i + 1) begin
            char_buffer[i] <= " ";  // Fill with spaces initially
        end
        last_selected_key = 4'b1111; // No key selected initially
        keyboard_lock = 0;
        led = 1'b0;
        signal =1'b0;
    end
    
    //function integer check_paranthesis;
      //  input [3:0] selected_key;
        //input [3:0] open_brac_count;
   //     input [3:0] close_brac_count;
     //   begin 
       //     check_paranthesis = 1;
            
            // Parenthesis balancing logic
         //   if (selected_key == KEY_LBRAC) begin
           //     open_brac_count = open_brac_count + 1;
           // end else if (selected_key == KEY_RBRAC) begin
             //   if (open_brac_count <= close_brac_count) begin
               //     check_paranthesis = 0; // Invalid if there's no unmatched '('
              //  end else begin
                //    close_brac_count = close_brac_count + 1;
                //end
            //end
        //end
    //endfunction
            
    
//    function integer check_validity;
//        input [3:0] selected_key;
//        input [3:0] last_selected_key;
//        input integer cursor_pos;
    
//        begin
//            check_validity = 1;  // Default to valid
            
         
    
//            // Ensure the first key is valid
//            if (cursor_pos == 0) begin
//                if (!(selected_key == KEY_NOT || selected_key == KEY_A || selected_key == KEY_B || 
//                      selected_key == KEY_C || selected_key == KEY_LBRAC)) begin
//                    check_validity = 0;
//                end
               
//            end
    
//            // Ensure valid sequences
//            else if (last_selected_key == KEY_NOT) begin
//                if (!(selected_key == KEY_A || selected_key == KEY_B || selected_key == KEY_C || selected_key == KEY_LBRAC)) begin
//                    check_validity = 0;
//                end
                

//            end else if (last_selected_key == KEY_A || last_selected_key == KEY_B || last_selected_key == KEY_C) begin
//                if (!(selected_key == KEY_AND || selected_key == KEY_OR || selected_key == KEY_RBRAC)) begin
//                    check_validity = 0;
//                end
//                if (selected_key == KEY_RBRAC) begin                    
//                    if (prev_brac_count == open_brac_count) begin
//                        check_validity = 0; // Invalid if close brackets exceed open ones                           
//                    end
//               end
                

//            end else if (last_selected_key == KEY_AND || last_selected_key == KEY_OR) begin
//                if (!(selected_key == KEY_A || selected_key == KEY_B || selected_key == KEY_C || selected_key == KEY_NOT || selected_key == KEY_LBRAC)) begin
//                    check_validity = 0;
                    
//                end
                

//            end else if (last_selected_key == KEY_LBRAC) begin
//                if (!(selected_key == KEY_A || selected_key == KEY_B || selected_key == KEY_C || selected_key == KEY_NOT)) begin
//                    check_validity = 0;
                   
//                end
//            end else if (last_selected_key == KEY_RBRAC) begin
//                if (!(selected_key == KEY_AND || selected_key == KEY_OR)) begin
//                    check_validity = 0;
                    
//                end
//            end else if (last_selected_key == KEY_DELETE) begin
//                check_validity = 1;
//            end
    
//            // Ensure valid ending
//            if (cursor_pos == 15) begin
//                if (selected_key == KEY_AND || selected_key == KEY_OR || selected_key == KEY_NOT || selected_key == KEY_LBRAC) begin
//                    check_validity = 0;
                    
//                end
//            end
    

            
//        end
//    endfunction



    // Function to return the bitmap for the selected character
//    function [7:0] get_character_bitmap(input [7:0] char, input [2:0] row);
//        case (char)
//            "A": case (row)
//                7: get_character_bitmap = 8'b00111100;
//                6: get_character_bitmap = 8'b01100110;
//                5: get_character_bitmap = 8'b01100110;
//                4: get_character_bitmap = 8'b01111110;
//                3: get_character_bitmap = 8'b01100110;
//                2: get_character_bitmap = 8'b01100110;
//                1: get_character_bitmap = 8'b01100110;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//            "B": case (row)
//                7: get_character_bitmap = 8'b00111110;
//                6: get_character_bitmap = 8'b01100110;
//                5: get_character_bitmap = 8'b01100110;
//                4: get_character_bitmap = 8'b00111110;
//                3: get_character_bitmap = 8'b01100110;
//                2: get_character_bitmap = 8'b01100110;
//                1: get_character_bitmap = 8'b00111110;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//             "C": case (row)
//                7: get_character_bitmap = 8'b00111110;
//                6: get_character_bitmap = 8'b00111110;
//                5: get_character_bitmap = 8'b00000110;
//                4: get_character_bitmap = 8'b00000110;
//                3: get_character_bitmap = 8'b00000110;
//                2: get_character_bitmap = 8'b00111110;
//                1: get_character_bitmap = 8'b00111110;
//                0: get_character_bitmap = 8'b00000000;
//                endcase 
//             ".": case (row)
//               7: get_character_bitmap = 8'b00000000;
//               6: get_character_bitmap = 8'b00000000;
//               5: get_character_bitmap = 8'b00111100;
//               4: get_character_bitmap = 8'b00111100;
//               3: get_character_bitmap = 8'b00111100;
//               2: get_character_bitmap = 8'b00111100;
//               1: get_character_bitmap = 8'b00000000;
//               0: get_character_bitmap = 8'b00000000;
//               endcase           
//            "+": case (row)
//                7: get_character_bitmap = 8'b00011000;
//                6: get_character_bitmap = 8'b00011000;
//                5: get_character_bitmap = 8'b01111110;
//                4: get_character_bitmap = 8'b00011000;
//                3: get_character_bitmap = 8'b00011000;
//                2: get_character_bitmap = 8'b00000000;
//                1: get_character_bitmap = 8'b00000000;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//            "~": case (row)
//                7: get_character_bitmap = 8'b00000000;
//                6: get_character_bitmap = 8'b00000000;
//                5: get_character_bitmap = 8'b10001000;
//                4: get_character_bitmap = 8'b01010100;
//                3: get_character_bitmap = 8'b00100010;
//                2: get_character_bitmap = 8'b00000000;
//                1: get_character_bitmap = 8'b00000000;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//            "(": case (row)
//                7: get_character_bitmap = 8'b00000000;
//                6: get_character_bitmap = 8'b00111000;
//                5: get_character_bitmap = 8'b00011100;
//                4: get_character_bitmap = 8'b00000110;
//                3: get_character_bitmap = 8'b00000110;
//                2: get_character_bitmap = 8'b00011100;
//                1: get_character_bitmap = 8'b00111000;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//            ")": case (row)
//                7: get_character_bitmap = 8'b00000000;
//                6: get_character_bitmap = 8'b00011100;
//                5: get_character_bitmap = 8'b00111000;
//                4: get_character_bitmap = 8'b01100000;
//                3: get_character_bitmap = 8'b01100000;
//                2: get_character_bitmap = 8'b00111000;
//                1: get_character_bitmap = 8'b00011100;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//            " ": case (row)
//                7: get_character_bitmap = 8'b00000000;
//                6: get_character_bitmap = 8'b00000000;
//                5: get_character_bitmap = 8'b00000000;
//                4: get_character_bitmap = 8'b00000000;
//                3: get_character_bitmap = 8'b00000000;
//                2: get_character_bitmap = 8'b00000000;
//                1: get_character_bitmap = 8'b00000000;
//                0: get_character_bitmap = 8'b00000000;
//                endcase
//            default: get_character_bitmap = 8'b00000000;  // Return 0 for any other characters
//        endcase
//    endfunction
    

    // Update the character buffer with the selected key
    //always @(posedge clk or posedge reset) begin
    always @(posedge clk) begin
//          if (key_pressed && selected_key != last_selected_key) begin 
//               if (selected_key == KEY_DELETE) begin
//                   //last_selected_key == sec_last_selected_key;
//                   if (cursor_pos > 0) begin
//                       keyboard_lock = 0;
//                       cursor_pos = cursor_pos - 1; // Move cursor back
//                       char_buffer[cursor_pos] = " "; // Clear character at cursor
//                   end
//               end 
////               else if (!keyboard_lock && check_validity(selected_key, last_selected_key, cursor_pos)) begin
//               else if (!keyboard_lock && is_valid) begin
//                   // Store the character in the buffer
//                   //sec_last_selected_key == last_selected_key;
//                   if (selected_key == KEY_LBRAC) begin
//                       open_brac_count = open_brac_count + 1;
//                   end
//                   if (selected_key == KEY_RBRAC) begin 
//                        prev_brac_count = close_brac_count;                   
//                        close_brac_count = close_brac_count + 1;
//                   end
//                  case (selected_key)
//                       KEY_A: char_buffer[cursor_pos] <= "A";
//                       KEY_B: char_buffer[cursor_pos] <= "B";
//                       KEY_C: char_buffer[cursor_pos] <= "C";
//                       KEY_NOT: char_buffer[cursor_pos] <= "~";
//                       KEY_OR: char_buffer[cursor_pos] <= "+";
//                       KEY_AND: char_buffer[cursor_pos] <= ".";
//                       KEY_LBRAC: char_buffer[cursor_pos] <= "(";
//                       KEY_RBRAC: char_buffer[cursor_pos] <= ")";
//                       default: char_buffer[cursor_pos] <= " ";  
//                  endcase
                  
//                   // Move cursor forward if there's space
//                  if (cursor_pos < 16) begin
//                       cursor_pos <= cursor_pos + 1;
//                       keyboard_lock <= 0;
//                  end
                  
//                  if (cursor_pos == 16) begin
//                         //char_buffer[cursor_pos] = " ";
//                     keyboard_lock = 1; //unlock the keyboard again
//                 //cursor_pos = cursor_pos - 1;
                
//                  end
//              end
              
            if (key_pressed && selected_key != last_selected_key) begin
              if (!keyboard_lock) begin
                  if (selected_key == KEY_ENTER && is_valid && (open_brac_count == close_brac_count)) begin
                      keyboard_lock <= 1;  // Lock keyboard
                  end
                  else if (selected_key == KEY_DELETE) begin
                        if (cursor_pos > 0) begin
                            cursor_pos <= cursor_pos - 1;
                            char_buffer[cursor_pos] <= " ";
                        end
                    end 
                  else if (is_valid) begin
                    led <= 1'b0;
                    if (selected_key == KEY_LBRAC) begin
                       open_brac_count = open_brac_count + 1;
                    end
                    if (selected_key == KEY_RBRAC) begin 
                        prev_brac_count = close_brac_count;                   
                        close_brac_count = close_brac_count + 1;
                    end
                      // Store character
                      case (selected_key)
                           KEY_A: char_buffer[cursor_pos] <= "A";
                           KEY_B: char_buffer[cursor_pos] <= "B";
                           KEY_C: char_buffer[cursor_pos] <= "C";
                           KEY_NOT: char_buffer[cursor_pos] <= "~";
                           KEY_OR: char_buffer[cursor_pos] <= "+";
                           KEY_AND: char_buffer[cursor_pos] <= ".";
                           KEY_LBRAC: char_buffer[cursor_pos] <= "(";
                           KEY_RBRAC: char_buffer[cursor_pos] <= ")";
                           default: char_buffer[cursor_pos] <= " ";  
                      endcase
                      
                      if (cursor_pos < 16) begin
                          cursor_pos <= cursor_pos + 1;
                      end
          
                      if (cursor_pos == 16) begin
                          keyboard_lock <= 1;
                      end
                  end
              end
          
                // Update the last selected key
              if (selected_key == KEY_DELETE || is_valid) begin
                  last_selected_key <= selected_key;
              end
          
              
//              if(!check_validity(selected_key, last_selected_key, cursor_pos ))begin
              if(!is_valid)begin
                led <= 1'b1;
              end else begin
                led <= 1'b0;
              end
              
              if (open_brac_count <= close_brac_count) begin
                signal <= 1'b0;
              end else begin
                signal <= 1'b1;
              end
          end
   end

    // Logic for displaying the character on the OLED screen
    always @(posedge clk) begin
        pixel_data <= 16'h0000;  // Default background color (Black)
        
        // Display the characters stored in the buffer
        for (i = 0; i < 16; i = i + 1) begin
            // For the first line (10 characters)
            if (i < 10) begin
                if (x_addr >= (78 - i*8) && x_addr < (86 - i*8) && y_addr >= 30 && y_addr < 38) begin
                    current_char <= char_buffer[i];
                    current_row <= y_addr - 30;
                    if (char_bitmap_wire[7 - (x_addr - (86 - i*8))]) begin
                        pixel_data <= 16'hFFFF; // Set pixel color to white
                    end
                end
            end 
            // For the second line (6 characters)
            else begin
                if (x_addr >= (78 - (i - 8)*8) && x_addr < (86 - (i - 8)*8) && y_addr >= 22 && y_addr < 30) begin
                    current_char <= char_buffer[i];
                    current_row <= y_addr - 22;
                    if (char_bitmap_wire[7 - (x_addr - (86 - (i - 8)*8))]) begin
                        pixel_data <= 16'hFFFF; // Set pixel color to white
                    end
                end
            end
        end
    end
endmodule