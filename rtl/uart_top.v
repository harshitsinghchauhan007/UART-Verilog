`timescale 1ns / 1ps

module uart_top(
    input clk,
    input reset,
    input tx_start,
    input [7:0] data_in,
    output [7:0] data_out,
    output data_valid
    );
    wire tx;
    wire baud_tick;
    wire busy;
    
    baud_gen BAUD (.clk(clk),.reset(reset),.baud_tick(baud_tick));
    uart_tx TX (.clk(clk),.reset(reset),.baud_tick(baud_tick),.tx_start(tx_start),.data_in(data_in),.tx(tx),.busy(busy));
    uart_rx RX(.clk(clk),.reset(reset),.rx(tx),.data_out(data_out),.data_valid(data_valid));
endmodule
