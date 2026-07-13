`timescale 1ns / 1ps

module tb_baud_gen;
    reg clk;
    reg reset;
    wire baud_tick;
    
    baud_gen DUT (.clk(clk),.reset(reset),.baud_tick(baud_tick));
    
    initial
        begin
            clk=0;
            forever #5 clk=~clk;
        end
    initial
        begin
            reset=1;
            #20 reset =0;
            #200 $finish;
        end
    
endmodule
