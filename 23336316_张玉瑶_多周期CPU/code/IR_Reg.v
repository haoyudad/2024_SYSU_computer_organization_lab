

module IR_Reg(
    input CLK,RW,
    input [31:0] datain,
    output reg [31:0] dataout,
    output reg [5:0] opCode,funct,
    output reg [4:0] rs,rt,rd,shamt,
    output reg [15:0] immediate,
    output reg [25:0] target
    );

    always @(posedge CLK) begin
        if (RW == 1) begin
            dataout = datain;
            opCode = datain[31:26];
            rs = datain[25:21];
            rt = datain[20:16];
            rd = datain[15:11];
            shamt = datain[10:6];
            funct = datain[5:0];
            immediate = datain[15:0];
            target = datain[25:0];
        end
    end

endmodule
