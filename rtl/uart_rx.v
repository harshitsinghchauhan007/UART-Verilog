`timescale 1ns / 1ps

module uart_rx(
    input clk,
    input reset,
    input rx,
    output reg [7:0] data_out,
    output reg data_valid
    );
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg [15:0] baud_counter;
    reg [1:0] state, next_state;
    parameter BAUD_COUNT=10;
    localparam HALF_BAUD=BAUD_COUNT/2;
    parameter IDLE=0, START=1, DATA=2, STOP=3;
    wire timer_done;
    
    assign timer_done=(state==START)?(baud_counter==HALF_BAUD-1):(baud_counter==BAUD_COUNT-1);
     
    always @(posedge clk)
        begin
            if (reset)
                state<=IDLE;
            else
                state<=next_state;
        end
    always @(*)
        begin
            case(state)
                IDLE: next_state=(rx==0)?START:IDLE;
                START: begin
                         if (timer_done)
                             next_state=(rx==0)?DATA:IDLE;
                         else
                             next_state=START;
                       end
                DATA: begin
                        if(timer_done&&bit_count==7) 
                            next_state=STOP;
                        else
                            next_state=DATA;
                     end
                STOP: begin
                        if (timer_done)
                            next_state=IDLE;
                        else
                            next_state=STOP;
                      end
                default: next_state=IDLE;
            endcase
        end
    always @(posedge clk)
        begin
            if (reset)
                begin
                    shift_reg<=0;
                    bit_count<=0;
                    baud_counter<=0;
                    data_out<=0;
                    data_valid<=0;
                end
            else
                begin
                    data_valid<=0;
                    case(state)
                        IDLE: begin
                                bit_count<=0;
                                data_valid<=0;
                                baud_counter<=0;
                              end
                        START: begin
                                if (!timer_done)
                                    baud_counter<=baud_counter+1;
                                else
                                    baud_counter<=0;
                               end
                        DATA: begin
                                if (!timer_done)
                                    baud_counter<=baud_counter+1;
                                else
                                    begin
                                        baud_counter<=0;
                                        shift_reg[bit_count]<=rx;
                                        if(bit_count<7)
                                            bit_count<=bit_count+1;   
                                    end
                              end
                        STOP: begin
                                if (!timer_done)
                                    baud_counter<=baud_counter+1;
                                else
                                    begin
                                        baud_counter<=0;
                                        if (rx)
                                            begin
                                                data_out<=shift_reg;
                                                data_valid<=1;
                                            end
                                    end
                              end
                    endcase 
                end
        end
endmodule
