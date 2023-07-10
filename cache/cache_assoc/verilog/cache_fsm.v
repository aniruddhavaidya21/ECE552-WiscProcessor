module cache_fsm(state, clk, rst, n_state, Addr, DataIn, Rd, Wr, tag_out0, tag_out1, data_out_cache0, data_out_cache1, hit0, hit1, dirty0, dirty1, valid0, valid1, data_out_mem, stall_mem, DataOut, Done, Stall, CacheHit, enable, tag_in, index, offset, comp, data_in_cache, write_cache0, write_cache1, addr_mem, data_in_mem, read_mem, write_mem);
  // --- Inputs ---
  input [4:0] state;
  input clk, rst;
  // mem_system inputs
  input [15:0] Addr;
  input [15:0] DataIn;
  input Rd, Wr;
  // cache inputs
  input [4:0] tag_out0, tag_out1;
  input [15:0] data_out_cache0, data_out_cache1;
  input hit0, hit1;
  input dirty0, dirty1;
  input valid0, valid1;
  // mem outputs
  input [15:0] data_out_mem;
  input stall_mem;

  // --- Outputs ---
  output reg [4:0] n_state;
  // mem_system outputs
  output [15:0] DataOut; 
  output reg Done;
  output reg Stall;
  output reg CacheHit;
  // cache outputs
  output reg enable;
  output [4:0] tag_in;
  output [7:0] index;
  output [2:0] offset;
  output reg [15:0] data_in_cache;
  output reg comp;
  output write_cache0, write_cache1;
  // mem outputs
  output [15:0] addr_mem;
  output reg [15:0] data_in_mem;
  output reg read_mem, write_mem;

  // --- Wires ---
  wire victimway, victimway_in;
  wire access_victim, access_victim_in;
  reg victim;
  reg n_victim;

  reg [15:0] tmp_addr;
  reg [4:0] tmp_tag;
  reg [2:0] tmp_offset;

  reg write_cache;
  wire valid;
  wire hit;
  wire dirty;
  wire [4:0] tag_out;

  // --- States ---
  // this makes it easier to read the code
  localparam IDLE       = 5'b00000;
  localparam ERR        = 5'b00001;
  localparam DONE       = 5'b00010;
  localparam COMP_RD    = 5'b00011;
  localparam COMP_WR    = 5'b00100;
  localparam MEM_WR     = 5'b00101;
  localparam STORE_DONE = 5'b00110;
  localparam WB0        = 5'b00111;
  localparam WB1        = 5'b01000;
  localparam WB2        = 5'b01001;
  localparam WB3        = 5'b01010;
  localparam READ0      = 5'b01011;
  localparam READ1      = 5'b01100;
  localparam READ2      = 5'b01101;
  localparam READ3      = 5'b01111;
  localparam STORE0     = 5'b10000;
  localparam STORE1     = 5'b10001;
  localparam STORE2     = 5'b10010;
  localparam STORE3     = 5'b10011;
  localparam WAIT0      = 5'b10100;
  localparam WAIT1      = 5'b10101;
  localparam WAIT2      = 5'b10110;
  localparam WAIT3      = 5'b10111;

  // --- Code ---
  // tmp vars to make output code more readable
  assign victimway_in = n_victim ? ~victimway : victimway;
  assign access_victim_in = comp ? victim : access_victim;
  // couldn't figure out how to do this with regs
  dff dff0 (.q(victimway), .d(victimway_in), .clk(clk), .rst(rst));
  dff dff1 (.q(access_victim), .d(access_victim_in), .clk(clk), .rst(rst));

  // need to do it like this otherwise it doesn't pass
  assign addr_mem = {tmp_tag, tmp_addr[10:3], tmp_offset};
  assign tag_in = tmp_addr[15:11];
  assign index = tmp_addr[10:3];
  assign offset = tmp_addr[2:0];

  // convert values to work with the case statement
  assign valid =  valid0 | valid1;
  assign hit = (hit0 & valid0) | (hit1 & valid1);
  assign dirty = hit ? ((hit0 & valid0) ? dirty0 : dirty1) :
                       (comp ? (victim ? dirty1 : dirty0) :
                               (access_victim ? dirty1 : dirty0));
  // outputs that don't belong in the case
  assign DataOut = 
    hit ? ((hit0 & valid0) ? data_out_cache0 : data_out_cache1) :
          (comp ? (victim ? data_out_cache1 : data_out_cache0) :
                  (access_victim ? data_out_cache1 : data_out_cache0));
  assign tag_out = 
    hit ? ((hit0 & valid0) ? tag_out0 : tag_out1) :
          (comp ? (victim ? tag_out1 : tag_out0) :
                  (access_victim ? tag_out1 : tag_out0));
  // change the case statement output to use two caches
  assign write_cache0 = 
    (hit0 & valid0) ? write_cache :
                      comp ? 1'b0 :
                             access_victim ? 1'b0 : write_cache;
  assign write_cache1 = 
    (hit1 & valid1) ? write_cache :
                      comp ? 1'b0 :
                             access_victim ? write_cache : 1'b0;

  always @(*) begin
    Done = 1'b0;
    Stall = 1'b1;
    CacheHit = 1'b0;
    enable = 1'b0;
    comp = 1'b0;
    data_in_cache = DataIn;
    write_cache = 1'b0;
    data_in_mem = DataOut;
    read_mem = 1'b0;
    write_mem = 1'b0;
    tmp_tag = Addr[15:11];
    tmp_addr = Addr;
    tmp_offset = 3'b000;
    victim = ((~hit0 &  hit1) | (valid0 & ~valid1)) ? 1'b1 : 
              ( hit0 & ~hit1) ? 1'b0 :
              (valid0 &  valid1) ? victimway : 1'b0;
    n_victim = 1'b0;
    
    case(state)
      IDLE: begin
        Stall = 1'b0;
        enable = 1'b1;
        n_state = (~Rd & ~Wr) ? IDLE :
                  ( Rd & ~Wr) ? COMP_RD :
                  (~Rd &  Wr) ? COMP_WR : ERR;
      end
      ERR: begin
        n_state = (Rd & Wr) ? ERR : IDLE;
      end
      DONE: begin
        Done = 1'b1;
        CacheHit = 1'b1;
        Stall = 1'b0;
        enable = 1'b1;
        n_victim = 1'b1;
        n_state = (~Rd &  Wr) ? COMP_WR :
                  ( Rd & ~Wr) ? COMP_RD : IDLE;
      end
      COMP_RD: begin
        enable = 1'b1;
        comp = 1'b1;
        n_state = (  valid &  hit)           ? DONE :
                  ((~valid | ~hit) & ~dirty) ? READ0 : WB0;
      end
      COMP_WR: begin
        enable = 1'b1;
        comp = 1'b1;
        write_cache = 1'b1;
        n_state = (  valid &  hit)           ? DONE :
                  ((~valid | ~hit) & ~dirty) ? READ0 : WB0;
      end
      MEM_WR: begin
        enable = 1'b1;
        comp = 1'b1;
        write_cache = 1'b1;
        n_state = STORE_DONE;
      end
      STORE_DONE: begin
        Done = 1'b1;
        Stall = 1'b0;
        enable = 1'b1;
        n_victim = 1'b1;
        n_state = (~Rd &  Wr) ? COMP_WR :
                  ( Rd & ~Wr) ? COMP_RD : IDLE;
      end
      WB0: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_addr = {Addr[15:3], 3'b000};
        n_state = (stall_mem) ? WB0 : WB1;
      end
      WB1: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_addr = {Addr[15:3], 3'b010};
        tmp_offset = 3'b010;
        n_state = (stall_mem) ? WB1 : WB2;
      end
      WB2: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_addr = {Addr[15:3], 3'b100};
        tmp_offset = 3'b100;
        n_state = (stall_mem) ? WB2 : WB3;
      end
      WB3: begin
        enable = 1'b1;
        write_mem = 1'b1;
        tmp_tag = tag_out;
        tmp_addr = {Addr[15:3], 3'b110};
        tmp_offset = 3'b110;
        n_state = (stall_mem) ? WB2 : READ0;
      end
      READ0: begin 
        read_mem = 1'b1;
        n_state = (stall_mem) ? READ0 : WAIT0;
      end
      WAIT0: begin
        read_mem = 1'b1;
        n_state = STORE0;
      end
      STORE0: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_addr = {Addr[15:3], 3'b000};
        n_state = READ1;
      end
      READ1: begin
        read_mem = 1'b1;
        tmp_offset = 3'b010;
        n_state = (stall_mem) ? READ1 : WAIT1;
      end
      WAIT1: begin
        read_mem = 1'b1;
        n_state = STORE1;
      end
      STORE1: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_addr = {Addr[15:3], 3'b010};
        tmp_offset = 3'b010;
        n_state = READ2;
      end
      READ2: begin
        read_mem = 1'b1;
        tmp_offset = 3'b100;
        n_state = (stall_mem) ? READ2 : WAIT2;
      end
      WAIT2: begin
        read_mem = 1'b1;
        n_state = STORE2;
      end
      STORE2: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_addr = {Addr[15:3], 3'b100};
        tmp_offset = 3'b100;
        n_state = READ3;
      end
      READ3: begin
        read_mem = 1'b1;
        tmp_offset = 3'b110;
        n_state = (stall_mem) ? READ3 : WAIT3;
      end
      WAIT3: begin
        read_mem = 1'b1;
        n_state = STORE3;
      end
      STORE3: begin
        enable = 1'b1;
        data_in_cache = data_out_mem;
        write_cache = 1'b1;
        tmp_addr = {Addr[15:3], 3'b110};
        tmp_offset = 3'b110;
        n_state = (~Rd & Wr) ? MEM_WR : STORE_DONE;
      end
      default: begin // should never reach
      end
    endcase
  end

endmodule
