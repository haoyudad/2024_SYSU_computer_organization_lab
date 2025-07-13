
module DataMemory(//mRD,mWR
        input CLK,
        input mWR,//写使能 0写
        input mRD,//读0
        input wire [31:0]raAddIm,//lw,sw指令中输入的为ra+im,还没有乘以四,输入到address,cpu里应该是result吧
        input wire [31:0]datain,//sw时使用，输入为要写入的寄存器的地址，应该是rs，所以接口应该是ra，好像那个实验报告有问题
        
        output wire[31:0]dataout      
    );
    //内存体
    reg [7:0]memory[0:127];//按字节编址，128个字节
    wire[31:0]address;
    
    assign address=(raAddIm<<2); //*4
    
    //read,这是大端吗
    
    
    always@(negedge CLK) begin
        if(mWR==1) begin
            memory[address]<=datain[31:24];
            memory[address+1]<=datain[23:16];
            memory[address+2]<=datain[15:8];
            memory[address+3]<=datain[7:0];
        end
    end
    
    assign dataout[7:0] = mRD==1 ? memory[address+3]:8'bz;
    assign dataout[15:8]= mRD==1 ? memory[address+2]:8'bz;
    assign dataout[23:16]= mRD==1 ? memory[address+1]:8'bz;
    assign dataout[31:24]= mRD==1 ? memory[address]:8'bz;
endmodule