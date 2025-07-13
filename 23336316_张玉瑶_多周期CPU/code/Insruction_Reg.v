module Instuction_Reg(
    input IR_CLK,RW,
    input [31:0] address,datain,
    output reg [31:0] dataout
    );

    reg [31:0] data;
    reg [7:0] mem [0:127];

    initial begin
        $readmemb("C:/Users/zhang/Desktop/Instruction2.txt", mem); // 从文件中读取指令集
        dataout = 0;
    end

    always @(address or RW)
    if (RW == 1) begin
        data[31:24] = mem[address];
        data[23:16] = mem[address + 1];
        data[15:8] = mem[address + 2];
        data[7:0] = mem[address + 3];
    end

    always @(negedge IR_CLK) begin
        dataout <= data;
    end

endmodule
