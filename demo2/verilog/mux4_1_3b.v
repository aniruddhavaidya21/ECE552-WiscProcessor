module mux4_1_3b(InA, InB, InC, InD, S, Out);
  
  input [2:0] InA, InB, InC, InD;
  input [1:0] S;
  output [2:0] Out;

  mux4_1 M[2:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S[1:0]), .Out(Out));
endmodule
