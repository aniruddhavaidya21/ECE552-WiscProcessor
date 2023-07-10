module cache_fsm(state, n_state, addr, data_in, read, write, tag_out, data_out_cache, hit, dirty, valid, data_out_mem, stall_mem, data_out, done, stall, cache_hit, enable, tag_in, index, offset, comp, data_in_cache, write_cache, valid_in, addr_mem, data_in_mem, read_mem, write_mem);
  // --- Inputs ---
  input [4:0] state;
  // mem_system inputs
  input [15:0] addr;
  input [15:0] data_in;
  input read, write;
  // cache inputs
  input [4:0] tag_out;
  input [15:0] data_out_cache;
  input hit;
  input dirty;
  input valid;
  // mem outputs
  input [15:0] data_out_mem;
  input stall_mem;

  // --- Outputs ---
  output reg [4:0] n_state;
  // mem_system outputs
  output [15:0] data_out; 
  output reg done;
  output reg stall;
  output reg cache_hit;
  // cache outputs
  output reg enable;
  output [4:0] tag_in;
  output [7:0] index;
  output [2:0] offset;
  output reg comp;
  output reg [15:0] data_in_cache;
  output reg write_cache;
  output valid_in;
  // mem outputs
  output [15:0] addr_mem;
  output reg [15:0] data_in_mem;
  output reg read_mem, write_mem;

  // --- Wires ---
  reg [15:0] tmp_adder;
  reg [4:0] tmp_tag;
  reg [2:0] tmp_offset;

  // --- States ---
  // this makes it easier to read the code
  localparam idle       = 5'b00000;
  localparam err        = 5'b00001;
  localparam done_s     = 5'b00010;
  localparam comp_rd    = 5'b00011;
  localparam comp_wr    = 5'b00100;
  localparam mem_wr     = 5'b00101;
  localparam store_done = 5'b00110;
  localparam wb0        = 5'b00111;
  localparam wb1        = 5'b01000;
  localparam wb2        = 5'b01001;
  localparam wb3        = 5'b01010;
  localparam read0      = 5'b01011;
  localparam read1      = 5'b01100;
  localparam read2      = 5'b01101;
  localparam read3      = 5'b01111;
  localparam store0     = 5'b10000;
  localparam store1     = 5'b10001;
  localparam store2     = 5'b10010;
  localparam store3     = 5'b10011;
  localparam wait0      = 5'b10100;
  localparam wait1      = 5'b10101;
  localparam wait2      = 5'b10110;
  localparam wait3      = 5'b10111;

  // --- Code ---
  // need to do it like this otherwise it doesn't pass
  assign addr_mem = {tmp_tag, tmp_adder[10:3], tmp_offset};
  assign tag_in = tmp_adder[15:11];
  assign index = tmp_adder[10:3];
  assign offset = tmp_adder[2:0];
  assign valid_in = 1'b1;

  always @(*) begin
    done = 1'b0;
    stall = 1'b1;
    cache_hit = 1'b0;
    enable = 1'b0;
    comp = 1'b0;
    data_in_cache = data_in;
    write_cache = 1'b0;
    data_in_mem = data_out_cache;
    read_mem = 1'b0;
    write_mem = 1'b0;
    tmp_tag = addr[15:11];
    tmp_adder = addr;
    tmp_offset = 3'b000;
    
    case(state)
      idle: begin
        stall = 1'b0;
        enable = 1'b1;
        n_state = (~read & ~write) ? idle :
                  ( read & ~write) ? comp_rd :
                  (~read &  write) ? comp_wr : err;
      end
      err: begin
        n_state = (read & write) ? err : idle;
      end
      done_s: begin
        done = 1'b1;
        cache_hit = 1'b1;
        stall = 1'b0;
        enable = 1'b1;
        n_state = (~read &  write) ? comp_wr :
                  ( read & ~write) ? comp_rd : idle;
      end
      comp_rd: begin
        enable = 1'b1;
        comp = 1'b1;
        n_state = (  valid &  hit)           ? done_s :
                  ((~valid | ~hit) & ~dirty) ? read0 :
                  (dirty)                    ? wb0 : err;
      end
      comp_wr: begin
        enable = 1'b1;
        comp = 1'b1;
        write_cache = 1'b1;
        n_state = (  valid &  hit)           ? done_s :
                  ((~valid | ~hit) & ~dirty) ? read0 :
                  (dirty)                    ? wb0 : err;
      end
      mem_wr: begin
        enable = 1'b1;
        comp = 1'b1;
        n_state = store_done;
      end
      store_done: begin
        done = 1'b1;
        stall = 1'b0;
        enable = 1'b1;
        n_state = (~read &  write) ? comp_wr :
                  ( read & ~write) ? comp_rd : idle;
      end
      wb0: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_adder = {addr[15:3], 3'b000};
        n_state = (stall_mem) ? wb0 : wb1;
      end
      wb1: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_adder = {addr[15:3], 3'b010};
        tmp_offset = 3'b010;
        n_state = (stall_mem) ? wb1 : wb2;
      end
      wb2: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_adder = {addr[15:3], 3'b100};
        tmp_offset = 3'b100;
        n_state = (stall_mem) ? wb2 : wb3;
      end
      wb3: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_adder = {addr[15:3], 3'b110};
        tmp_offset = 3'b110;
        n_state = (stall_mem) ? wb2 : read0;
      end
      read0: begin 
        read_mem = 1'b1;
        n_state = (stall_mem) ? read0 : wait0;
      end
      wait0: begin
        read_mem = 1'b1;
        n_state = store0;
      end
      store0: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_adder = {addr[15:3], 3'b000};
        n_state = read1;
      end
      read1: begin
        read_mem = 1'b1;
        tmp_offset = 3'b010;
        n_state = (stall_mem) ? read1 : wait1;
      end
      wait1: begin
        read_mem = 1'b1;
        n_state = store1;
      end
      store1: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_adder = {addr[15:3], 3'b010};
        tmp_offset = 3'b010;
        n_state = read2;
      end
      read2: begin
        read_mem = 1'b1;
        tmp_offset = 3'b100;
        n_state = (stall_mem) ? read2 : wait2;
      end
      wait2: begin
        read_mem = 1'b1;
        n_state = store2;
      end
      store2: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_adder = {addr[15:3], 3'b100};
        tmp_offset = 3'b100;
        n_state = read3;
      end
      read3: begin
        read_mem = 1'b1;
        tmp_offset = 3'b110;
        n_state = (stall_mem) ? read3 : wait3;
      end
      wait3: begin
        read_mem = 1'b1;
        n_state = store3;
      end
      store3: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_adder = {addr[15:3], 3'b110};
        tmp_offset = 3'b110;
        n_state = (~read & write) ? mem_wr : store_done;
      end
      default: begin // should never reach
      end
    endcase
  end

endmodule
