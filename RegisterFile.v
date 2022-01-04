//存放临时数据
//写操作沿时钟下降沿进行
`timescale 1ns / 1ns
module RegisterFile(
    input CLK,  //时钟
    input WE,  //写使能信号，为 1 时，在时钟边沿触发写入
    input[4:0] rs, // rs寄存器地址输入端口
    input[4:0] rt, // rt寄存器地址输入端口
    input[4:0] WriteReg, // 将数据写入的寄存器端口，其地址来源rt或rd字段
    input[31:0] WriteData, // 写入寄存器的数据输入端口
    output [31:0] ReadData1, // rs寄存器数据输出端口
    output [31:0] ReadData2 // rt寄存器数据输出端口
);
    reg[31:0] register[0:31]; // 新建32个寄存器，用于操作
    integer i;
    initial begin
      for(i=0;i<32;i=i+1)register[i]<=0;
    end
     // 读寄存器
    //0号寄存器的值是不能改变的，一直为0
    assign ReadData1=(rs==0)?0:register[rs]; 
    assign ReadData2=(rt==0)?0:register[rt];
    // 写寄存器
    always@(negedge CLK)begin //在时钟边沿触发写入
        if (WriteReg && WE) begin
            register[WriteReg]<=WriteData;
        end
    end
endmodule