module PE #(parameter DATA_WIDTH = 8)     

         (input clk, rst,
          input actn_in_sel, wt_in_sel, add_in_sel, pe_out_sel,
          input if_rf_wr_en,
          input wt_rf_wr_en,
          input of_rf_wr_en,
          input mult_en, mult_load, acc_wr_en, add_en,
          input acc_clr,
          input [DATA_WIDTH-1:0] actn_in, 
          input [DATA_WIDTH-1:0] filt_in,           
          output reg [2*DATA_WIDTH-1:0] pe_out,  
          output reg [1:0] pe_resp    
         );   

  wire [DATA_WIDTH-1:0] conv_actn_in, pool_actn_in;
  wire [DATA_WIDTH-1:0] conv_wt_in, conv_bias_in;

  wire [2*DATA_WIDTH-1:0] add_in;
  reg [2*DATA_WIDTH-1:0] pool_val;
  reg [2*DATA_WIDTH-1:0] conv_acc, mult_out, add_out;
  wire [2*DATA_WIDTH-1:0] wire_add_out;

  wire [DATA_WIDTH-1:0] if_rf_rd_data, if_rf_wr_data;
  wire [DATA_WIDTH-1:0] wt_rf_rd_data, wt_rf_wr_data;
  wire [2*DATA_WIDTH-1:0] of_rf_rd_data, of_rf_wr_data;

  assign if_rf_wr_data = actn_in;
  assign wt_rf_wr_data = filt_in;

  regfile #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  if_regfile (
    .clk(clk),
    .wr_en  (if_rf_wr_en),
    .rd_data(if_rf_rd_data),
    .wr_data(if_rf_wr_data)
  );

  regfile #(
    .DATA_WIDTH(DATA_WIDTH)
  )
  wt_regfile (
    .clk    (clk),
    .wr_en  (wt_rf_wr_en),
    .rd_data(wt_rf_rd_data),
    .wr_data(wt_rf_wr_data)
  );

  mux1to2 #(.DATA_WIDTH(DATA_WIDTH))
  mux_actn_sel (
                .in(if_rf_rd_data),
                .sel(actn_in_sel),
                .out({conv_actn_in,pool_actn_in})
              );

  mux1to2 #(.DATA_WIDTH(DATA_WIDTH))
  mux_filt_sel (
                .in(wt_rf_rd_data),
                .sel(wt_in_sel),
                .out({conv_wt_in,conv_bias_in})
              );

    booth_multiplier mult_inst(
        .clk      (clk),
        .start    (mult_en),
        .load     (mult_load),
        .prod     (mult_out),
        .done     (pe_resp[0]),
        .mc       (conv_actn_in),
        .mp       (conv_wt_in)
        );

  
  mux2to1 #(.DATA_WIDTH(2*DATA_WIDTH))
  mux_add_in_sel (
                  .in({{8'b0,conv_bias_in},mult_out}),
                  .sel(add_in_sel),
                  .out(add_in)
                );

    serial_adder addr_inst(
      .clk   (clk),
      .start (add_en),
      .data_a(add_in),
      .data_b(conv_acc),
      .out   (add_out),
      .done  (pe_resp[1])
    );

  assign wire_add_out = add_out;

  regfile #(
    .DATA_WIDTH(2*DATA_WIDTH)
  )
  acc_regfile (
    .clk    (clk),
    .wr_en  (acc_wr_en),
    .rd_data(conv_acc),
    .wr_data(wire_add_out)
  );

  always@(posedge clk) begin

    // if(acc_clr==1'b0)
    //   conv_acc <= add_out;
    // // else
     if(acc_clr==1'b1) begin
      conv_acc <= 0;
      //add_out <= 0;
    end

    // if(mult_en==1'b1) begin
    //   mult_out <= conv_actn_in * conv_wt_in;
    //   pe_resp[0] <= 1'b1;
    // end 

    // if(add_en==1'b1) begin
    //   add_out <= add_in + conv_acc;
    //   pe_resp[1] <= 1'b1;
    // end

    if(pool_actn_in >= pool_val)
      pool_val <= pool_actn_in;
  end 

  mux2to1 #(.DATA_WIDTH(2*DATA_WIDTH))
  mux_pe_out_sel (
                .in({pool_val,conv_acc}),
                .sel(pe_out_sel),
                .out(of_rf_wr_data)
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