`timescale 1ns / 1ps

module tb_uart_tx;
    reg clk, reset, tx_start;
    reg [7:0] data_in;
    wire baud_tick, tx, busy;
    
    baud_gen BAUD (clk,reset,baud_tick);
    uart_tx TX (clk,reset,baud_tick,tx_start,data_in,tx,busy);
    
    initial
        begin
            clk=0;
            forever #5 clk=~clk;
        end
    initial
        begin
            reset=1; tx_start=0; data_in=0;
            #20 reset=0;
            #20 data_in=8'hA5; tx_start=1;
            #10 tx_start=0;
            
            #3000 $finish;
        end
endmodule
