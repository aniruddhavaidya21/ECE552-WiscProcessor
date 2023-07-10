/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(A, B, Cin, sum, Cout, Pout, Gout);

  input [3:0] A, B;
  input Cin;
  output [3:0] sum;
  output Cout, Pout, Gout;
  wire [3:0] C, P, G;

  assign P = A | B;
  assign Pout = &P;
  assign G = A & B;
  assign Gout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
  assign C[0] = Cin;
  assign C[1] = G[0] | (P[0] & C[0]);
  assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
  assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
  assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
  assign sum = A ^ B ^ C;
  
endmodule
