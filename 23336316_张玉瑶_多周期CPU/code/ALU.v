module ALU(//..
        input [31:0]ra,
        input [31:0]rb,
        input [4:0]shamt,
        input [31:0]immediateExt,
        input [2:0]ALUOp,
        input ALUSrcA,//选择器，控制信号
        input ALUSrcB,
        
        output reg[31:0]result,
      //  output sign,
        output zero   
);

        wire [31:0]inputa;
        wire [31:0]inputb;
        
        assign inputa=ALUSrcA? {{27{1'b0}},shamt}:ra;
        assign inputb=ALUSrcB? immediateExt : rb;
      //  assign sign=result<0 ? 1:0;//非负数为0，负数1
        assign zero=(result==32'b0)? 1:0;
        
        always@(*)begin
            case(ALUOp)
                3'b000://+
                    result=inputa+inputb;
                3'b001://-
                    result=inputa-inputb;
                3'b010://<<
                    result=inputb<<inputa;
                3'b011:
                    result=inputa|inputb;
                3'b100:
                    result=inputa&inputb;
                3'b101:
                    result=inputa<inputb?1:0;
                3'b110:
                    result=(((inputa< inputb) && ( inputa[31] ==  inputb[31] )) ||( (  inputa[31] ==1 &&  inputb[31] == 0))) ? 1:0;
                3'b111:
                    result=inputa^~inputb;
                default:
                result = 32'h0000;
            endcase
        end
  endmodule