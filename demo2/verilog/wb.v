/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb (aluResult, readData, nextPC, enJAL, mem_to_reg, writeData);
  // --- Inputs ---
  input [15:0] aluResult;
  input [15:0] readData;
  input [15:0] nextPC;
  input enJAL;
  input mem_to_reg;

  // --- Outputs ---
  output [15:0] writeData;

  // --- Code ---
  mux4_1_16b WB_MUX (.InA(aluResult), .InB(readData), .InC(nextPC), .InD(16'hXXXX), .S({enJAL, mem_to_reg}), .Out(writeData));
endmodule
   

