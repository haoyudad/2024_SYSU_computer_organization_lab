
module InstructionMemory(//InsMemRW
        input [3:0]pc4,//这个不就是指令地址吗
        input InsMemRW,//0写1读,本来是rw
        
        input [31:0]currentPC,//pc来的吗
        
        output [5:0]op,
        output [4:0]rs,
        output [4:0]rt,
        output [4:0]rd,
        output [4:0]shamt,
        output [15:0]immediate,
        output [5:0]funct,
        output [31:0]jumppc 
        //output [31:0]dataout   
    );
        reg [7:0]mem[0:127];
        reg [31:0] instruction;//指令
        
        assign op=instruction[31:26];
        assign rs=instruction[25:21];
        assign rt=instruction[20:16];
        assign rd=instruction[15:11];
        assign immediate=instruction[15:0];
        assign shamt=instruction[10:6];
        assign funct=instruction[5:0];
        assign jumppc={{pc4},{instruction[25:0]},{2'b00}};
        
        

        // 读取指令的过程
 initial begin
    $readmemb("C:/Users/zhang/Desktop/Instructions.txt", mem);//从文件中读取指令集
  //  dataout = 0;//指令初始化
end
        
        always@(*)begin
            if(InsMemRW==1)begin
                instruction[7:0]=mem[currentPC+3];
                instruction[15:8]=mem[currentPC+2];
                instruction[23:16]=mem[currentPC+1];
                instruction[31:24]=mem[currentPC];
            end
         end
         

endmodule