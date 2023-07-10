module hazard_detection_unit (AB, writeSel_IDEX, writeSel_EXMEM, writeSel_MEMWB, readReg1_IFID, readReg2_IFID, writeReg_IDEX, writeReg_EXMEM, writeReg_MEMWB, stall, enPC, enIFID);
  // --- Inputs ---
  input [4:0] AB;
  input [2:0] writeSel_IDEX, writeSel_EXMEM, writeSel_MEMWB;
  input [2:0] readReg1_IFID, readReg2_IFID;
  input writeReg_IDEX, writeReg_EXMEM, writeReg_MEMWB;

  // --- Outputs ---
  output stall;
  output enPC;
  output enIFID;

  // --- Wires ---
  wire raw1, raw2, raw3, raw4, raw5, raw6;
  wire condition1, condition2, condition3;

  // --- Code ---
  // figure out the raw hazards
  assign raw1 = AB[1] & (writeSel_IDEX == readReg1_IFID);
  assign raw2 = AB[0] & (writeSel_IDEX == readReg2_IFID);
  assign condition1 = writeReg_IDEX & (raw1 | raw2);
  assign raw3 = AB[1] & (writeSel_EXMEM == readReg1_IFID);
  assign raw4 = AB[0] & (writeSel_EXMEM == readReg2_IFID);
  assign condition2 = writeReg_EXMEM & (raw3 | raw4);
  assign raw5 = AB[1] & (writeSel_MEMWB == readReg1_IFID);
  assign raw6 = AB[0] & (writeSel_MEMWB == readReg2_IFID);
  assign condition3 = writeReg_MEMWB & (raw5 | raw6);

  // figure out states
  assign stall = condition1 | condition2 | condition3;
  assign enPC = stall ? 1'b0 : 1'b1;
  assign enIFID = stall ? 1'b0 : 1'b1;
endmodule
