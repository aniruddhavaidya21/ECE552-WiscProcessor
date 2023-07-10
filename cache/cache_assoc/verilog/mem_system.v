/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   // --- mem_system ---
  wire err_cache0, err_cache1, err_mem;
  wire [4:0] state, n_state;

  // --- Cache ---
  // outputs
  wire [4:0] tag_out0, tag_out1;
  wire [15:0] data_out_cache0, data_out_cache1;
  wire hit0, hit1;
  wire dirty0, dirty1;
  wire valid0, valid1;
  // inputs
  wire enable;
  wire [4:0] tag_in;
  wire [7:0] index;
  wire [2:0] offset;
  wire [15:0] data_in_cache;
  wire comp;
  wire write_cache0, write_cache1;

  // --- Memory ---
  // outputs
  wire [15:0] data_out_mem;
  wire stall_mem;
  // inputs
  wire [15:0] addr_mem;
  wire [15:0] data_in_mem;
  wire read_mem, write_mem;

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

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out0),
                          .data_out             (data_out_cache0),
                          .hit                  (hit0),
                          .dirty                (dirty0),
                          .valid                (valid0),
                          .err                  (err_cache0),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in_cache),
                          .comp                 (comp),
                          .write                (write_cache0),
                          .valid_in             (1'b1));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (data_out_cache1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (err_cache1),
                          // Inputs
                          .enable               (enable),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in_cache),
                          .comp                 (comp),
                          .write                (write_cache1),
                          .valid_in             (1'b1));

   four_bank_mem mem(// Outputs
                     .data_out          (data_out_mem),
                     .stall             (stall_mem),
                     .busy              (),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (addr_mem),
                     .data_in           (data_in_mem),
                     .wr                (write_mem),
                     .rd                (read_mem));
   
   // your code here
  assign err = err_cache0 | err_cache1 | err_mem;

  dff dff0 [4:0] (.q(state), .d(n_state), .clk(clk), .rst(rst));

  cache_fsm logic (
    .state(state),
    .n_state(n_state),
    .clk(clk), 
    .rst(rst),
    // mem_system - in
    .Addr(Addr), 
    .DataIn(DataIn), 
    .Rd(Rd), 
    .Wr(Wr), 
    // cache = in
    .tag_out0(tag_out0), 
    .tag_out1(tag_out1),
    .data_out_cache0(data_out_cache0),
    .data_out_cache1(data_out_cache1), 
    .hit0(hit0),
    .hit1(hit1), 
    .dirty0(dirty0), 
    .dirty1(dirty1),
    .valid0(valid0),
    .valid1(valid1),
    // mem - in
    .data_out_mem(data_out_mem), 
    .stall_mem(stall_mem), 
    // mem_system - out
    .DataOut(DataOut), 
    .Done(Done), 
    .Stall(Stall), 
    .CacheHit(CacheHit), 
    // cache - out
    .enable(enable), 
    .tag_in(tag_in), 
    .index(index), 
    .offset(offset), 
    .comp(comp), 
    .data_in_cache(data_in_cache), 
    .write_cache0(write_cache0), 
    .write_cache1(write_cache1),
    // mem - out
    .addr_mem(addr_mem), 
    .data_in_mem(data_in_mem), 
    .read_mem(read_mem), 
    .write_mem(write_mem));
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
