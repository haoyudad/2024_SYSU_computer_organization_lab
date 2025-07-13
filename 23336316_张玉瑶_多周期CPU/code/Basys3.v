
module Basys3(
    input CLKButton,
    input BasysCLK,
    input RST_Button,
    input [1:0] SW_in,
    output [7:0]SegOut,
    output [3:0]Bits
   
);

    wire cpuCLK;
    wire [31:0] PCdataout;
    wire [31:0] ALUresult;
    wire [5:0] Inop;
    wire [4:0] Inrs, Inrt;
    wire [15:0] Inimmediate;
    wire [31:0] reg_dataA, reg_dataB;
    wire [31:0]DBData;
    wire [2:0]state;

cpu co(.CLK(cpuCLK),.reset(RST_Button),
.rs( Inrs),.rt(Inrt),.opCode( Inop),
.Out1(reg_dataA),.Out2(reg_dataB),.currentPC(PCdataout),.Result(ALUresult),
.DBData(DBData),.state(state));
wire Div_CLK;
CLK_slow clk_slow(
    .CLK_100mhz(BasysCLK),
    .CLK_slow(Div_CLK)
);

//Display_7Seg
wire [3:0] SegIn;

Display_7SegLED display_led(
    .display_data(SegIn),
    .dispcode(SegOut)
);

wire [15:0] display_data;
Select select(
    .In1({4'b0000,state[2:0],PCdataout[7:0]}),
    .In2({3'b000, Inrs[4:0], reg_dataA[7:0]}),
    .In3({3'b000, Inrt[4:0], reg_dataB[7:0]}),
    .In4({ALUresult[7:0], DBData[7:0]}),
    .SelectCode(SW_in),
    .DataOut(display_data)
);

//Display_transfer
Transfer tansfer(
    .CLK(Div_CLK),
    .In(display_data),

    .Out(SegIn),
    .Bit(Bits)
);

//keyboard
Keyboard_CLK keyboard(
    .Button(CLKButton),
    .BasysCLK(BasysCLK),
    .CPUCLK(cpuCLK)
);
endmodule