module control_unit(
    input [5:0] opCode, funct,
    input zero,CLK,reset, 
    output reg PCWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, WrRegDSrc, InsMemRW, mRD, mWR, IRWre, ExtSel,
    output reg [1:0] PCSrc, RegDst,
    output reg [2:0] ALUOp,state
);
    reg [2:0] nowstate;
    reg [2:0] nextstate;

    always@(posedge CLK) begin
        if (reset == 0) begin
            nowstate = 3'b000;
        end
        else begin
            nowstate = nextstate;
        end
        state = nowstate;
    end

    always@(*) begin
        case(nowstate)
            3'b000: nextstate = 3'b001;
            3'b001: begin
                nextstate[0] = (opCode == 6'b000100 || opCode == 6'b000101 || opCode == 6'b000001) ? 1 : 0;
                nextstate[1] = (opCode == 6'b000100 || opCode == 6'b000101 || opCode == 6'b000001 ||
                               opCode == 6'b000010 || opCode == 6'b000011 || opCode == 6'b111111 ||
                               (opCode == 6'b000000 && funct == 6'b001000)) ? 0 : 1;
                nextstate[2] = (opCode == 6'b000010 || opCode == 6'b000011 || opCode == 6'b111111 ||
                               (opCode == 6'b000000 && funct == 6'b001000) || opCode == 6'b101011 || opCode == 6'b100011) ? 0 : 1;
            end
            3'b010: nextstate = 3'b011;
            3'b011: nextstate = (opCode == 6'b100011) ? 3'b100 : 3'b000;
            3'b100: nextstate = 3'b000;
            3'b101: nextstate = 3'b000;
            3'b110: nextstate = 3'b111;
            3'b111: nextstate = 3'b000;
        endcase
    end

    always@(*) begin
        PCWre = (nowstate == 3'b111 || nowstate == 3'b100 ||
                 nowstate == 3'b101 || (nowstate == 3'b011 && opCode == 6'b101011) ||
                 (nowstate == 3'b001 && (opCode == 6'b000010 || opCode == 6'b000011 ||
                                         (opCode == 6'b000000 && funct == 6'b001000)))) ? 1 : 0;
        InsMemRW = 1;
        ALUSrcA = (nowstate == 3'b110 && (opCode == 6'b000000 && funct == 6'b000000)) ? 1 : 0;
        DBDataSrc = (nowstate == 3'b100 && opCode == 6'b100011) ? 1 : 0;
        RegWre = (nowstate == 3'b111 || nowstate == 3'b100 || 
                  (nowstate == 3'b001 && opCode == 6'b000011)) ? 1 : 0;
        WrRegDSrc = (nowstate == 3'b001 && opCode == 6'b000011) ? 0 : 1;
        InsMemRW = 1;
        mRD = 1;
        mWR = (nowstate == 3'b011 && opCode == 6'b101011) ? 1 : 0;
        IRWre = (nowstate == 3'b000) ? 1 : 0;
        ExtSel = (nowstate == 3'b000 || nowstate == 3'b010 || nowstate == 3'b101 ||
                  opCode == 6'b001010 || opCode == 6'b001001) ? 1 : 0;

        ALUSrcB = (nowstate == 3'b010 || (nowstate == 3'b110 &&
                                          (opCode == 6'b001001 || opCode == 6'b001010 || 
                                           opCode == 6'b001100 || opCode == 6'b001101 || 
                                           opCode == 6'b001110))) ? 1 : 0;
        case(opCode)
            6'b000011: RegDst = 2'b00;
            6'b000000: RegDst = 2'b10;
            default: RegDst = 2'b01;
        endcase
        case(nowstate)
            3'b010: ALUOp = 3'b000;
            3'b101: ALUOp = 3'b001;
            3'b110: begin
                ALUOp[0] = ((opCode == 6'b000000 && (funct == 6'b100010 || funct == 6'b101010 || funct == 6'b100101)) ||
                            opCode == 6'b001101 || opCode == 6'b001110) ? 1 : 0;
                ALUOp[1] = (opCode == 6'b001101 || opCode == 6'b001110 || opCode == 6'b001010 ||
                            (opCode == 6'b000000 && (funct == 6'b100101 || funct == 6'b000000))) ? 1 : 0;
                ALUOp[2] = (opCode == 6'b001100 || opCode == 6'b000001 ||
                            (opCode == 6'b000000 && (funct == 6'b100100 || funct == 6'b101010)) ||
                            opCode == 6'b001010) ? 1 : 0;
            end
        endcase
    end

    always@(*) begin
        case(opCode)
            6'b000010: PCSrc = 2'b11;
            6'b000011: PCSrc = 2'b11;
            6'b000000: PCSrc = (funct == 6'b001000) ? 2'b10 : 2'b00;
            6'b000100: PCSrc = (nowstate == 3'b101 && zero == 0) ? 2'b01 : 2'b00;
            6'b000101: PCSrc = (nowstate == 3'b101 && zero == 1) ? 2'b01 : 2'b00;
            6'b000001: PCSrc = (nowstate == 3'b101 && zero == 1) ? 2'b01 : 2'b00;
            default: PCSrc = 2'b00;
        endcase
    end
endmodule
