`timescale 1ns / 1ps

module baud_gen(
    input clk,
    input reset,
    output reg baud_tick
    );
    parameter CLK_FREQ=100;
    parameter BAUD_RATE=10;
    localparam BAUD_COUNT=CLK_FREQ/BAUD_RATE;
    reg [15:0] count;
    
    always @(posedge clk)
        begin
            if (reset)
                begin
                    count<=0;
                    baud_tick<=0;
                end
            else
                begin
                    if (count==BAUD_COUNT-1)
                        begin
                            count<=0;
                            baud_tick<=1;
                        end
                    else
                        begin
                            count<=count+1;
                            baud_tick<=0;
                        end
                end
        end
                            
                            
endmodule
