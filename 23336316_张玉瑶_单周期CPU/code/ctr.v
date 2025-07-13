

module ctr(//主控，产生控制信号和aluctr
    input [5:0] opCode, 
    input zero,
    input sign,
    output reg PCWre,
    output reg ALUsrcB,
    output reg DBDataSrc,
    output reg RegWre,
    output reg InsMemRW,
    output reg mRD,
    output reg mWR,
    output reg RegDst,
    output reg ExtSel,//符号扩展方式，1 为 sign-extend，0 为 zero-extend
    output reg [1:0]PCSrc,
    
    output reg [3:0] aluop // 经过 ALU 控制译码决定 ALU 功能,为内部信号
    
);
initial begin
    PCWre=1;  ALUsrcB=1;  DBDataSrc=0;  RegWre=1; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=0;  ExtSel=1;  PCSrc[1:0]=2'b00;  
    aluop = 4'b0000;
    end
  
    always@(*) begin
    // 操作码改变时改变控制信号 
    case(opCode) 
    6'b000010: begin
     PCWre=1;  ALUsrcB=1'bz;   DBDataSrc=1'bz;   RegWre=0;   InsMemRW=1;  
     mRD=0;  mWR=0;   RegDst=1'bz;   ExtSel=1'bz;   PCSrc=2'b10; 
    aluop = 4'b0000;
    end // 'J 型' 指令操作码: 000010，无需 ALU
    
    6'b000000: begin
    PCWre=1; ALUsrcB=0;  DBDataSrc=0;  RegWre=1; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=1;  ExtSel=1'bz;  PCSrc[1:0]=2'b00; // ALUOp[2:0]=3'bz;
    aluop = 4'b1111;
    end // 'R 型' 指令操作码: 000000,sll除外，alusrca=1；
    
    //'I'型指令操作码
    6'b100011: begin
    PCWre=1;  ALUsrcB=1;  DBDataSrc=1;  RegWre=1; InsMemRW=1;
    mRD=1;  mWR=0;  RegDst=0;  ExtSel=1;  PCSrc[1:0]=2'b00; 
    aluop = 4'b0000; 
    end // 'lw' 指令操作码: 100011
    
    6'b101011: begin
    PCWre=1; ALUsrcB=1;  DBDataSrc=0;  RegWre=0; InsMemRW=1;
    mRD=0;  mWR=1;  RegDst=1'bz;  ExtSel=1;  PCSrc[1:0]=2'b00; 
    aluop = 4'b0000;
    end // 'sw' 指令操作码: 101011
    
    6'b000100: begin
    PCWre=1; ALUsrcB=0;  DBDataSrc=1'bz;  RegWre=0; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=1'bz;  ExtSel=1;  
    PCSrc[1:0]=zero==1? 2'b01:2'b00;
    aluop = 4'b0001;
    end // 'beq' 指令操作码: 000100
    
    6'b000101: begin
    PCWre=1; ALUsrcB=0;  DBDataSrc=1'bz;  RegWre=0; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=1'bz;  ExtSel=1; 
    PCSrc[1:0]=zero==0? 2'b01:2'b00;  
    aluop = 4'b0110; 
    end // 'bne' 指令操作码: 000101
    

    6'b000110: begin
    PCWre=1; ALUsrcB=0;  DBDataSrc=1'bz;  RegWre=0; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=1'bz;  ExtSel=1;  
    PCSrc[1:0]=(zero==1||sign==1)? 2'b01:2'b00;  
    aluop = 4'b0101; //???op要改
    end // 'blez' 指令操作码: 000101
    
    6'b001001: begin
    PCWre=1;  ALUsrcB=1;  DBDataSrc=0;  RegWre=1; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=0;  ExtSel=1;  PCSrc[1:0]=2'b00;  
    aluop = 4'b0000;
    end // 'addiu' 指令操作码: 001000
    
    6'b001100: begin
    PCWre=1; ALUsrcB=1;  DBDataSrc=0;  RegWre=1; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=0;  ExtSel=0;  PCSrc[1:0]=2'b00;  
    aluop = 4'b0100;
    end // 'andi' 指令操作码: 001100
    
    6'b001101: begin
    PCWre=1; ALUsrcB=1;  DBDataSrc=0;  RegWre=1; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=0;  ExtSel=0;  PCSrc[1:0]=2'b00;  
    aluop = 4'b0010; 
    end // 'ori' 指令操作码: 001101

     
    6'b001010: begin
    PCWre=1; ALUsrcB=1;  DBDataSrc=0;  RegWre=1; InsMemRW=1;
    mRD=0;  mWR=0;  RegDst=0;  ExtSel=1;  PCSrc[1:0]=2'b00; 
    aluop = 4'b0011;
    end // 'slti' 指令操作码: 001010
    
    6'b111111: begin
    //pc保持不变
    PCWre=0; ALUsrcB=1'bz;  DBDataSrc=1'bz;  RegWre=1'bz; InsMemRW=1'bz;
    mRD=1'bz;  mWR=1'bz;  RegDst=1'bz;  ExtSel=1'bz;  PCSrc[1:0]=2'bz; 
    end // 'halt' 指令操作码: 111111
    
    default: begin
    PCWre=1'b1; ALUsrcB=1'b1;  DBDataSrc=1'b1;  RegWre=1'b1; InsMemRW=1'bz;
    mRD=1'bz;  mWR=1'bz;  RegDst=1'bz;  ExtSel=1'bz;  PCSrc[1:0]=2'bz; 
    end // 默认设置
    endcase end
endmodule