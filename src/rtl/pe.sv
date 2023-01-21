module PE #(parameter DATA_WIDTH = 8)     

         (input clk, rst,
          input actn_in_sel, wt_in_sel, add_in_sel, pe_out_sel,
          input if_rf_wr_en,
          input wt_rf_wr_en,
          input of_rf_wr_en,
          input mult_en, mult_load, acc_wr_en, add_en_1, add_en_2,
          input acc_clr,
          input [DATA_WIDTH-1:0] actn_in_1, 
          input [DATA_WIDTH-1:0] filt_in_1,
          input [DATA_WIDTH-1:0] actn_in_2,
          input [DATA_WIDTH-1:0] filt_in_2,         
          output reg [2*DATA_WIDTH-1:0] pe_out,  
          output reg [2:0] pe_resp    
         );   

  wire [DATA_WIDTH-1:0] conv_actn_in_1, conv_actn_in_2, pool_actn_in_1, pool_actn_in_2;
  wire [DATA_WIDTH-1:0] conv_wt_in_1, conv_wt_in_2, conv_bias_in_1, conv_bias_in_2;

  wire [2*DATA_WIDTH-1:0] add_in_1, add_in_2;
  reg [2*DATA_WIDTH-1:0] pool_val_1, pool_val_2;
  reg [2*DATA_WIDTH-1:0] conv_acc_1, conv_acc_2, mult_out_1, mult_out_2, add_out_1, add_out_2, add_out;
  wire [2*DATA_WIDTH-1:0] wire_add_out_1, wire_add_out_2;

  wire [DATA_WIDTH-1:0] if_rf_rd_data_1, if_rf_rd_data_2, if_rf_wr_data_1, if_rf_wr_data_2;
  wire [DATA_WIDTH-1:0] wt_rf_rd_data_1, wt_rf_rd_data_2, wt_rf_wr_data_1, wt_rf_wr_data_2;
  wire [2*DATA_WIDTH-1:0] of_rf_rd_data, of_rf_wr_data, of_rf_wr_data_1, of_rf_wr_data_2;
  wire mult_temp_1, mult_temp_2, sum_temp_1, sum_temp_2;

  assign if_rf_wr_data_1 = actn_in_1;
  assign if_rf_rd_data_2 = actn_in_2;
  assign wt_rf_wr_data_1 = filt_in_1;
  assign wt_rf_wr_data_2 = filt_in_2;

  regfile #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  if_regfile_1 (
    .clk(clk),
    .wr_en  (if_rf_wr_en),
    .rd_data(if_rf_rd_data_1),
    .wr_data(if_rf_wr_data_1)
  );
  regfile #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  if_regfile_2 (
    .clk(clk),
    .wr_en  (if_rf_wr_en),
    .rd_data(if_rf_rd_data_2),
    .wr_data(if_rf_wr_data_2)
  );

  regfile #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  wt_regfile_1 (
    .clk    (clk),
    .wr_en  (wt_rf_wr_en),
    .rd_data(wt_rf_rd_data_1),
    .wr_data(wt_rf_wr_data_1)
  );

  regfile #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  wt_regfile_2 (
    .clk    (clk),
    .wr_en  (wt_rf_wr_en),
    .rd_data(wt_rf_rd_data_2),
    .wr_data(wt_rf_wr_data_2)
  );
  mux1to2 #(.DATA_WIDTH(DATA_WIDTH))
  mux_actn_sel_1 (
                .in(if_rf_rd_data_1),
                .sel(actn_in_sel),
                .out({conv_actn_in_1,pool_actn_in_1})
              );
  mux1to2 #(.DATA_WIDTH(DATA_WIDTH))
  mux_actn_sel_2 (
                .in(if_rf_rd_data_2),
                .sel(actn_in_sel),
                .out({conv_actn_in_2,pool_actn_in_2})
              );

  mux1to2 #(.DATA_WIDTH(DATA_WIDTH))
  mux_filt_sel_1 (
                .in(wt_rf_rd_data_1),
                .sel(wt_in_sel),
                .out({conv_wt_in_1,conv_bias_in_1})
              );
  
  mux1to2 #(.DATA_WIDTH(DATA_WIDTH))
  mux_filt_sel_2 (
                .in(wt_rf_rd_data_2),
                .sel(wt_in_sel),
                .out({conv_wt_in_2,conv_bias_in_2})
              );

    booth_multiplier mult_inst_1(
        .clk      (clk),
        .start    (mult_en),
        .load     (mult_load),
        .prod     (mult_out_1),
        .done     (mult_temp_1),
        .mc       (conv_actn_in_1),
        .mp       (conv_wt_in_1)
        );
    booth_multiplier mult_inst_2(
        .clk      (clk),
        .start    (mult_en),
        .load     (mult_load),
        .prod     (mult_out_2),
        .done     (mult_temp_2),
        .mc       (conv_actn_in_2),
        .mp       (conv_wt_in_2)
        );
  assign pe_resp[0] = mult_temp_1 & mult_temp_2;
  
  mux2to1 #(.DATA_WIDTH(2*DATA_WIDTH))
  mux_add_in_sel_1 (
                  .in({{8'b0,conv_bias_in_1},mult_out_1}),
                  .sel(add_in_sel),
                  .out(add_in_1)
                );
  mux2to1 #(.DATA_WIDTH(2*DATA_WIDTH))
  mux_add_in_sel_2 (
                  .in({{8'b0,conv_bias_in_2},mult_out_2}),
                  .sel(add_in_sel),
                  .out(add_in_2)
                );

    serial_adder addr_inst_1(
      .clk   (clk),
      .start (add_en_1),
      .data_a(add_in_1),
      .data_b(conv_acc_1),
      .out   (add_out_1),
      .done  (sum_temp_1)
    );

  assign wire_add_out_1 = add_out_1;
    serial_adder addr_inst_2(
      .clk   (clk),
      .start (add_en_1),
      .data_a(add_in_2),
      .data_b(conv_acc_2),
      .out   (add_out_2),
      .done  (sum_temp_2)
    );
  assign pe_resp[1] = sum_temp_1 & sum_temp_2;
  assign wire_add_out_2 = add_out_2;
  // regfile #(
  //   .DATA_WIDTH(2*DATA_WIDTH)
  // )
  // acc_regfile (
  //   .clk    (clk),
  //   .wr_en  (acc_wr_en),
  //   .rd_data(conv_acc),
  //   .wr_data(wire_add_out)
  // );

reg [2*DATA_WIDTH-1:0] acc_reg_1;
reg [2*DATA_WIDTH-1:0] acc_reg_2;
always @(posedge clk) begin
    if (acc_wr_en) begin
        acc_reg_1 <= wire_add_out_1;
        acc_reg_2 <= wire_add_out_2;
    end
      else if (acc_clr) begin
        acc_reg_1 <= 0;
        acc_reg_2 <= 0;
      end
end
    
  assign conv_acc_1 = acc_reg_1;
  assign conv_acc_2 = acc_reg_2;

  always@(posedge clk) begin

    // if(acc_clr==1'b0)
    //   conv_acc <= add_out;
    // // else
    //  if(acc_clr==1'b1) begin
    //   conv_acc <= 0;
    //   //add_out <= 0;
    // end

    // if(mult_en==1'b1) begin
    //   mult_out <= conv_actn_in * conv_wt_in;
    //   pe_resp[0] <= 1'b1;
    // end 

    // if(add_en==1'b1) begin
    //   add_out <= add_in + conv_acc;
    //   pe_resp[1] <= 1'b1;
    // end

    if(pool_actn_in_1 >= pool_val_1)
      pool_val_1 <= pool_actn_in_1;
    if(pool_actn_in_2 >= pool_val_2)
      pool_val_2 <= pool_actn_in_2;
  end 

  mux2to1 #(.DATA_WIDTH(2*DATA_WIDTH))
  mux_pe_out_sel_1 (
                .in({pool_val_1,conv_acc_1}),
                .sel(pe_out_sel),
                .out(of_rf_wr_data_1)
              );
  mux2to1 #(.DATA_WIDTH(2*DATA_WIDTH))
  mux_pe_out_sel_2 (
                .in({pool_val_2,conv_acc_2}),
                .sel(pe_out_sel),
                .out(of_rf_wr_data_2)
              );
  serial_adder final_addr(
    .clk(clk),
    .start(add_en_2),
    .data_a(of_rf_wr_data_1),
    .data_b(of_rf_wr_data_2),
    .out(of_rf_wr_data),
    .done(pe_resp[2])
  );

  regfile #(
    .DATA_WIDTH(2*DATA_WIDTH)
  )
  of_regfile (
    .clk    (clk),
    .wr_en  (of_rf_wr_en),
    .rd_data(of_rf_rd_data),
    .wr_data(of_rf_wr_data)
  );

  assign pe_out = of_rf_wr_data;

endmodule