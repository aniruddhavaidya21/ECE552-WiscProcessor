module branch(op, Z, P, N, en);
  
  input [4:0] op;
  input Z, P, N;
  output reg en;


  always @(*) begin
    case (op)
      // BEQZ
      5'b01100: en = (Z) ? 1'b1 : 1'b0;
      // BNEZ
      5'b01101: en = (P | N) ? 1'b1 : 1'b0;
      // BLTZ
      5'b01110: en = (N) ? 1'b1 : 1'b0;
      // BGEZ
      5'b01111: en = (P | Z) ? 1'b1 : 1'b0;
      // Don't Branch
      default: en = 1'b0;
    endcase
  end
endmodule
