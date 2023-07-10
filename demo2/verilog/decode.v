/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
 /* TODO: Add appropriate inputs/outputs for your decode stage here*/

module decode (instr, writeData, regsel, regWrite_in, clk, rst, SExt5, ZExt5, SExt8, ZExt8, SExt11, SExt, A, B, AB, sourceALU, regDestination, memWrite, mem_to_reg, regWrite_out, nA, nB, Cin, halt);
  // --- Inputs ---
  input [15:0] instr;
  input [15:0] writeData;
  input [2:0] regsel;
  input regWrite_in;
  input clk, rst;

  // --- Outputs ---
  output [15:0] SExt5, ZExt5, SExt8, ZExt8, SExt11;
  output SExt;
  output [15:0] A, B;
  output [4:0] AB;
  output [1:0] sourceALU;
  output [1:0] regDestination;
  output memWrite, mem_to_reg, regWrite_out;
  output nA, nB, Cin;
  output halt;

  // --- Code ---
  // CPU control logic
  control CONTROL (.instr(instr), .sourceALU(sourceALU), .regDestination(regDestination), .memWrite(memWrite), .regWrite(regWrite_out), .mem_to_reg(mem_to_reg), .nA(nA), .nB(nB), .Cin(Cin), .AB(AB), .SExt(SExt), .halt(halt));

  // Get data from chosen reg
  regFile regFile0 (.read1data(A), .read2data(B), .clk(clk), .rst(rst), .read1regsel(instr[10:8]), .read2regsel(instr[7:5]), .writeregsel(regsel), .writedata(writeData), .write(regWrite_in));

  // Extend
  assign SExt5 = {{11{instr[4]}}, instr[4:0]};
  assign ZExt5 = {{11{1'b0}}, instr[4:0]};
  assign SExt8 = {{8{instr[7]}}, instr[7:0]};
  assign ZExt8 = {{8{1'b0}}, instr[7:0]};
  assign SExt11 = {{5{instr[10]}}, instr[10:0]};
  
endmodule
   
