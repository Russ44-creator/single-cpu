`timescale 1ns/1ns 
module Top(
    input CLK,
    input Reset,
    output[31:0] PCout, //当前指令
    output[31:0] PCin,  //下一条指令
    output[4:0] reg1_addr,  //寄存器组1编号
    output[31:0] ReadData1,
    output[4:0] reg2_addr,
    output[31:0] ReadData2,
    output[31:0] result,
    output[31:0] DataOut //DataMemory的输出
);
    wire PCWre;
    wire ALUSrcA;
    wire ALUSrcB;
    wire DBDataSrc; //0：来自 ALU 运算结果的输出，相关指令，1：来自数据存储器（Data MEM）的输出
    wire RegWre;
    wire InsMemRW;
    wire mRD;
    wire mWR;
    wire RegDst;
    wire ExtSel;
    wire[2:0] ALUOp;
    wire[1:0] PCSrc;
    wire[31:0] IDataOut;
    wire[4:0] WriteRegIn;
    wire[31:0] DB;
    wire[31:0] ALUAin;
    wire[31:0] ALUBin;
    wire zero;
    wire sign;
    wire ifNeedOf;
    wire overflow;
    wire[31:0] ExtendOut;

    assign reg1_addr=IDataOut[25:21]; //指令存储器数据输出端口
    assign reg2_addr=IDataOut[20:16];

    controlUnit controlUnit_(PCWre,ALUSrcA,ALUSrcB,DBDataSrc,RegWre,InsMemRW,mRD,mWR,RegDst,ExtSel,ALUOp,PCSrc,zero,IDataOut[31:26],IDataOut[5:0],overflow,ifNeedof,sign);
    ALU ALU_(ALUAin, ALUBin, ALUOp, ifNeedOf, sign, zero, overflow, result);
    PC PC_(PCWre,PCin,CLK,Reset,PCout);
    PCchoose PCchoose_(PCSrc,ExtendOut,PCout,IDataOut,PCin);
    signzeroextend signzeroextend_(IDataOut[15:0],ExtSel,ExtendOut);  
    RegisterFile RegisterFile_(CLK,RegWre,IDataOut[25:21],IDataOut[20:16],WriteRegIn,DB,ReadData1,ReadData2);
    Mux32 Mux32_4(DBDataSrc,result,DataOut,DB);
    Mux32 Mux32_2(ALUSrcA,ReadData1,{27'b000000000000000000000000000,IDataOut[10:6]},ALUAin); //rs 寄存器数据输出端口
    Mux32 Mux32_3(ALUSrcB,ReadData2,ExtendOut,ALUBin); //rt 寄存器数据输出端口
    Mux5 Mux5_1(RegDst,IDataOut[20:16],IDataOut[15:11],WriteRegIn);
    DataMem DataMem_(CLK,mRD,mWR,result,ReadData2,DataOut);
    insMEM insMEM_(InsMemRW,PCout,IDataOut);
endmodule
