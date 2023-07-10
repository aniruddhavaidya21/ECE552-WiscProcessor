
module reg_16b (clk, rst, en, in, out);

  input clk, rst;
  input en; 
  input [15:0] in; 
  output [15:0] out; 

  wire [15:0] writeEN;

  dff DFF[15:0] (.q(out), .d(writeEN), .clk(clk), .rst(rst));

  mux2_1 MUX[15:0] (.InA(out), .InB(in), .S(en), .Out(writeEN));
endmodule
