module RegFile(//控制信号：RegWre，RegDst，DBDataSrc
        input CLK, RegDst, RegWre, DBDataSrc,
        input [4:0] rs, rt, rd,
        input [31:0] dataFromALU, dataFromM,

        output [31:0] busA,busB,
        output [31:0] writeData
);
       wire [4:0]writeReg;//写入寄存器的编号
       
       assign writeReg = RegDst ? rd : rt;
       assign writeData = DBDataSrc ? dataFromM : dataFromALU;
       
       reg [31:0] register[0:31];
       integer i;
       initial begin
            for(i = 0;i < 32; i=i+1 )  
                register[i] <= 32'b0;
       end
       //判断指令类型
       
       assign busA = register[rs];
       assign busB = register[rt];
       
       always@(negedge CLK)begin
           if(RegWre && writeReg)begin
               register[writeReg] <= writeData;               
           end       
       end
  endmodule