 module SignZeroExt(//¿ØÖÆÐÅºÅ£ºExtsel
      input  [15:0] immediate,
      input Extsel,//1sign00
      output [31:0]ext
);
        assign ext[15:0] = immediate[15:0];
        assign ext[31:16] = Extsel ? {16{immediate[15]}} : 16'b0;
    
endmodule
