module reg_5b (clk, rst, en, in, out);
  // --- Inputs and Outputs ---
  input clk, rst;
  input en; // flag for write
  input [4:0] in; // write
  output [4:0] out; // read

  // --- Wire ---
  wire [4:0] writeEN;

  // --- Code ---
  // dff
  dff DFF[4:0] (.q(out), .d(writeEN), .clk(clk), .rst(rst));

  // mux
  mux2_1 MUX[4:0] (.InA(out), .InB(in), .S(en), .Out(writeEN));
endmodule

