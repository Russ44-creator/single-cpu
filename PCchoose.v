//计算下一个指令的地址并传给PC，根据不通PCSrc信号选择
`timescale 1ns / 1ns
module PCchoose(
    input[1:0] PCSrc,
    input[31:0] singedImmediate,
    input[31:0] curPC,
    input[31:0] addr,
    output reg[31:0] nextPC
);
    wire[31:0] PC4=curPC+4; 
    always@(*)begin
        if(PCSrc==2'b00)begin
            nextPC<=PC4;
        end 
        if(PCSrc==2'b01)begin
            nextPC<=PC4+singedImmediate*4; //beq
        end
        if(PCSrc==2'b10)begin
            nextPC<={PC4[31:28],addr[25:0],2'b00};  //j
        end
    end
endmodule
