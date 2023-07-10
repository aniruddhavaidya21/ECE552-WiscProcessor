module regFile (read1data, read2data,clk, rst, read1regsel, read2regsel, writeregsel, writedata, write);
 
  input clk, rst;
  input [2:0] read1regsel;
  input [2:0] read2regsel;
  input [2:0] writeregsel;
  input [15:0] writedata;
  input write;

  output [15:0] read1data;
  output [15:0] read2data;


  wire [7:0] writeSel, writeDec;
  wire [15:0] read0, read1, read2, read3, read4, read5, read6, read7;

 
  decode3_8 DEC (.in(writeregsel), .out(writeDec));
  
  assign writeSel[0] = writeDec[0] & write;
  assign writeSel[1] = writeDec[1] & write;
  assign writeSel[2] = writeDec[2] & write;
  assign writeSel[3] = writeDec[3] & write;
  assign writeSel[4] = writeDec[4] & write;
  assign writeSel[5] = writeDec[5] & write;
  assign writeSel[6] = writeDec[6] & write;
  assign writeSel[7] = writeDec[7] & write;

  
  reg_16b REG1 (.clk(clk), .rst(rst), .en(writeSel[0]), .in(writedata[15:0]), .out(read0[15:0]));
  reg_16b REG2 (.clk(clk), .rst(rst), .en(writeSel[1]), .in(writedata[15:0]), .out(read1[15:0]));
  reg_16b REG3 (.clk(clk), .rst(rst), .en(writeSel[2]), .in(writedata[15:0]), .out(read2[15:0]));
  reg_16b REG4 (.clk(clk), .rst(rst), .en(writeSel[3]), .in(writedata[15:0]), .out(read3[15:0]));
  reg_16b REG5 (.clk(clk), .rst(rst), .en(writeSel[4]), .in(writedata[15:0]), .out(read4[15:0]));
  reg_16b REG6 (.clk(clk), .rst(rst), .en(writeSel[5]), .in(writedata[15:0]), .out(read5[15:0]));
  reg_16b REG7 (.clk(clk), .rst(rst), .en(writeSel[6]), .in(writedata[15:0]), .out(read6[15:0]));
  reg_16b REG8 (.clk(clk), .rst(rst), .en(writeSel[7]), .in(writedata[15:0]), .out(read7[15:0]));

  // mux for read1data
  mux8_1 MUX1[15:0] (.InA(read0), .InB(read1), .InC(read2), .InD(read3), .InE(read4), .InF(read5), .InG(read6), .InH(read7), .S(read1regsel), .Out(read1data));

  // mux for read2data
  mux8_1 MUX2[15:0] (.InA(read0), .InB(read1), .InC(read2), .InD(read3), .InE(read4), .InF(read5), .InG(read6), .InH(read7), .S(read2regsel), .Out(read2data));
endmodule
