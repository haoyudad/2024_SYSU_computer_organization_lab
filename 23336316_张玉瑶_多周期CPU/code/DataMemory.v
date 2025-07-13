
//module DataMemory(
//     input mWR,
//     input mRD,
//     input [31:0] raAddIm,
//     input [31:0] datain,
//     output reg [31:0] dataout
//);
//    reg [7:0] mem[0:127];
//    wire Add = raAddIm << 2;

//    always @(*) begin
//        if (mRD == 1) begin
//            dataout[31:24] = mem[Add]; 
//            dataout[23:16] = mem[Add + 1];  
//            dataout[15:8]  = mem[Add + 2];  
//            dataout[7:0]   = mem[Add + 3];   
//        end else begin
//            dataout = 32'bz;  
//        end
//    end

//    always @(*) begin
//        if (mWR == 1) begin
//            mem[Add] <= datain[31:24];
//            mem[Add + 1] <= datain[23:16];
//            mem[Add + 2] <= datain[15:8];
//            mem[Add + 3] <= datain[7:0];
//        end
//    end

//endmodule

    
module DataMemory(//mRD,mWR
        input CLK,
        input mWR,//写使能 0写
        input mRD,//读0
        input wire [31:0]raAddIm,//lw,sw指令中输入的为ra+im,还没有乘以四,输入到address,cpu里应该是result吧
        input wire [31:0]datain,//sw时使用，输入为要写入的寄存器的地址，应该是rs，所以接口应该是ra，好像那个实验报告有问题
        
        output wire[31:0]dataout      
    );
    //内存体
    reg [7:0]mem[0:127];//按字节编址，128个字节
    wire[31:0]address;
    
    assign address=(raAddIm<<2); //*4
    
    //read,这是大端吗
    
    
    always@(negedge CLK) begin
        if(mWR==1) begin
            mem[address]<=datain[31:24];
            mem[address+1]<=datain[23:16];
            mem[address+2]<=datain[15:8];
            mem[address+3]<=datain[7:0];
        end
    end
    
    assign dataout[7:0] = mRD==1 ? mem[address+3]:8'bz;
    assign dataout[15:8]= mRD==1 ? mem[address+2]:8'bz;
    assign dataout[23:16]= mRD==1 ? mem[address+1]:8'bz;
    assign dataout[31:24]= mRD==1 ? mem[address]:8'bz;
endmodule
  