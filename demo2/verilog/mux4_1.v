module mux4_1(InA, InB, InC, InD, S, Out);
 
  input InA, InB, InC, InD;  
  input [1:0] S;
  output Out;
  wire out1, out2;
  
  mux2_1 M1(.InA(InA), .InB(InB), .S(S[0]), .Out(out1));
  mux2_1 M2(.InA(InC), .InB(InD), .S(S[0]), .Out(out2));
  mux2_1 M3(.InA(out1), .InB(out2), .S(S[1]), .Out(Out));
endmodule
