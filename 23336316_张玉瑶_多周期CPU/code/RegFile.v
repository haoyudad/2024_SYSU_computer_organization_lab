
module RegFile(//控制信号：RegWre，RegDst，DBDataSrc
        input CLK ,RegWre, DBDataSrc,
        input [1:0]RegDst,
        input [4:0] rs, rt, rd,
        //input [31:0] dataFromALU, dataFromM,
        input [31:0]datain,
        input [31:0]pc,
        output reg[31:0] busA,busB,
        output [31:0] W_data
);
       
       reg [4:0]writeReg;//写入寄存器的编号
       wire [31:0]m_data;
       reg [31:0] register[0:31];
       integer i;
       initial begin
            for(i = 0;i < 32; i=i+1 )  
                register[i] = 32'b0;
       end
       //判断指令类型
       assign m_data= DBDataSrc==1?datain:pc;
       assign W_data  =m_data;
        always @(negedge CLK) begin
             case(RegDst)
             2'b00:writeReg=5'b11111;
             2'b01:writeReg=rt;
             2'b10:writeReg=rd;
        endcase
             if (RegWre == 1)  
             register[writeReg] <= m_data;  
             busA <= register[rs];  
             busB <= register[rt]; 
        end
    endmodule