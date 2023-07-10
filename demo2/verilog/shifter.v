module shifter (In, Cnt, Op, Out);
  
  input [15:0] In;
  input [3:0] Cnt; 
  input [1:0] Op; 
  output reg [15:0] Out;

  
  reg [15:0] eight_four, four_two, two_one;  
    

  always @(*) begin
    // check for Cnt = 4'b1xxx
    case ({Cnt[3], Op})
      // rotate left
      3'b100: eight_four <= {In[7:0], In[15:8]};
      // logical left shift
      3'b101: eight_four <= {In[7:0], 8'h00};
      // arithmetic right shift
      3'b110: eight_four <= {In[7:0], In[15:8]};
      // ligical right shfit
      3'b111: eight_four <= {8'h00, In[15:8]};
      // 4'b0xxx found
      default: eight_four <= In;
    endcase
  end

  always @(*) begin
    // check for Cnt = 4'bx1xx
    case ({Cnt[2], Op})
      // rotate left
      3'b100: four_two <= {eight_four[11:0], eight_four[15:12]};
      // logical left shift
      3'b101: four_two <= {eight_four[13:0], 4'h0};
      // arithmetic right shfit
      3'b110: four_two <= {eight_four[3:0], eight_four[15:4]};
      // logical right shfit
      3'b111: four_two <= {4'h0, eight_four[15:4]};
      // 4'bx0xx found
      default: four_two <= eight_four;
    endcase
  end

  always @(*) begin
    // check for Cnt = 4'bxx1x
    case ({Cnt[1], Op})
      // rotate left
      3'b100: two_one <= {four_two[13:0], four_two[15:14]};
      // logical left shift
      3'b101: two_one <= {four_two[13:0], 2'b00};
      // arithmetic right shift
      3'b110: two_one <= {four_two[1:0], four_two[15:2]};
      // lociacl right shfit
      3'b111: two_one <= {2'b00, four_two[15:2]};
      // 4'hxx0x found
      default: two_one <= four_two;
    endcase
  end

  always @(*) begin
    // check for Cnt = 4'bxxx1
    case ({Cnt[0], Op})
      // rotate left
      3'b100: Out <= {two_one[14:0], two_one[15]};
      // logical left shift
      3'b101: Out <= {two_one[14:0], 1'b0};
      // arithmetic right shift
      3'b110: Out <= {two_one[0], two_one[15:1]};
      // logical right shift
      3'b111: Out <= {1'b0, two_one[15:1]};
      // 4'bxxx0 found
      default: Out <= two_one;
    endcase
  end
  
endmodule
