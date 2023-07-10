/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   
   
   
   wire [15:0] nextPC;
  wire [15:0] instr;

  // IFID
  wire [15:0] instr_IFID;
  wire [15:0] nextPC_IFID;
  wire branch_IFID;

  // Decode
  wire [15:0] A, B;
  wire [4:0] AB;
  wire nA, nB, Cin;
  wire [15:0] SExt5, ZExt5, SExt8, ZExt8, SExt11;
  wire SExt;
  wire [1:0] sourceALU;
  wire [1:0] regDestination;
  wire memWrite, mem_to_reg, regWrite;
  wire halt;

  // HDU
  wire stall;
  wire enPC;
  wire enIFID;

  // IDEX
  wire [15:0] instr_IDEX;
  wire [15:0] nextPC_IDEX;
  wire [15:0] A_IDEX, B_IDEX;
  wire [4:0] AB_IDEX;
  wire nA_IDEX, nB_IDEX, Cin_IDEX;
  wire [15:0] SExt5_IDEX, ZExt5_IDEX, SExt8_IDEX, ZExt8_IDEX, SExt11_IDEX;
  wire SExt_IDEX;
  wire [1:0] sourceALU_IDEX;
  wire [1:0] regDestination_IDEX;
  wire memWrite_IDEX, mem_to_reg_IDEX, regWrite_IDEX;
  wire halt_IDEX;

  // Execute
  wire [15:0] newPC;
  wire [15:0] aluResult;
  wire [2:0] regsel;
  wire enJAL;
  wire branch;

  // EXMEM
  wire [15:0] newPC_EXMEM;
  wire [15:0] nextPC_EXMEM;
  wire [15:0] aluResult_EXMEM;
  wire [15:0] B_EXMEM;
  wire [4:0] AB_EXMEM;
  wire [2:0] regsel_EXMEM;
  wire memWrite_EXMEM, mem_to_reg_EXMEM, regWrite_EXMEM;
  wire halt_EXMEM;
  wire enJAL_EXMEM;
  wire branch_EXMEM;

  // Memory
  wire [15:0] readData;

  // MEMWB
  wire [15:0] newPC_MEMWB;
  wire [15:0] nextPC_MEMWB;
  wire [15:0] aluResult_MEMWB;
  wire [15:0] readData_MEMWB;
  wire [4:0] AB_MEMWB;
  wire [2:0] regsel_MEMWB;
  wire mem_to_reg_MEMWB, regWrite_MEMWB;
  wire enJAL_MEMWB;
  wire branch_MEMWB;
  wire halt_MEMWB;

  // WB
  wire [15:0] writeData;

  // --- Code ---
  assign err = 1'b0;

  fetch fetch0 (.clk(clk), .rst(rst),
   .newPC(newPC_MEMWB),
   .AB(|AB[4:2]), .AB_IDEX(|AB_IDEX[4:2]), .AB_EXMEM(|AB_EXMEM[4:2]), .AB_MEMWB(|AB_MEMWB[4:2]), 
   .halt(halt_MEMWB), 
   .enablePC(enPC), 
   .stall(stall), 
   .branchEXMEM(branch_MEMWB),
   .nextPC(nextPC), 
   .instr(instr)
  );

  IFID ifid0 (.clk(clk), .rst(rst),
   .nextPC_in(nextPC), .nextPC_out(nextPC_IFID),
   .instr_in(instr), .instr_out(instr_IFID),
   .en(enIFID)
  );

  decode decode0 (.clk(clk), .rst(rst), .instr(instr_IFID), .writeData(writeData), 
   .regsel(regsel_MEMWB), .regWrite_in(regWrite_MEMWB),
   .SExt5(SExt5), .ZExt5(ZExt5), 
   .SExt8(SExt8), .ZExt8(ZExt8), 
   .SExt11(SExt11), 
   .SExt(SExt),
   .A(A), .B(B), 
   .AB(AB),
   .sourceALU(sourceALU), 
   .regDestination(regDestination),
   .memWrite(memWrite), .mem_to_reg(mem_to_reg), .regWrite_out(regWrite),
   .nA(nA), .nB(nB), .Cin(Cin), 
   .halt(halt)
  );

  hazard_detection_unit hdu0 (
   .AB(AB),
   .writeSel_IDEX(regsel), 
   .writeSel_EXMEM(regsel_EXMEM), 
   .writeSel_MEMWB(regsel_MEMWB), 
   .readReg1_IFID(instr_IFID[10:8]), 
   .readReg2_IFID(instr_IFID[7:5]), 
   .writeReg_IDEX(regWrite_IDEX), 
   .writeReg_EXMEM(regWrite_EXMEM), 
   .writeReg_MEMWB(regWrite_MEMWB), 
   .stall(stall), 
   .enPC(enPC), 
   .enIFID(enIFID)
  );

  IDEX idex0 (.clk(clk), .rst(rst),
   .instr_in(instr_IFID), .instr_out(instr_IDEX), 
   .nextPC_in(nextPC_IFID), .nextPC_out(nextPC_IDEX), 
   .A_in(A), .A_out(A_IDEX), 
   .B_in(B), .B_out(B_IDEX), 
   .nA_in(nA), .nA_out(nA_IDEX), 
   .nB_in(nB), .nB_out(nB_IDEX), 
   .Cin_in(Cin), .Cin_out(Cin_IDEX), 
   .AB_in(AB), .AB_out(AB_IDEX), 
   .SExt5_in(SExt5), .SExt5_out(SExt5_IDEX), 
   .ZExt5_in(ZExt5), .ZExt5_out(ZExt5_IDEX), 
   .SExt8_in(SExt8), .SExt8_out(SExt8_IDEX), 
   .ZExt8_in(ZExt8), .ZExt8_out(ZExt8_IDEX), 
   .SExt11_in(SExt11), .SExt11_out(SExt11_IDEX), 
   .SExt_in(SExt), .SExt_out(SExt_IDEX), 
   .sourceALU_in(sourceALU), .sourceALU_out(sourceALU_IDEX), 
   .regDestination_in(regDestination), .regDestination_out(regDestination_IDEX), 
   .memWrite_in(memWrite), .memWrite_out(memWrite_IDEX), 
   .mem_to_reg_in(mem_to_reg), .mem_to_reg_out(mem_to_reg_IDEX), 
   .regWrite_in(regWrite), .regWrite_out(regWrite_IDEX), 
   .halt_in(halt), .halt_out(halt_IDEX), 
   .stall(stall), 
   .en(1'b1)
  );

  execute execute0 (
   .instr(instr_IDEX), 
   .A(A_IDEX), .B(B_IDEX), 
   .nextPC(nextPC_IDEX), 
   .SExt5(SExt5_IDEX), .ZExt5(ZExt5_IDEX), 
   .SExt8(SExt8_IDEX), .ZExt8(ZExt8_IDEX), 
   .SExt11(SExt11_IDEX), 
   .SExt(SExt_IDEX),
   .sourceALU(sourceALU_IDEX), 
   .regDestination(regDestination_IDEX),
   .nA(nA_IDEX), .nB(nB_IDEX), .Cin(Cin_IDEX), 
   .aluResult(aluResult), 
   .newPC(newPC),
   .regsel(regsel), 
   .enJAL(enJAL),
   .branch(branch)
  );

  EXMEM exmem0 (.clk(clk), .rst(rst),
   .B_in(B_IDEX), .B_out(B_EXMEM), 
   .aluResult_in(aluResult), .aluResult_out(aluResult_EXMEM), 
   .nextPC_in(nextPC_IDEX), .nextPC_out(nextPC_EXMEM), 
   .newPC_in(newPC), .newPC_out(newPC_EXMEM), 
   .AB_in(AB_IDEX), .AB_out(AB_EXMEM), 
   .regsel_in(regsel), .regsel_out(regsel_EXMEM), 
   .enJAL_in(enJAL), .enJAL_out(enJAL_EXMEM), 
   .branch_in(branch), .branch_out(branch_EXMEM), 
   .mem_to_reg_in(mem_to_reg_IDEX), .mem_to_reg_out(mem_to_reg_EXMEM), 
   .memWrite_in(memWrite_IDEX), .memWrite_out(memWrite_EXMEM), 
   .regWrite_in(regWrite_IDEX), .regWrite_out(regWrite_EXMEM), 
   .halt_in(halt_IDEX), .halt_out(halt_EXMEM), 
   .en(1'b1)
  );

  memory memory0 (.clk(clk), .rst(rst), 
   .writeData(B_EXMEM), 
   .aluResult(aluResult_EXMEM), 
   .memRead(mem_to_reg_EXMEM), 
   .memWrite(memWrite_EXMEM), 
   .halt(halt_EXMEM), 
   .readData(readData)
  );

  MEMWB memwb0 (.clk(clk), .rst(rst),
   .readData_in(readData), .readData_out(readData_MEMWB), 
   .nextPC_in(nextPC_EXMEM), .nextPC_out(nextPC_MEMWB), 
   .newPC_in(newPC_EXMEM), .newPC_out(newPC_MEMWB), 
   .aluResult_in(aluResult_EXMEM), .aluResult_out(aluResult_MEMWB), 
   .AB_in(AB_EXMEM), .AB_out(AB_MEMWB), 
   .regSel_in(regsel_EXMEM), .regSel_out(regsel_MEMWB), 
   .regWrite_in(regWrite_EXMEM), .regWrite_out(regWrite_MEMWB), 
   .mem_to_reg_in(mem_to_reg_EXMEM), .mem_to_reg_out(mem_to_reg_MEMWB), 
   .enJAL_in(enJAL_EXMEM), .enJAL_out(enJAL_MEMWB), 
   .branch_in(branch_EXMEM), .branch_out(branch_MEMWB), 
   .halt_in(halt_EXMEM), .halt_out(halt_MEMWB),
   .en(1'b1)
  );

  wb wb0 (
   .aluResult(aluResult_MEMWB), 
   .readData(readData_MEMWB), 
   .nextPC(nextPC_MEMWB), 
   .enJAL(enJAL_MEMWB), 
   .mem_to_reg(mem_to_reg_MEMWB), 
   .writeData(writeData)
  );

endmodule 
