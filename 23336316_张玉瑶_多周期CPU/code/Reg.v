module Reg(
    input wire[31:0] in,
    input wire clk,
    output reg[31:0] out
    );
    always @(posedge clk) begin
        out <= in;
    end
endmodule
