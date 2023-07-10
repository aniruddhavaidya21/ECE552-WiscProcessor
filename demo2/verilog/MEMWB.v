module MEMWB (readData_in, readData_out, nextPC_in, nextPC_out, newPC_in, newPC_out, aluResult_in, aluResult_out, AB_in, AB_out, regSel_in, regSel_out, regWrite_in, regWrite_out, mem_to_reg_in, mem_to_reg_out, enJAL_in, enJAL_out, branch_in, branch_out, halt_in, halt_out, en, clk, rst);
  // --- Inputs ---
  input [15:0] readData_in;
  input [15:0] nextPC_in;
  input [15:0] newPC_in;
  input [15:0] aluResult_in;
  input [4:0] AB_in;
  input [2:0] regSel_in;
  input regWrite_in;
  input mem_to_reg_in;
  input enJAL_in;
  input branch_in;
  input halt_in;
  input en;
  input clk, rst;

  // --- Outputs ---
  output [15:0] readData_out;
  output [15:0] nextPC_out;
  output [15:0] newPC_out;
  output [15:0] aluResult_out;
  output [4:0] AB_out;
  output [2:0] regSel_out;
  output regWrite_out;
  output mem_to_reg_out;
  output enJAL_out;
  output branch_out;
  output halt_out;

  // --- Code ---
  // from memory
  reg_16b readData (.clk(clk), .rst(rst), .en(en), .in(readData_in), .out(readData_out));

  // from EX/MEM
  reg_16b nextPC (.clk(clk), .rst(rst), .en(en), .in(nextPC_in), .out(nextPC_out));
  reg_16b newPC (.clk(clk), .rst(rst), .en(en), .in(newPC_in), .out(newPC_out));
  reg_16b aluResult (.clk(clk), .rst(rst), .en(en), .in(aluResult_in), .out(aluResult_out));
  reg_5b AB (.clk(clk), .rst(rst), .en(en), .in(AB_in), .out(AB_out));
  reg_3b regSel (.clk(clk), .rst(rst), .en(en), .in(regSel_in), .out(regSel_out));
  reg_1b regWrite (.clk(clk), .rst(rst), .en(en), .in(regWrite_in), .out(regWrite_out));
  reg_1b mem_to_reg (.clk(clk), .rst(rst), .en(en), .in(mem_to_reg_in), .out(mem_to_reg_out));
  reg_1b enJAL (.clk(clk), .rst(rst), .en(en), .in(enJAL_in), .out(enJAL_out));
  reg_1b branch (.clk(clk), .rst(rst), .en(en), .in(branch_in), .out(branch_out));
  reg_1b halt (.clk(clk), .rst(rst), .en(en), .in(halt_in), .out(halt_out));
endmodule
