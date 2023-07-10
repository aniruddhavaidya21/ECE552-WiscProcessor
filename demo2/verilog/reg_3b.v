module reg_3b (clk, rst, en, in, out);
  // --- Inputs and Outputs ---
  input clk, rst;
  input en; // flag for write
  input [2:0] in; // write
  output [2:0] out; // read

  // --- Wire ---
  wire [2:0] writeEN;

  // --- Code ---
  // dff
  dff DFF[2:0] (.q(out), .d(writeEN), .clk(clk), .rst(rst));

  // mux
  mux2_1 MUX[2:0] (.InA(out), .InB(in), .S(en), .Out(writeEN));
endmodule

