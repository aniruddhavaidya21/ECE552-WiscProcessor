
module IDEX (instr_in, instr_out, nextPC_in, nextPC_out, A_in, A_out, B_in, B_out, nA_in, nA_out, nB_in, nB_out, Cin_in, Cin_out, AB_in, AB_out, SExt5_in, SExt5_out, ZExt5_in, ZExt5_out, SExt8_in, SExt8_out, ZExt8_in, ZExt8_out, SExt11_in, SExt11_out, SExt_in, SExt_out, sourceALU_in, sourceALU_out, regDestination_in, regDestination_out, memWrite_in, memWrite_out, mem_to_reg_in, mem_to_reg_out, regWrite_in, regWrite_out, halt_in, halt_out, stall, en, clk, rst);
  // --- Inputs ---
  input [15:0] instr_in, nextPC_in;
  input [15:0] A_in, B_in;
  input nA_in, nB_in, Cin_in;
  input [4:0] AB_in;
  input [15:0] SExt5_in, ZExt5_in, SExt8_in, ZExt8_in, SExt11_in;
  input SExt_in;
  input [1:0] sourceALU_in;
  input [1:0] regDestination_in;
  input memWrite_in, mem_to_reg_in, regWrite_in;
  input halt_in;
  input stall;
  input en;
  input clk, rst;

  // --- Outputs ---
  output [15:0] instr_out, nextPC_out;
  output [15:0] A_out, B_out;
  output nA_out, nB_out, Cin_out;
  output [4:0] AB_out;
  output [15:0] SExt5_out, ZExt5_out, SExt8_out, ZExt8_out, SExt11_out;
  output SExt_out;
  output [1:0] sourceALU_out;
  output [1:0] regDestination_out;
  output memWrite_out, mem_to_reg_out, regWrite_out;
  output halt_out;

  // --- Wires ---
  wire [15:0] sel_instr;
  wire sel_memWrite;
  wire sel_mem_to_reg;
  wire sel_regWrite;
  wire sel_halt;

  // --- Code ---
  assign sel_instr = stall ? 16'h0800 : instr_in;
  reg_16b instr (.clk(clk), .rst(rst), .en(en), .in(sel_instr), .out(instr_out));

  reg_16b nextPC (.clk(clk), .rst(rst), .en(en), .in(nextPC_in), .out(nextPC_out));

  reg_16b A (.clk(clk), .rst(rst), .en(en), .in(A_in), .out(A_out));
  reg_16b B (.clk(clk), .rst(rst), .en(en), .in(B_in), .out(B_out));
  reg_1b nA (.clk(clk), .rst(rst), .en(en), .in(nA_in), .out(nA_out));
  reg_1b nB (.clk(clk), .rst(rst), .en(en), .in(nB_in), .out(nB_out));
  reg_1b Cin (.clk(clk), .rst(rst), .en(en), .in(Cin_in), .out(Cin_out));

  reg_5b AB (.clk(clk), .rst(rst), .en(en), .in(AB_in), .out(AB_out));

  reg_16b SExt5 (.clk(clk), .rst(rst), .en(en), .in(SExt5_in), .out(SExt5_out));
  reg_16b ZExt5 (.clk(clk), .rst(rst), .en(en), .in(ZExt5_in), .out(ZExt5_out));
  reg_16b SExt8 (.clk(clk), .rst(rst), .en(en), .in(SExt8_in), .out(SExt8_out));
  reg_16b ZExt8 (.clk(clk), .rst(rst), .en(en), .in(ZExt8_in), .out(ZExt8_out));
  reg_16b SExt11 (.clk(clk), .rst(rst), .en(en), .in(SExt11_in), .out(SExt11_out));
  reg_1b SExt (.clk(clk), .rst(rst), .en(en), .in(SExt_in), .out(SExt_out));

  reg_2b sourceALU (.clk(clk), .rst(rst), .en(en), .in(sourceALU_in), .out(sourceALU_out));
  reg_2b regDestination (.clk(clk), .rst(rst), .en(en), .in(regDestination_in), .out(regDestination_out));

  assign sel_memWrite = stall ? 1'b0 : memWrite_in;
  reg_1b memWrite (.clk(clk), .rst(rst), .en(en), .in(sel_memWrite), .out(memWrite_out));

  assign sel_mem_to_reg = stall ? 1'b0 : mem_to_reg_in;
  reg_1b mem_to_reg (.clk(clk), .rst(rst), .en(en), .in(sel_mem_to_reg), .out(mem_to_reg_out));
 
  assign sel_regWrite = stall ? 1'b0 : regWrite_in;
  reg_1b regWrite (.clk(clk), .rst(rst), .en(en), .in(sel_regWrite), .out(regWrite_out));

  assign sel_halt = stall ? 1'b0 : halt_in;
  reg_1b halt (.clk(clk), .rst(rst), .en(en), .in(sel_halt), .out(halt_out));
endmodule
