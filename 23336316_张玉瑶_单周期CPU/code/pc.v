module pc(  // PCWre，PCSrc，Reset我没写
    input [1:0] PCSrc,         // 输出选择何种pc, x1 bra, 10 jump, 00 pc+4
    input CLK,
    input PCWre,
    input signed [15:0] immediate,
    input [31:0] jumppc,
    input Reset,

    output reg signed [31:0] currentPC, // 当前pc
    output [31:0] nextpc,
    output [3:0] pc4
);
    // 计算下一个PC值
    assign nextpc = PCSrc[0] ? (currentPC + (immediate << 2)) : 
                    (PCSrc[1] ? jumppc : currentPC + 4);
    assign pc4 = currentPC[31:28];


    always @(negedge CLK or negedge Reset) begin
        if (Reset == 0)
            currentPC <= 0;
        else if (PCWre == 1) begin  // pc 可写
            if (PCSrc == 2'b00)       // pc+4
                currentPC <= currentPC + 4;
            else if (PCSrc == 2'b01)  // branch
                currentPC <= currentPC + (immediate << 2) + 4;
            else if (PCSrc == 2'b10)  // jump
                currentPC <= jumppc;
        end
    end   
endmodule