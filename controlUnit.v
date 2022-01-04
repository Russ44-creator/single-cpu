`timescale 1ns / 1ns
module controlUnit( 
	output PCWre,  //PC是否更改，如果为0，PC不改
    output ALUSrcA, //多路选择器，0：来自寄存器堆data1输出，1：指令：sll
    output ALUSrcB,  //多路选择器，0：来自寄存器堆data2输出，1：来自sign或zero扩展的立即数
    output DBDataSrc, //0：来自ALU运算结果的输出，1：数据存储器（data mem）的输出，lw
    output RegWre,  //(RF)写使能信号，为1时，在时钟上升沿写入
    output InsMemRW, // (IM)读写控制信号，0：写指令存储器，1：读指令存储器
    output mRD,   //0：输出高阻态，1：读数据存储器，相关指令：lw
    output mWR, //）：无操作，1：写数据存储器，相关指令：sw
    output RegDst,  //多路选择器，0：rt字段，1：rd字段
    output ExtSel, // (EXT)控制补位，如果为1，进行符号扩展，如果为0，全补0
    output[2:0] ALUOp, // (ALU)ALU操作控制，8种运算功能选择
    output[1:0] PCSrc, //00：pc+4,01:beq,bne,bltz,10:j,11:无用
    input zero, // ALU的zero输出
    input[5:0] OP, // op操作符
    input[5:0] func,
    input overflow, //判断溢出
    output ifNeedOf,
    input sign 
    );	
    parameter Rtype=6'b000000, addiu=6'b001001, andi=6'b001100, ori=6'b001101, slti=6'b001010, sw=6'b101011, lw=6'b100011, beq=6'b000100, bne=6'b000101, bltz=6'b000001, j=6'b000010, halt=6'b111111;
    parameter add=6'b100000, addu = 6'b100001, sub=6'b100010, and_=6'b100100, or_=6'b100101, nor_ = 6'b100110, sll=6'b000000;
    
    //按照真值表来写出控制单元模块
    assign PCWre=(OP!=halt);
    assign ALUSrcA=(OP==Rtype&&func==sll);
    assign ALUSrcB=(OP==addiu||OP==andi||OP==ori||OP==slti||OP==sw||OP==lw);
    assign DBDataSrc=(OP==lw);
    assign RegWre=( OP!=sw && OP!=beq && OP!=bne && OP!=bltz && OP!=j && OP!=halt);
    assign InsMemRW=1;
    assign mRD=(OP==lw);
    assign mWR=(OP==sw);
    assign RegDst=(OP==Rtype);
    assign ExtSel=(OP!=andi&&OP!=ori);
    assign ALUOp[0]=(OP==Rtype&&func==sub||OP==Rtype&&func==or_||OP==ori||OP==beq||OP==bne||OP==bltz||OP==Rtype&&func==nor_||OP==Rtype&&func==addu);
    assign ALUOp[1]=(OP==Rtype&&func==or_||OP==ori||OP==Rtype&&func==sll||OP==slti||OP==Rtype&&func==nor_);
    assign ALUOp[2]=(OP==andi||OP==Rtype&&func==and_||OP==slti||OP==Rtype&&func==nor_||OP==Rtype&&func==addu);
    assign PCSrc[0]=(OP==beq&&zero==1||OP==bne&&zero==0||OP==bltz&&sign==1||OP==halt);
    assign PCSrc[1]=(OP==j||OP==halt);
    assign ifNeedOf=(OP==add||OP==sub); //溢出
endmodule
