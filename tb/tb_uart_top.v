`timescale 1ns / 1ps
module tb_uart_top;
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] data_in;
    
    wire [7:0] data_out;
    wire data_valid;
    
    uart_top DUT(.clk(clk),.reset(reset),.tx_start(tx_start),.data_in(data_in),.data_out(data_out),.data_valid(data_valid));
    initial
        begin
            clk=0;
            forever #5 clk=~clk;
        end
    initial
        begin
            reset=1;
            tx_start=0;
            data_in=8'h00;
            
            #20 reset=0;
            #20 data_in=8'hA5; tx_start=1;
            #10 tx_start=0;
            #3000 $finish;
        end
     
endmodule
