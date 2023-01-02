module dnn_hw_top #(parameter X_DIM=15,
                    parameter Y_DIM=15,
                    parameter DATA_WIDTH=8)
                  
              ( input clk,
                input rst,
                input start, done, 
                input [2:0] fsm_input,
                input [DATA_WIDTH-1:0] sram_if_in [X_DIM-1:0],
                input [DATA_WIDTH-1:0] sram_wt_in,
                output [2*DATA_WIDTH-1:0] sram_of_out [X_DIM-1:0]
              );

  wire [DATA_WIDTH-1:0] actn_buf_wr_data [X_DIM-1:0][Y_DIM-1:0];
  wire [DATA_WIDTH-1:0] actn_buf_rd_data [X_DIM-1:0][Y_DIM-1:0];

  wire [DATA_WIDTH-1:0] wt_buf_wr_data;
  wire [DATA_WIDTH-1:0] wt_buf_rd_data;

  wire [DATA_WIDTH-1:0] pe_of_out [X_DIM-1:0][Y_DIM-1:0];
  wire [DATA_WIDTH-1:0] pe_wt_in;

  wire [DATA_WIDTH-1:0] fifo_wr_data_in [X_DIM-1:0];
  wire [2*DATA_WIDTH-1:0] fifo_rd_data_out [X_DIM-1:0];

  wire [DATA_WIDTH-1:0] buf2pe_if_in [X_DIM-1:0];
  wire [DATA_WIDTH-1:0] buf2pe_wt_in;
  wire [2*DATA_WIDTH-1:0] pe2buf_of_out [X_DIM-1:0];


wire [1:0] if_fifo_ctrl, wt_fifo_ctrl, of_fifo_ctrl;
wire [1:0] if_fifo_resp, wt_fifo_resp, of_fifo_resp;
wire [3:0] pe_mux_ctrl;
wire [4:0] pe_compute_ctrl;
wire [1:0] pe_resp;

wire  pe_if_rf_ctrl [1:0][Y_DIM-1:0];
wire  pe_wt_rf_ctrl [1:0];
wire  pe_of_rf_ctrl [1:0][Y_DIM-1:0];

  ml_ctrl_fsm #(
    .X_DIM(X_DIM),
    .Y_DIM(Y_DIM)
  )
  ml_ctrl_fsm_inst (
    .clk            (clk),
    .rst            (rst),
    .start          (start),
    .done           (done),
    .fsm_input     (fsm_input),
    .pe_mux_ctrl    (pe_mux_ctrl),
    .pe_compute_ctrl(pe_compute_ctrl),
    .pe_resp        (pe_resp),
    .pe_if_rf_ctrl  (pe_if_rf_ctrl),
    .if_fifo_ctrl   (if_fifo_ctrl),
    .if_fifo_resp   (if_fifo_resp),
    .of_fifo_ctrl   (of_fifo_ctrl),
    .of_fifo_resp   (of_fifo_resp),
    .pe_wt_rf_ctrl  (pe_wt_rf_ctrl),
    .pe_of_rf_ctrl  (pe_of_rf_ctrl)
  );

  pe_array #(
    .X_DIM(X_DIM),
    .Y_DIM(Y_DIM),
    .DATA_WIDTH(DATA_WIDTH)
  ) 
  pe_array_inst (
    .rst            (rst),
    .clk            (clk),
    .pe_mux_ctrl    (pe_mux_ctrl),
    .pe_compute_ctrl(pe_compute_ctrl),
    .pe_if_rf_ctrl  (pe_if_rf_ctrl),
    .pe_wt_rf_ctrl  (pe_wt_rf_ctrl),
    .pe_of_rf_ctrl  (pe_of_rf_ctrl),
    .actn_in        (buf2pe_if_in),
    .filt_in        (sram_wt_in),
    .pe_out         (pe2buf_of_out),
    .pe_resp        (pe_resp)
  );

  fifo_buffer_bank #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH_WIDTH(Y_DIM),
    .NUM_BANKS(X_DIM)
  )
  fifo_buf_bk_inst (
    .clk      (clk),
    .rst      (rst),
    .if_fifo_ctrl(if_fifo_ctrl),
    .if_fifo_resp(if_fifo_resp),
    .of_fifo_ctrl(of_fifo_ctrl),
    .of_fifo_resp(of_fifo_resp),
    .wr_if_data_i(sram_if_in),
    .rd_if_data_o(buf2pe_if_in),
    .wr_of_data_i(pe2buf_of_out),
    .rd_of_data_o(sram_of_out)
  );

endmodule

