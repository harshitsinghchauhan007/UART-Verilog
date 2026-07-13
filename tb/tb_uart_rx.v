`timescale 1ns / 1ps

module tb_uart_rx;
    reg clk;
    reg reset;
    reg rx;
    wire [7:0] data_out;
    wire data_valid;
 
    uart_rx RX(clk,reset,rx,data_out,data_valid);
    
    initial
        begin
            clk=0;
            forever #5 clk=~clk;
        end
    initial
        begin
            reset=1;       //IDLE LINE
            rx=1;
            #20 reset=0;
            #20 rx=0;      //START BIT
            #100 rx=1;     //D0
            #100 rx=0;     //D1
            #100 rx=1;     //D2
            #100 rx=0;     //D3
            #100 rx=0;     //D4
            #100 rx=1;     //D5
            #100 rx=0;     //D6
            #100 rx=1;     //D7
            #100 rx=1;     //STOP BIT
            #300 $finish;
        end
endmodule
