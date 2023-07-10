/*
   CS/ECE 552 Spring '20
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
module execute (instr, A, B, nextPC, SExt5, ZExt5, SExt8, ZExt8, SExt11, SExt, sourceALU, regDestination, nA, nB, Cin, aluResult, newPC, regsel, enJAL, branch);
  // --- Inputs ---
  input [15:0] instr;
  input [15:0] A, B, nextPC;
  input [15:0] SExt5, ZExt5, SExt8, ZExt8, SExt11;
  input SExt;
  input [1:0] sourceALU;
  input [1:0] regDestination;
  input nA, nB, Cin;

  // --- Outputs ---
  output [15:0] aluResult;
  output [15:0] newPC;
  output [2:0] regsel;
  output enJAL;
  output branch;

  // --- Wire ---
  wire [15:0] selExt5, selExt8;
  wire [15:0] selB;
  wire Z, N, P;
  wire enBranch, enJMP, enJR;
  wire [15:0] incBranch, incPC;
  wire [15:0] tmp1_pc, tmp2_pc, tmp3_pc;

  // --- Code ---
  assign selExt5 = SExt ? SExt5 : ZExt5;
  assign selExt8 = SExt ? SExt8 : ZExt8;
  // select the correct B input
  mux4_1_16b SEL_B (.InA(B), .InB(selExt5), .InC(selExt8), .InD(16'h0000), .S(sourceALU), .Out(selB));
  // perform ALU operation
  alu ALU (.A(A), .B(selB), .Cin(Cin), .Op(instr[15:11]), .sub_op(instr[1:0]), .nA(nA), .nB(nB), .Out(aluResult), .Z(Z), .N(N), .P(P));

  // Select correct destination register
  mux4_1_3b REG_SEL (.InA(instr[4:2]), .InB(instr[7:5]), .InC(instr[10:8]), .InD(3'b111), .S(regDestination), .Out(regsel));

  // Figure out jump and branch logic
  branch BRANCH (.op(instr[15:11]), .Z(Z), .P(P), .N(N), .en(enBranch));
  jump JUMP (.op(instr[15:11]), .enJMP(enJMP), .enJR(enJR), .enJAL(enJAL));
  assign branch = enBranch | enJMP | enJR;

  // Update the PC accordingly
  // get the pc with the branch/jump offset
  assign incBranch = enBranch ? SExt8 : 16'h0000;
  assign incPC = enJMP ? SExt11 : incBranch;
  cla_16b INC_PC (.A(nextPC), .B(incPC), .Cin(1'b0), .sum(tmp1_pc), .Cout(), .Pout(), .Gout());
  // get the new JR value
  cla_16b INC_JR (.A(A), .B(SExt8), .Cin(1'b0), .sum(tmp2_pc), .Cout(), .Pout(), .Gout());
  // mux to see what final value to take
  assign newPC = enJR ? tmp2_pc : tmp1_pc;
endmodule
   

