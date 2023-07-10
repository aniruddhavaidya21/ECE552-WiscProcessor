
module EXMEM (B_in, B_out, aluResult_in, aluResult_out, nextPC_in, nextPC_out, newPC_in, newPC_out, AB_in, AB_out, regsel_in, regsel_out, enJAL_in, enJAL_out, branch_in, branch_out, mem_to_reg_in, mem_to_reg_out, memWrite_in, memWrite_out, regWrite_in, regWrite_out, halt_in, halt_out, en, clk, rst);
  // --- Inputs ---
  input [15:0] B_in;
  input [15:0] aluResult_in;
  input [15:0] nextPC_in;
  input [15:0] newPC_in;
  input [4:0] AB_in;
  input [2:0] regsel_in;
  input enJAL_in;
  input branch_in;
  input mem_to_reg_in;
  input memWrite_in;
  input regWrite_in;
  input halt_in;
  input en;
  input clk, rst;

  // --- Outputs ---
  output [15:0] B_out;
  output [15:0] aluResult_out;
  output [15:0] nextPC_out;
  output [15:0] newPC_out;
  output [4:0] AB_out;
  output [2:0] regsel_out;
  output enJAL_out;
  output branch_out;
  output mem_to_reg_out;
  output memWrite_out;
  output regWrite_out;
  output halt_out;

  // --- Code ---
  reg_16b B (.clk(clk), .rst(rst), .en(en), .in(B_in), .out(B_out));
  reg_16b aluResult (.clk(clk), .rst(rst), .en(en), .in(aluResult_in), .out(aluResult_out));
  reg_16b newPC (.clk(clk), .rst(rst), .en(en), .in(newPC_in), .out(newPC_out));
  reg_16b nextPC (.clk(clk), .rst(rst), .en(en), .in(nextPC_in), .out(nextPC_out));
  reg_5b AB (.clk(clk), .rst(rst), .en(en), .in(AB_in), .out(AB_out));
  reg_3b regsel (.clk(clk), .rst(rst), .en(en), .in(regsel_in), .out(regsel_out));
  reg_1b enJAL (.clk(clk), .rst(rst), .en(en), .in(enJAL_in), .out(enJAL_out));
  reg_1b branch (.clk(clk), .rst(rst), .en(en), .in(branch_in), .out(branch_out));
  reg_1b mem_to_reg (.clk(clk), .rst(rst), .en(en), .in(mem_to_reg_in), .out(mem_to_reg_out));
  reg_1b memWrite (.clk(clk), .rst(rst), .en(en), .in(memWrite_in), .out(memWrite_out));
  reg_1b regWrite (.clk(clk), .rst(rst), .en(en), .in(regWrite_in), .out(regWrite_out));
  reg_1b halt (.clk(clk), .rst(rst), .en(en), .in(halt_in), .out(halt_out));

endmodule
