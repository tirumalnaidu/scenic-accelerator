/******************************************************************************
 This Source Code Form is subject to the terms of the
 Open Hardware Description License, v. 1.0. If a copy
 of the OHDL was not distributed with this file, You
 can obtain one at http://juliusbaxter.net/ohdl/ohdl.txt

 Description:
 Simple single clocked dual port ram (separate read and write ports),
 with optional bypass logic.

 Copyright (C) 2012 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

 ******************************************************************************/

module simple_dpram_sclk
  #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter NUM_MEM = 15,
    parameter ENABLE_BYPASS = 1
    )
   (
    input clk,
    input [ADDR_WIDTH-1:0]  raddr,
    input rd_en,
    input [ADDR_WIDTH-1:0]  waddr,
    input wr_en,
    input [DATA_WIDTH-1:0]  din,
    output [DATA_WIDTH-1:0] dout
    );

   reg [DATA_WIDTH-1:0] mem[(NUM_MEM)-1:0];
   reg [DATA_WIDTH-1:0] rdata;

generate
if (ENABLE_BYPASS) begin : bypass_gen
   reg [DATA_WIDTH-1:0]     din_r;
   reg 			    bypass;

   assign dout = bypass ? din_r : rdata;

   always @(posedge clk)
     if (rd_en)
       din_r <= din;

   always @(posedge clk)
     if (waddr == raddr && wr_en && rd_en)
       bypass <= 1;
     else if (rd_en)
       bypass <= 0;
  end 
  else begin
   assign dout = rdata;
end
endgenerate

   always @(posedge clk) begin
      if (wr_en)
	      mem[waddr] <= din;
      if (rd_en)
	      rdata <= mem[raddr];
   end

endmodule
