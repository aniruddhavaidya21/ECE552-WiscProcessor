module alu (A, B, Cin, Op, sub_op, nA, nB, Out, Z, N, P);
  input [15:0] A, B; 
  input Cin; 
  input [4:0] Op; 
  input [1:0] sub_op;
  input nA, nB; 
  output reg [15:0] Out;
  output Z, N, P; 
  wire [15:0] chosen_A, chosen_B, shifter0_out, shifter1_out, add_out, arith_out;
  wire Gout;
  wire slbi;
  
  
  assign Z = ~|add_out;
  assign N = ~Z & add_out[15];
  assign P = ~Z & ~add_out[15];
  assign chosen_A = nA ? ~A : A;
  assign chosen_B = nB ? ~B : B;

  
  cla_16b ADDER(.A(chosen_A), .B(chosen_B), .Cin(Cin), .sum(add_out), .Cout(),  .Pout(), .Gout(Gout));
  
  mux4_1_16b MUX_ARITH(.InA(add_out), .InB(add_out), .InC(chosen_A ^ chosen_B), .InD(chosen_A & chosen_B), .S(sub_op), .Out(arith_out));

 
  shifter shifter0 (.In(chosen_A), .Cnt(chosen_B[3:0]), .Op(Op[1:0]), .Out(shifter0_out));
  shifter shifter1 (.In(chosen_A), .Cnt(chosen_B[3:0]), .Op(sub_op[1:0]), .Out(shifter1_out));

  always @(*) begin
    Out = 16'hXXXX;

    casex (Op)
      5'b00000: begin // --- HALT ---
        // Do nothing
      end
      5'b00001: begin // --- NOP ---
        // Do nothing
      end
      5'b01000: begin // --- ADDI Rd, Rs, immediate ---
        Out = add_out;
      end
      5'b01001: begin // --- SUBI Rd, Rs, immediate ---
        Out = add_out;
      end
      5'b01010: begin // --- XORI Rd, Rs, immediate ---
        Out = chosen_A ^ chosen_B;
      end
      5'b01011: begin // --- ANDNI Rd, Rs, immediate ---
        Out = chosen_A & chosen_B;
      end
      5'b101xx: begin // --- ROLI/SLLI/RORI/SRLI ---
        Out = shifter0_out;
      end
      5'b10000: begin // --- ST Rd, Rs, immediate ---
        Out = add_out;
      end
      5'b10001: begin // --- LD Rd, Rs, immediate ---
        Out = add_out;
      end
      5'b10011: begin // --- STU Rd, Rs, immediate ---
        Out = add_out;
      end
      5'b11001: begin // --- BTR Rd, Rs ---
        Out = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]};
      end
      5'b11011: begin // --- ADD/SUB/XOR/ANDN ---
        Out = arith_out;
      end
      5'b11010: begin // --- ROL/SLL/ROR/SRL ---
        Out = shifter1_out;
      end
      5'b11100: begin // --- SEQ Rd, Rs, Rt ---
        Out = Z ? 16'h1 : 16'h0;
      end
      5'b11101: begin // --- SLT Rd, Rs, Rt ---
        Out =  ((N & ~(A[15] ^ B[15])) | (A[15] & ~B[15])) ? 16'h1: 16'h0;
      end
      5'b11110: begin // --- SLE Rd, Rs, Rt ---
        Out = ((N & ~(A[15] ^ B[15])) | (A[15] & ~B[15]) | Z) ? 16'h1 : 16'h0;
      end
      5'b11111: begin // --- SCO Rd, Rs, Rt ---
        Out = Gout ? 16'h0001 : 16'h0000;
      end
      5'b01100: begin // --- BEQZ Rs, immediate ---
        Out = add_out;
      end
      5'b01101: begin // --- BNEZ Rs, immediate ---
        Out = add_out;
      end
      5'b01110: begin // --- BLTZ Rs, immediate ---
        Out = add_out;
      end
      5'b01111: begin // --- BGEZ Rs, immediate ---
        Out = add_out;
      end
      5'b11000: begin // --- LBI Rs, immediate ---
        Out = B;
      end
      5'b10010: begin // --- SLBI Rs, immediate ---
        Out = (A << 8) | B;
      end
      5'b00100: begin // --- J displacement ---
        Out = add_out;
      end
      5'b00101: begin // --- JR Rs, immediate ---
        Out = add_out;
      end
      5'b00110: begin // --- JAL displacement ---
        Out = add_out;
      end
      5'b00111: begin // --- JALR Rs, immediate ---
        Out = add_out;
      end
      5'b00010: begin // --- siic Rs ---
        // TO-DO
      end
      5'b00011: begin // --- NOP / RTI ---
        // Do nothing
      end
      default: begin  
        // Should never reach
      end
    endcase
  end
endmodule

