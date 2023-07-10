module mux2_1(InA, InB, S, Out);
 
  input InA, InB; 
  input S; 
  output Out;

  wire notS, AS, BS;

  assign notS = ~S;  

  assign AS = ~(InA & notS);
  assign BS = ~(InB & S);

  assign Out = ~(AS & BS);
endmodule
