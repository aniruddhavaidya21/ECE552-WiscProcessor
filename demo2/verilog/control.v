module control(instr, sourceALU, regDestination, memWrite, regWrite, mem_to_reg, nA, nB, Cin, AB, SExt, halt);
  // --- Inputs ---
  input [15:0] instr;

  // --- Outputs ---
  output reg [1:0] sourceALU;
  output reg [1:0] regDestination;
  output reg memWrite, regWrite, mem_to_reg;
  output reg nA, nB, Cin;
  output reg [4:0] AB;
  output reg SExt;
  output reg halt;

  // --- Code ---
  always @(*) begin
    sourceALU = 2'b11; // Zero
    regDestination = 2'b11; // R7
    memWrite = 1'b0;
    regWrite = 1'b0;
    mem_to_reg = 1'b0;
    nA = 1'b0;
    nB = 1'b0;
    Cin = 1'b0;
    AB = 5'b00000;
    SExt = 1'b0;
    halt = 1'b0;

    case ({instr[15:11]})
      5'b00000: begin // --- HALT ---
        regDestination = 2'b00; // instr[4:2]
        halt = 1'b1;
      end
      5'b00001: begin // --- NOP ---
        regDestination = 2'b00; // instr[4:2]
      end
      5'b01000: begin // --- ADDI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        AB = 5'b00010;
        SExt = 1'b1;
      end
      5'b01001: begin // --- SUBI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        nA = 1'b1;
        Cin = 1'b1;
        AB = 5'b00010;
        SExt = 1'b1;
      end
      5'b01010: begin // --- XORI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b01011: begin // --- ANDNI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        nB = 1'b1;
        AB = 5'b00010;
      end
      5'b10100: begin // --- ROLI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b10101: begin // --- SLLI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b10110: begin // --- RORI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b10111: begin // --- SRLI Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b10000: begin // --- ST Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b10; // instr[10:8]
        memWrite = 1'b1;
        AB = 5'b00011;
        SExt = 1'b1;
      end
      5'b10001: begin // --- LD Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b01; // instr[7:5]
        regWrite = 1'b1;
        mem_to_reg = 1'b1;
        AB = 5'b00010;
        SExt = 1'b1;
      end
      5'b10011: begin // --- STU Rd, Rs, immediate ---
        sourceALU = 2'b01; // imm[4:0]
        regDestination = 2'b10; // instr[10:8]
        memWrite = 1'b1;
        regWrite = 1'b1;
        AB = 5'b00011;
        SExt = 1'b1;
      end
      5'b11001: begin // --- BTR Rd, Rs ---
        sourceALU = 2'b11; // Zero
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b11011: begin // --- ADD/SUB/XOR/ANDN ---
        sourceALU = 2'b00; // Rt
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        nA = (instr[1:0] == 2'b01) ? 1'b1 : 1'b0;
        nB = (instr[1:0] == 2'b11) ? 1'b1 : 1'b0;
        Cin = (instr[1:0] == 2'b01) ? 1'b1 : 1'b0;
        AB = 5'b00011;
      end
      5'b11010: begin // --- ROL/SLL/ROR/SRL ---
        sourceALU = 2'b00; // Rt
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        AB = 5'b00011;
      end
      5'b11100: begin // --- SEQ Rd, Rs, Rt ---
        sourceALU = 2'b00; // Rt
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b00011;
      end
      5'b11101: begin // --- SLT Rd, Rs, Rt ---
        sourceALU = 2'b00; // Rt
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b00011;
      end
      5'b11110: begin // --- SLE Rd, Rs, Rt ---
        sourceALU = 2'b00; // Rt
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b00011;
      end
      5'b11111: begin // --- SCO Rd, Rs, Rt ---
        sourceALU = 2'b00; // Rt
        regDestination = 2'b00; // instr[4:2]
        regWrite = 1'b1;
        AB = 5'b00011;
      end
      5'b01100: begin // --- BEQZ Rs, immediate ---
        regDestination = 2'b10; // instr[10:8]
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b10010;
      end
      5'b01101: begin // --- BNEZ Rs, immediate ---
        regDestination = 2'b10; // instr[10:8]
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b10010;
      end
      5'b01110: begin // --- BLTZ Rs, immediate ---
        regDestination = 2'b10; // instr[10:8]
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b10010;
      end
      5'b01111: begin // --- BGEZ Rs, immediate ---
        regDestination = 2'b10; // instr[10:8]
        nB = 1'b1;
        Cin = 1'b1;
        AB = 5'b10010;
      end
      5'b11000: begin // --- LBI Rs, immediate ---
        sourceALU = 2'b10; // imm[7:0]
        regDestination = 2'b10; // instr[10:8]
        regWrite = 1'b1;
        AB = 5'b00010;
        SExt = 1'b1;
      end
      5'b10010: begin // --- SLBI Rs, immediate ---
        sourceALU = 2'b10; // imm[7:0]
        regDestination = 2'b10; // instr[10:8]
        regWrite = 1'b1;
        AB = 5'b00010;
      end
      5'b00100: begin // --- J displacement ---
        AB = 5'b01000;
      end
      5'b00101: begin // --- JR Rs, immediate ---
        AB = 5'b01010;
      end
      5'b00110: begin // --- JAL displacement ---
        regWrite = 1'b1;
        AB = 5'b00100;
      end
      5'b00111: begin // --- JALR Rs, immediate ---
        regWrite = 1'b1;
        AB = 5'b00110;
      end
      5'b00010: begin // --- siic Rs ---
        // To Do
      end
      5'b00011: begin // --- NOP / RTI ---
        // Do nothing
      end
      default: begin
        // Do nothing
      end
    endcase
  end
endmodule
