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

   wire err_cache, err_mem;


   wire [4:0] state, n_state;

   // -- in --
   // cache
   wire [4:0] tag_out;
   wire [15:0] data_out_cache;
   wire hit;
   wire dirty;
   wire valid;
   // mem
   wire [15:0] data_out_mem;
   wire stall_mem;
   // -- out --
   // cache
   wire enable;
   wire [4:0] tag_in;
   wire [7:0] index;
   wire [2:0] offset;
   wire comp;
   wire [15:0] data_in_cache;
   wire write_cache;
   // mem
   wire [15:0] addr_mem;
   wire [15:0] data_in_mem;
   wire read_mem, write_mem;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (data_out_cache),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (err_cache),
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
                          .write                (write_cache),
                          .valid_in             (valid_in));

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
  assign err = err_cache | err_mem;

  dff dff0 [4:0] (.q(state), .d(n_state), .clk(clk), .rst(rst));

  cache_fsm logic (
    .state(state),
    .n_state(n_state),
    // mem_system - in
    .addr(Addr), 
    .data_in(DataIn), 
    .read(Rd), 
    .write(Wr), 
    // cache = in
    .tag_out(tag_out), 
    .data_out_cache(data_out_cache), 
    .hit(hit), 
    .dirty(dirty), 
    .valid(valid),
    // mem - in
    .data_out_mem(data_out_mem), 
    .stall_mem(stall_mem), 

    // mem_system - out
    .data_out(DataOut), 
    .done(Done), 
    .stall(Stall), 
    .cache_hit(CacheHit), 
    // cache - out
    .enable(enable), 
    .tag_in(tag_in), 
    .index(index), 
    .offset(offset), 
    .comp(comp), 
    .data_in_cache(data_in_cache), 
    .write_cache(write_cache), 
    .valid_in(valid_in), 
    // mem - out
    .addr_mem(addr_mem), 
    .data_in_mem(data_in_mem), 
    .read_mem(read_mem), 
    .write_mem(write_mem));
   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
