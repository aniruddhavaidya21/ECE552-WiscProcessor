module reg_1b (clk, rst, en, in, out);
  // --- Inputs and Outputs ---
  input clk, rst;
  input en; // flag for write
  input in; // write
  output out; // read

  // --- Wire ---
  wire writeEN;

  // --- Code ---
  // dff
  dff DFF (.q(out), .d(writeEN), .clk(clk), .rst(rst));

  // mux
  mux2_1 MUX (.InA(out), .InB(in), .S(en), .Out(writeEN));
endmodule
