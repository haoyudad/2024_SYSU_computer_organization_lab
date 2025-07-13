
module PCAdd(
    input [25:0] target,
    input [31:0] currentPC,
    output reg[31:0] jumppc
    );
    always@(*)begin
        jumppc<={currentPC[31:28],target[25:0],2'b00};
    end
endmodule