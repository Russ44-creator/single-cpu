`timescale 1ns / 1ns
module ALU(
    input[31:0] A,  //输入1
    input[31:0] B, //输入2
    input[2:0] ALUOp,  //ALU操作控制
    input ifNeedOf,
    output sign,
    output zero, // 运算结果result的标志，result为0输出1，否则输出0
    output overflow, 
    output reg[31:0] result // ALU运算结果
);
    assign sign=result[31];
    reg [32:0] temp;
    assign zero=(result==0);  //设置zero
    assign overflow=(ifNeedOf&&A[31]^B[31]^result[31]^temp[32]); //判断溢出
    always @(*) begin
        case(ALUOp)
            3'b000:begin
                result<=A+B;
                temp<=A+B;
            end
            3'b001:begin
                result<=A-B;
                temp<=A-B;
            end
            3'b010:result<=B<<A;  //B左移A位
            3'b011:result<=A|B;   //或
            3'b100:result<=A&B;   //与
            3'b101:result<=A+B; //addu
            3'b110:result<=(((A<B)&&(A[31]==B[31]))||((A[31]==1&&B[31]==0)))?1:0; //带符号比较
            3'b111:result<=A^B;  //异或
            default:begin
                result=0;
            end
        endcase
    end
endmodule   

