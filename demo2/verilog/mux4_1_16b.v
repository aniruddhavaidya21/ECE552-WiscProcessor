module mux4_1_16b(InA, InB, InC, InD, S, Out);
 
  input [15:0] InA, InB, InC, InD;
  input [1:0] S;
  output [15:0] Out;

  mux4_1 M[15:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S[1:0]), .Out(Out));
endmodule
