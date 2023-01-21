module fifo_buffer_bank 
	#(
	parameter DEPTH_WIDTH = 2,
  parameter DATA_WIDTH = 8,
  parameter NUM_BANKS = 15
  )
  (	
	input clk,
	input rst,
	input [1:0] if_fifo_ctrl, of_fifo_ctrl,
	output [1:0] if_fifo_resp, of_fifo_resp,
	input [DATA_WIDTH-1:0] wr_if_data_i [2*NUM_BANKS-1:0],
  output [DATA_WIDTH-1:0] rd_if_data_o_1 [NUM_BANKS-1:0],
  output [DATA_WIDTH-1:0] rd_if_data_o_2 [NUM_BANKS-1:0],
  input [2*DATA_WIDTH-1:0] wr_of_data_i [NUM_BANKS-1:0],
	output [2*DATA_WIDTH-1:0] rd_of_data_o [NUM_BANKS-1:0]
);

  wire wire_if_wr_en_i, wire_if_rd_en_i, 
  	wire_if_full_o, wire_if_empty_o;

  wire wire_of_wr_en_i, wire_of_rd_en_i, 
    wire_of_full_o, wire_of_empty_o;

  assign wire_if_wr_en_i = if_fifo_ctrl[0];
  assign wire_if_rd_en_i = if_fifo_ctrl[1];
  assign if_fifo_resp[0] = wire_if_full_o;
  assign if_fifo_resp[1] = wire_if_empty_o;

  assign wire_of_wr_en_i = of_fifo_ctrl[0];
  assign wire_of_rd_en_i = of_fifo_ctrl[1];
  assign of_fifo_resp[0] = wire_of_full_o;
  assign of_fifo_resp[1] = wire_of_empty_o;

  generate
  	genvar i;
    //genvar j;
    //genvar k;
    //j=0;
    //k=0;
  	for(i=0; i<2*NUM_BANKS; i=i+1) begin

  		if(i%2==0) begin
      fifo #(.DEPTH_WIDTH(4),
              .NUM_MEM    (NUM_BANKS),
    				.DATA_WIDTH(DATA_WIDTH))
      
    	fifo_if_1(
    						.clk(clk),
    						.rst(rst),
    						.wr_data_i(wr_if_data_i[i%2]),
    						.rd_data_o(rd_if_data_o_1[i%2]),
    						.wr_en_i(wire_if_wr_en_i),
  							.rd_en_i(wire_if_rd_en_i),
    						.full_o(wire_if_full_o),
    						.empty_o(wire_if_empty_o)
    					);
      end
      else if(i%2!=0) begin
      fifo #(.DEPTH_WIDTH(4),
              .NUM_MEM    (NUM_BANKS),
    				.DATA_WIDTH(DATA_WIDTH))
      fifo_if_2(
                .clk(clk),
    						.rst(rst),
    						.wr_data_i(wr_if_data_i[i%2]),
    						.rd_data_o(rd_if_data_o_2[i%2]),
    						.wr_en_i(wire_if_wr_en_i),
  							.rd_en_i(wire_if_rd_en_i),
    						.full_o(wire_if_full_o),
    						.empty_o(wire_if_empty_o)
              );
      end
      fifo #(
        .DEPTH_WIDTH(4),
        .NUM_MEM    (NUM_BANKS),
        .DATA_WIDTH(2*DATA_WIDTH))
      fifo_of(
                .clk(clk),
                .rst(rst),
                .wr_data_i(wr_of_data_i[i]),
                .rd_data_o(rd_of_data_o[i]),
                .wr_en_i(wire_of_wr_en_i),
                .rd_en_i(wire_of_rd_en_i),
                .full_o(wire_of_full_o),
                .empty_o(wire_of_empty_o)
              );
    end 
  endgenerate

endmodule : fifo_buffer_bank