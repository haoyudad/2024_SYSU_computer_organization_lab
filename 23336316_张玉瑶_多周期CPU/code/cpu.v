module cpu(
    input CLK, reset,
    output [4:0] rs, rt,
    output wire [5:0] opCode,
    output wire [31:0] Out1, Out2, currentPC, Result, DBData,
    output wire[2:0] state
);
    wire PCWre;
    wire [31:0] imext;
    wire [31:0] jumppc;
    wire [31:0] jrpc;
    wire [1:0] PCSrc;
    
    wire IRWre;
    wire InsMemRW;
    wire [31:0] Insdataout;

    wire [5:0] funct;
    wire [4:0] rd;
    wire [15:0] imm;
    wire [4:0] shamt;
    wire [25:0] target;

    wire zero;
    wire ALUSrcA;
    wire ALUSrcB;
    wire DBDataSrc;
    wire RegWre;
    wire WrRegDSr;
    wire mRD;
    wire mWR;
    wire [1:0] RegDst;
    wire [2:0] ALUOp;
    wire ExtSel;
    
    wire [31:0] regdatain;
    
    wire [31:0] regoutA;
    wire [31:0] regoutB;
    wire [31:0] aludata;
    
    wire [31:0] memd;
    
    selectAM se(
        .dataFromALU(Result),
        .dataFromM(memd),
        .DBDataSrc(DBDataSrc),
        .dataout(regdatain)
    );

    DataMemory mem( 
        .mWR(mWR),
        .mRD(mRD),
        .raAddIm(Result),
        .datain(regoutB),
        .dataout(memd)
    );
    
    ALU alu(
        .shamt(shamt),
        .immediateExt(imext),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ra(regoutA), .rb(regoutB), .ALUOp(ALUOp),
        .result(aludata),
        .zero(zero)
    );
    
    Reg alureg(
        .in(aludata),
        .clk(CLK),
        .out(Result)
    );
    
    SignZeroExt ex(
        .immediate(imm),
        .Extsel(ExtSel),
        .ext(imext)
    );
    
    Reg reg_outA(
        .in(Out1),
        .clk(CLK),
        .out(regoutA)
    );

    Reg reg_outB(
        .in(Out2),
        .clk(CLK),
        .out(regoutB)
    );
    
    RegFile re(
        .DBDataSrc(WrRegDSrc),
        .datain(regdatain),
        .pc(currentPC + 4),
        .CLK(CLK),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .RegDst(RegDst),
        .RegWre(RegWre),
        .busA(Out1),
        .busB(Out2),
        .W_data(DBData)
    );

    control_unit co(
        .opCode(opCode),
        .funct(funct),
        .zero(zero),
        .CLK(CLK),
        .reset(reset),
        .PCWre(PCWre),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .DBDataSrc(DBDataSrc),
        .RegWre(RegWre),
        .WrRegDSrc(WrRegDSrc),
        .InsMemRW(InsMemRW),
        .mRD(mRD), .mWR(mWR), .IRWre(IRWre), .ExtSel(ExtSel),
        .PCSrc(PCSrc), .RegDst(RegDst), .ALUOp(ALUOp), .state(state)
    );

    PCAdd pcadd(
        .jumppc(jumppc),
        .currentPC(currentPC),
        .target(target)
    );

    IR_Reg ir(
        .CLK(CLK),
        .RW(IRWre),
        .datain(Insdataout),
        .opCode(opCode),
        .funct(funct),
        .rs(rs),
        .rt(rt), .rd(rd), .shamt(shamt),
        .immediate(imm),
        .target(target)
    );

    Instuction_Reg in(
        .IR_CLK(CLK),
        .address(currentPC),
        .RW(InsMemRW),
        .dataout(Insdataout)
    );

    pc pc(
        .CLK(CLK),
        .Reset(reset),
        .PCWre(PCWre),
        .PCSrc(PCSrc),
        .immediate(imext),
        .jumppc(jumppc),
        .out1(Out1),
        .currentPC(currentPC)
    );
    
endmodule
