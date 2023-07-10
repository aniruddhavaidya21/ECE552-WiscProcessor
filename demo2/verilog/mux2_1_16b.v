module mux2_1_16b(InA, InB, S, Out);
 
  input [15:0] InA, InB;
  input S;
  output [15:0] Out;

  mux2_1 m[15:0] (.InA(InA), .InB(InB), .S(S), .Out(Out));
endmodule
