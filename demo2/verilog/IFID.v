module IFID (nextPC_in, nextPC_out, instr_in, instr_out, en, clk, rst);
  // --- Inputs ---
  input [15:0] nextPC_in;
  input [15:0] instr_in;
  input en;
  input clk, rst;

  // --- Outputs ---
  output [15:0] nextPC_out;
  output [15:0] instr_out;

  // --- Wires ---
  wire [15:0] selInstr;

  // --- Code ---
  reg_16b NEXT_PC (.clk(clk), .rst(rst), .en(en), .in(nextPC_in), .out(nextPC_out));

  // chose nop if stall
  assign selInstr = rst ? 16'h0800 : instr_in;
  reg_16b INSTR (.clk(clk), .rst(1'b0), .en(en), .in(selInstr), .out(instr_out));
endmodule
