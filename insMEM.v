//储存指令，分割指令
//从文件读入所有的32位指令，并储存，根据输入的
//地址选择对应的指令输出。输出后将指令传给其他部分进行处理
`timescale 1ns / 1ns
module insMEM(
    input RW,  //读写控制信号，1为写，0为读
    input[31:0] IAddr,  // 指令地址输入入口
    output reg[31:0] IDataOut
);
    reg[7:0] instruction[0:127]; // 新建一个32位的数组用于储存指令
    initial begin
      $readmemh("input.txt",instruction);//modelsim仿真只需写project文件夹下的文件名
    end
    // 从地址取值，然后输出
    //切割成8位读
    always@(RW or IAddr)begin
      if(RW)begin  //当RW控制信号为1时读取指令
        IDataOut[31:24]=instruction[IAddr];
        IDataOut[23:16]=instruction[IAddr+1];
        IDataOut[15:8]=instruction[IAddr+2];
        IDataOut[7:0]=instruction[IAddr+3];
      end
    end
endmodule