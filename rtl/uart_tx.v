`timescale 1ns / 1ps

module uart_tx(
    input clk,
    input reset,
    input baud_tick,
    input tx_start,
    input [7:0] data_in,
    output reg tx,
    output reg busy
    );
    parameter IDLE=0, START=1, DATA=2, STOP=3;
    reg [1:0] state,next_state;
    
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    
    always  @(posedge clk)
        begin
            if (reset)
                state<=IDLE;
            else
                state<=next_state;
        end
    always @(*)
        begin
            case(state)
                IDLE: next_state=tx_start?START:IDLE;
                START: next_state=baud_tick?DATA:START;
                DATA: begin
                        if (baud_tick)
                            begin
                                if (bit_count==7)
                                    next_state=STOP;
                                else
                                    next_state=DATA;
                            end
                        else
                            next_state=DATA;
                      end
                STOP: next_state=baud_tick?IDLE:STOP;
                default: next_state=IDLE;
            endcase
        end
        
    always @(posedge clk)
        begin
            if (reset)
                begin
                    tx<=1;
                    busy<=0;
                    shift_reg<=0;
                    bit_count<=0;
                end
            else
                begin
                    case(state)
                        IDLE: begin
                                tx<=1;
                                if(tx_start) begin
                                    shift_reg<=data_in;
                                    bit_count<=0;
                                    busy<=1;
                                  end
                                else
                                    busy<=0;
                              end
                        START: begin
                                tx<=0;
                                busy<=1;
                                if (baud_tick)
                                    begin
                                        tx<=shift_reg[0];
                                        shift_reg<=shift_reg>>1;
                                        bit_count<=0;
                                    end
                               end
                        DATA: begin
                                busy<=1;
                                if (baud_tick) begin
                                    if (bit_count==7)
                                        tx<=1;
                                    else 
                                        begin
                                            tx<=shift_reg[0];
                                            shift_reg<=shift_reg>>1;
                                            bit_count<=bit_count+1;
                                        end
                                end
                             end
                        STOP: begin
                               tx<=1;
                               if (baud_tick)
                                   busy<=0;
                             end
               endcase
            end
        end
endmodule
