module aluctr(
    input [3:0] aluop,
    input [5:0] funct,
    output reg [2:0] ALUOp,
    output reg ALUSrcA
);

    initial begin
        ALUOp = 3'b000;
        ALUSrcA = 0;
    end

    always @(aluop or funct) begin
        casez({aluop, funct})
            // i 型指令
            10'b0000??????: begin
                ALUOp = 3'b000; // add
                ALUSrcA = 0;
            end
            // lw, sw, addiu
            10'b0001??????: begin
                ALUOp = 3'b001; // beq
                ALUSrcA = 0;
            end
            // bne, beq
            10'b0101??????: begin
                ALUOp = 3'b101; // beq
                ALUSrcA = 0;
            end
            // blez
            10'b0110??????: begin
                ALUOp = 3'b001; // bne
                ALUSrcA = 0;
            end
            10'b0010??????: begin
                ALUOp = 3'b011; // ori
                ALUSrcA = 0;
            end
            10'b0011??????: begin
                ALUOp = 3'b110; // slti
                ALUSrcA = 0;
            end
            10'b0100??????: begin
                ALUOp = 3'b100; // andi
                ALUSrcA = 0;
            end

            // r 型指令
            10'b1111100000: begin
                ALUOp = 3'b000; // add
                ALUSrcA = 0;
            end
            10'b1111100010: begin
                ALUOp = 3'b001; // sub
                ALUSrcA = 0;
            end
            10'b1111100100: begin
                ALUOp = 3'b100; // and
                ALUSrcA = 0;
            end
            10'b1111100101: begin
                ALUOp = 3'b011; // or
                ALUSrcA = 0;
            end
            10'b1111000000: begin
                ALUOp = 3'b010; // sll
                ALUSrcA = 1;
            end

            default: begin
                ALUOp = 3'b000;
                ALUSrcA = 0;
            end
        endcase
    end

endmodule