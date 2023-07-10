module reg_2b (clk, rst, en, in, out);
  // --- Inputs and Outputs ---
  input clk, rst;
  input en; // flag for write
  input [1:0] in; // write
  output [1:0] out; // read

  // --- Wire ---
  wire [1:0] writeEN;

  // --- Code ---
  // dff
  dff DFF[1:0] (.q(out), .d(writeEN), .clk(clk), .rst(rst));

  // mux
  mux2_1 MUX[1:0] (.InA(out), .InB(in), .S(en), .Out(writeEN));
endmodule

