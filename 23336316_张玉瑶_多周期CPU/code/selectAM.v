
module selectAM(
    input [31:0] dataFromALU, dataFromM,
    input DBDataSrc,
    output wire[31:0] dataout
    );
    
    assign dataout=(DBDataSrc)?dataFromM:dataFromALU;
endmodule
