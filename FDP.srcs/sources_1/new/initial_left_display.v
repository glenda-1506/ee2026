`timescale 1ns / 1ps

module initial_left_display(
    input  [6:0] x_addr,     
    input  [5:0] y_addr,     
    output reg [15:0] pixel_data  
);

    always @(*) begin
        if (
            (y_addr == 61 && (
                (x_addr >= 87 && x_addr <= 94) ||
                (x_addr >= 76 && x_addr <= 84) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 52 && x_addr <= 57) ||
                (x_addr >= 38 && x_addr <= 47) ||
                (x_addr >= 26 && x_addr <= 35) ||
                (x_addr >= 14 && x_addr <= 23) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 3)
            )) || 
            (y_addr == 60 && (
                (x_addr >= 87 && x_addr <= 94) ||
                (x_addr >= 76 && x_addr <= 84) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 51 && x_addr <= 58) ||
                (x_addr >= 38 && x_addr <= 47) ||
                (x_addr >= 26 && x_addr <= 35) ||
                (x_addr >= 14 && x_addr <= 23) ||
                (x_addr >= 9  && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 3)
            )) ||
            (y_addr == 59 && (
                (x_addr >= 93 && x_addr <= 94) ||
                (x_addr >= 83 && x_addr <= 84) ||
                (x_addr >= 76 && x_addr <= 77) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 57 && x_addr <= 59) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 50 && x_addr <= 52) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 30 && x_addr <= 31) ||
                (x_addr >= 22 && x_addr <= 23) ||
                (x_addr >= 14 && x_addr <= 15) ||
                (x_addr >= 8  && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 3)
            )) || 
            (y_addr == 58 && (
                (x_addr >= 93 && x_addr <= 94) ||
                (x_addr >= 83 && x_addr <= 84) ||
                (x_addr >= 76 && x_addr <= 77) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 58 && x_addr <= 60) ||
                (x_addr >= 49 && x_addr <= 51) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 30 && x_addr <= 31) ||
                (x_addr >= 22 && x_addr <= 23) ||
                (x_addr >= 14 && x_addr <= 15) ||
                (x_addr >= 7  && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 3)
            )) ||
            (y_addr == 57 && (
                (x_addr >= 87 && x_addr <= 94) ||
                (x_addr >= 83 && x_addr <= 84) ||
                (x_addr >= 76 && x_addr <= 77) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 59 && x_addr <= 60) ||
                (x_addr >= 49 && x_addr <= 50) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 30 && x_addr <= 31) ||
                (x_addr >= 22 && x_addr <= 23) ||
                (x_addr >= 14 && x_addr <= 15) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 6  && x_addr <= 8)  ||
                (x_addr >= 2  && x_addr <= 3)
            )) ||
            (y_addr == 56 && (
                (x_addr >= 87 && x_addr <= 94) ||
                (x_addr >= 83 && x_addr <= 84) ||
                (x_addr >= 76 && x_addr <= 77) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 59 && x_addr <= 60) ||
                (x_addr >= 49 && x_addr <= 50) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 22 && x_addr <= 23) ||
                (x_addr >= 14 && x_addr <= 15) ||
                (x_addr >= 30 && x_addr <= 31) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 5  && x_addr <= 7)  ||
                (x_addr >= 2  && x_addr <= 3)
            )) ||
            (y_addr == 55 && (
                (x_addr >= 93 && x_addr <= 94) ||
                (x_addr >= 83 && x_addr <= 84) ||
                (x_addr >= 76 && x_addr <= 77) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 49 && x_addr <= 60) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 22 && x_addr <= 23) ||
                (x_addr >= 14 && x_addr <= 15) ||
                (x_addr >= 30 && x_addr <= 31) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 6)
            )) ||
            (y_addr == 54 && (
                (x_addr >= 93 && x_addr <= 94) ||
                (x_addr >= 83 && x_addr <= 84) ||
                (x_addr >= 76 && x_addr <= 78) ||
                (x_addr >= 71 && x_addr <= 72) ||
                (x_addr >= 63 && x_addr <= 64) ||
                (x_addr >= 49 && x_addr <= 60) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 30 && x_addr <= 31) ||
                (x_addr >= 22 && x_addr <= 23) ||
                (x_addr >= 14 && x_addr <= 15) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 5)
            )) ||
            (y_addr == 53 && (
                (x_addr >= 87 && x_addr <= 94) ||
                (x_addr >= 76 && x_addr <= 84) ||
                (x_addr >= 63 && x_addr <= 72) ||
                (x_addr >= 59 && x_addr <= 60) ||
                (x_addr >= 49 && x_addr <= 50) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 26 && x_addr <= 35) ||
                (x_addr >= 14 && x_addr <= 23) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 4)
            )) ||
            (y_addr == 52 && (
                (x_addr >= 87 && x_addr <= 94) ||
                (x_addr >= 74 && x_addr <= 84) ||
                (x_addr >= 63 && x_addr <= 72) ||
                (x_addr >= 59 && x_addr <= 60) ||
                (x_addr >= 49 && x_addr <= 50) ||
                (x_addr >= 42 && x_addr <= 43) ||
                (x_addr >= 26 && x_addr <= 35) ||
                (x_addr >= 14 && x_addr <= 23) ||
                (x_addr >= 10 && x_addr <= 11) ||
                (x_addr >= 2  && x_addr <= 4)
            )) ||
            (y_addr == 51 && x_addr == 74) || 
            (y_addr == 50 && (x_addr == 73 || x_addr == 74)) ||
            ((y_addr == 48 || y_addr == 63) && (x_addr >= 0 && x_addr <= 95))
        ) begin
            pixel_data = 16'h07ff; 
        end
        else begin
            pixel_data = 16'h0000;
        end
    end

endmodule