
module pe_array #(parameter X_DIM = 15,
                  parameter Y_DIM = 15,
                  parameter DATA_WIDTH = 8)
                  
              ( input clk,
                input rst,
                input [3:0] pe_mux_ctrl,
                input [5:0] pe_compute_ctrl,
                output [2:0] pe_resp,
                input pe_if_rf_ctrl [1:0][Y_DIM-1:0],
                input pe_wt_rf_ctrl [1:0],
                input pe_of_rf_ctrl [1:0][Y_DIM-1:0],
                input [DATA_WIDTH-1:0] actn_in_1 [Y_DIM-1:0],
                input [DATA_WIDTH-1:0] actn_in_2 [Y_DIM-1:0],
                input [DATA_WIDTH-1:0] filt_in_1,
                input [DATA_WIDTH-1:0] filt_in_2,
                output reg [2*DATA_WIDTH-1:0] pe_out [X_DIM-1:0]
              );
  
  wire wire_actn_in_sel, wire_wt_in_sel, wire_add_in_sel, wire_pe_out_sel;
  wire wire_mult_en, wire_add_en_1, wire_add_en_2, wire_acc_clr, wire_mult_load, wire_acc_wr_en;

  wire wire_if_rf_wr_en [Y_DIM-1:0];
  wire wire_wt_rf_wr_en; 
  wire wire_of_rf_wr_en [Y_DIM-1:0];

  assign wire_actn_in_sel = pe_mux_ctrl[0];
  assign wire_wt_in_sel   = pe_mux_ctrl[1];
  assign wire_add_in_sel = pe_mux_ctrl[2];
  assign wire_pe_out_sel = pe_mux_ctrl[3];

  assign wire_mult_en = pe_compute_ctrl[0];
  assign wire_add_en_1 = pe_compute_ctrl[1];
  assign wire_acc_clr = pe_compute_ctrl[2];
  assign wire_mult_load = pe_compute_ctrl[3];
  assign wire_acc_wr_en = pe_compute_ctrl[4];
  assign wire_add_en_2 = pe_compute_ctrl[5];

  assign wire_if_rf_wr_en = pe_if_rf_ctrl[0];

  assign wire_wt_rf_wr_en = pe_wt_rf_ctrl[0];

  assign wire_of_rf_wr_en = pe_of_rf_ctrl[0];

  wire [2*DATA_WIDTH-1:0] pe_final_out [X_DIM-1:0][Y_DIM-1:0];
  wire pe2buf_of_sel [X_DIM-1:0][Y_DIM-1:0];

  generate
    genvar i;
      for(i=0; i<X_DIM; i=i+1) begin

      genvar j;
        for(j=0; j<Y_DIM; j=j+1) begin

        PE #(
          .DATA_WIDTH(DATA_WIDTH)
        ) 
        pe_inst (
          .clk        (clk), 
          .rst        (rst),
          .actn_in_sel(wire_actn_in_sel),
          .wt_in_sel  (wire_wt_in_sel),
          .add_in_sel (wire_add_in_sel),
          .pe_out_sel (wire_pe_out_sel),
          .acc_wr_en  (wire_acc_wr_en),
          .if_rf_wr_en(wire_if_rf_wr_en[j]),
          .wt_rf_wr_en(wire_wt_rf_wr_en),
          .of_rf_wr_en(wire_of_rf_wr_en[j]),
          .mult_load  (wire_mult_load),
          .mult_en    (wire_mult_en),
          .add_en_1   (wire_add_en_1),
          .add_en_2   (wire_add_en_2),
          .acc_clr    (wire_acc_clr),
          .actn_in_1  (actn_in_1[i]),
          .actn_in_2  (actn_in_2[i]),
          .filt_in_1  (filt_in_1),
          .filt_in_2  (filt_in_2),
          .pe_out     (pe_final_out[i][j]),
          .pe_resp    (pe_resp)
        );
        end

        // mux_param #(
        //   .inputs(Y_DIM),
        //   .width(2*DATA_WIDTH)
        // )
        // mux_pe2buf_of (
        //   .in(pe_final_out[i][Y_DIM-1:0]),
        //   .sel(pe2buf_of_sel[i][Y_DIM-1:0]),
        //   .out(pe_out[i])
        // );
      end
  endgenerate

    always@(posedge clk) 
      pe_out <= pe_final_out;

endmodule
