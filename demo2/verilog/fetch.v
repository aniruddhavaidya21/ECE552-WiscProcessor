/*
   CS/ECE 552 Spring '20
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch (newPC, AB, AB_IDEX, AB_EXMEM, AB_MEMWB, halt, enablePC, stall, branchEXMEM, clk, rst, nextPC, instr);
  // --- Inputs ---
  input [15:0] newPC;
  input AB, AB_IDEX, AB_EXMEM, AB_MEMWB;
  input halt;
  input enablePC;
  input stall, branchEXMEM;
  input clk, rst;

  // --- Outputs ---
  output [15:0] nextPC;
  output [15:0] instr;

  // --- Wires ---
  wire [15:0] pcCurrent; // current PC
  wire [15:0] tmpPC;
  wire [15:0] inc;
  wire [15:0] instr_tmp;
  wire branch_stall;

  // --- Code ---
  // PC Reg
  //  We need an enable so that we can stop the CPU when we are dumping
  reg_16b PC_REG (.clk(clk), .rst(rst), .en(enablePC), .in(tmpPC), .out(pcCurrent));

  // Instruction Memory
  //  Get the instruction from mem. We never write to this (i think)
  memory2c INSTR_MEM (.data_out(instr_tmp), .data_in(16'h0000), .addr(pcCurrent), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));
  assign branch_stall = AB | AB_IDEX | AB_EXMEM | AB_MEMWB;
  assign instr = branch_stall ? 16'h0800 : instr_tmp;

  // PC Increment
  //  Get the PC ready for the next cycle by adding the correct offset
  assign inc = (stall | branch_stall) ? 16'h0000 : 16'h0002;
  cla_16b PC_INC (.A(pcCurrent), .B(inc), .Cin(1'b0), .sum(nextPC), .Cout(), .Pout(), .Gout());
  assign tmpPC = branchEXMEM ? newPC : nextPC;
endmodule
   

