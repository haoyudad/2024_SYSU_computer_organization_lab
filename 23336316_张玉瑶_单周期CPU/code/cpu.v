
module CPU1(
        input CLK,
        input Reset,
        output[4:0]rt,rs,
        output wire [5:0]Opcode,
        
        output wire [31:0] ra,rb, currentPC, nextpc, result, DBData//,instruction
);
        wire [5:0]funct;
        wire [2:0] ALUOp;
        wire [3:0] aluop2;
        wire [31:0]immediateExt;
        wire [31:0]dataout;//是datamem出来的内容
        wire [15:0]immediate;
        wire [4:0]rd;
        wire[4:0]shamt;
        wire [31:0]jumppc;
        wire zero,sign, PCWre,ALUSrcA,ALUSrcB,DBDataSrc,RegWre;
        wire InsMemRW,mRD,mWR,Exsel,RegDst;
        wire [1:0] PCSrc;
        wire [3:0]PC4;
        
        //各模块实例化
 

         pc pc_inst (
        .PCSrc(PCSrc),        // PCSrc 信号决定 PC 的选择
        .CLK(CLK),            // 时钟信号
        .PCWre(PCWre),        // 控制 PC 写使能
        .immediate(immediate),// branch 的偏移量
        .jumppc(jumppc),      // 跳转地址
        .Reset(Reset),        // 复位信号
        .currentPC(currentPC),// 当前 PC
        .nextpc(nextpc),      // 下一 PC
        .pc4(PC4)             // 当前 PC 的低 4 位
    );

    ctr ctr_inst (
        .opCode(Opcode),
        .zero(zero),
        .sign(sign),
        .PCWre(PCWre),
        .ALUsrcB(ALUSrcB),
        .DBDataSrc(DBDataSrc),
        .RegWre(RegWre),
        .InsMemRW(InsMemRW),
        .mRD(mRD),
        .mWR(mWR),
        .RegDst(RegDst),
        .ExtSel(Exsel),  // ExtSel 连接
        .PCSrc(PCSrc),
        .aluop(aluop2)
    );
        aluctr alu_control_inst (
        .aluop(aluop2),
        .funct(funct),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA)
    );
        ALU alu_instance (
        .ra(ra),            // Connect ra signal from CPU1
        .rb(rb),            // Connect rb signal from CPU1
        .shamt(shamt),      // Connect shamt signal from CPU1
        .immediateExt(immediateExt), // Connect immediateExt from CPU1
        .ALUOp(ALUOp),      // ALU operation code (3-bit control signal)
        .ALUSrcA(ALUSrcA),  // ALU source A selector
        .ALUSrcB(ALUSrcB),  // ALU source B selector
        .result(result),     // ALU result
        .zero(zero) ,        // Zero flag output from ALU
        .sign(sign)
    );
       DataMemory u_dataMemory(
        .CLK(CLK),
        .mWR(mWR),
        .mRD(mRD),
        .raAddIm(result),  // 可能需要确认是否为`result`作为地址输入
        .datain(rb),  // 这里我们假设写入数据是`rb`
        .dataout(dataout)
    );
        InstructionMemory u_instMem(
        .pc4(PC4),
        .funct(funct),
        .InsMemRW(InsMemRW),
        .currentPC(currentPC),
        .op(Opcode),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .immediate(immediate),
        .jumppc(jumppc)
    );
       
        RegFile u_RegFile (
        .CLK(CLK),              // 连接时钟信号
        .RegDst(RegDst),        // 连接 RegDst 控制信号
        .RegWre(RegWre),        // 连接 RegWre 控制信号
        .DBDataSrc(DBDataSrc),  // 连接 DBDataSrc 控制信号
        .rs(rs),                // 连接源寄存器 rs 地址
        .rt(rt),                // 连接源寄存器 rt 地址
        .rd(rd),                // 连接目标寄存器 rd 地址
        .dataFromALU(result), // 连接 ALU 输出数据
        .dataFromM(dataout),     // 连接内存输出数据
        .busA(ra),            // 连接读出的 busA 数据
        .busB(rb),            // 连接读出的 busB 数据
        .writeData(DBData)   // 连接写入寄存器的数据
    );

        
        SignZeroExt u_signZeroExt(
        .immediate(immediate),
        .Extsel(Exsel),
        .ext(immediateExt)
    );
endmodule
