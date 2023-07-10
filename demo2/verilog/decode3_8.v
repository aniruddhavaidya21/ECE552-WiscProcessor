module decode3_8 (in, out);
 
  input [2:0] in;
  output [7:0] out;
  wire [2:0] in0;

  assign in0[0] = ~in[0];
  assign in0[1] = ~in[1];
  assign in0[2] = ~in[2];
  
  assign out[0] = in0[2] & in0[1] & in0[0];
  assign out[1] = in0[2] & in0[1] &  in[0];
  assign out[2] = in0[2] &  in[1] & in0[0];
  assign out[3] = in0[2] &  in[1] &  in[0];
  assign out[4] =  in[2] & in0[1] & in0[0];
  assign out[5] =  in[2] & in0[1] &  in[0];
  assign out[6] =  in[2] &  in[1] & in0[0];
  assign out[7] =  in[2] &  in[1] &  in[0];
endmodule
