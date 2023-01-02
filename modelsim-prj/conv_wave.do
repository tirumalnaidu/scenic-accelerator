onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {CLOCK & RESET}
add wave -noupdate /conv_tb_v2/dnn_hw_top_inst/clk
add wave -noupdate /conv_tb_v2/dnn_hw_top_inst/rst
add wave -noupdate -divider TOP
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/start
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/done
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/sram_if_in[3]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/sram_if_in[2]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/sram_if_in[1]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/sram_if_in[0]} -radix decimal}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/sram_if_in[3]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/sram_if_in[2]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/sram_if_in[1]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/sram_if_in[0]} {-height 17 -radix decimal}} /conv_tb_v2/dnn_hw_top_inst/sram_if_in
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/sram_of_out
add wave -noupdate -radix decimal /conv_tb_v2/sram_of_out
add wave -noupdate -divider FSM
add wave -noupdate /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/rst
add wave -noupdate -radix unsigned /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/state
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/start
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/done
add wave -noupdate -radix unsigned /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/fsm_input
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/if_data_idx
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/pe_compute_ctrl
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/pe_mux_ctrl
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/of_fifo_ctrl_reg
add wave -noupdate -divider MEM
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/genblk1[3]/fifo_if/fifo_ram/mem}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/genblk1[2]/fifo_if/fifo_ram/mem}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/genblk1[1]/fifo_if/fifo_ram/mem}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/genblk1[0]/fifo_if/fifo_ram/mem}
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wire_if_wr_en_i
add wave -noupdate -divider {FIFO BUFFER}
add wave -noupdate /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/if_fifo_ctrl
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wire_if_full_o
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wire_if_empty_o
add wave -noupdate /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/of_fifo_ctrl
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[3]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[2]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[1]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[0]} -radix decimal}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[3]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[2]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[1]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i[0]} {-height 17 -radix decimal}} /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_if_data_i
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[3]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[2]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[1]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[0]} -radix decimal}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[3]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[2]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[1]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o[0]} {-height 17 -radix decimal}} /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_if_data_o
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wr_of_data_i
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/rd_of_data_o
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wire_if_wr_en_i
add wave -noupdate -radix decimal /conv_tb_v2/dnn_hw_top_inst/fifo_buf_bk_inst/wire_if_rd_en_i
add wave -noupdate -divider PE_ARRAY
add wave -noupdate -radix binary -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[3]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[2]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[1]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[0]} -radix binary}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[3]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[2]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[1]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl[0]} {-height 17 -radix binary}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_mux_ctrl
add wave -noupdate -radix binary -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[4]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[3]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[2]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[1]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[0]} -radix binary}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[4]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[3]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[2]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[1]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl[0]} {-height 17 -radix binary}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_compute_ctrl
add wave -noupdate -radix binary -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[1]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0]} -radix binary -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][3]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][2]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][1]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][0]} -radix binary}}}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[1]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0]} {-height 17 -radix binary -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][3]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][2]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][1]} -radix binary} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][0]} -radix binary}}} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][3]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][2]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][1]} {-height 17 -radix binary} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl[0][0]} {-height 17 -radix binary}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_if_rf_ctrl
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_wt_rf_ctrl
add wave -noupdate -radix binary /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_of_rf_ctrl
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[3]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[2]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[1]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[0]} -radix decimal}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[3]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[2]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[1]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in[0]} {-height 17 -radix decimal}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/actn_in
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[7]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[6]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[5]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[4]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[3]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[2]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[1]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[0]} -radix decimal}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[7]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[6]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[5]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[4]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[3]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[2]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[1]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in[0]} {-height 17 -radix decimal}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/filt_in
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[3]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[2]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[1]} -radix decimal} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[0]} -radix decimal}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[3]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[2]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[1]} {-height 17 -radix decimal} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out[0]} {-height 17 -radix decimal}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_out
add wave -noupdate -radix decimal -childformat {{{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[3]} -radix unsigned} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[2]} -radix unsigned} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[1]} -radix unsigned} {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[0]} -radix unsigned}} -subitemconfig {{/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[3]} {-height 17 -radix unsigned} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[2]} {-height 17 -radix unsigned} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[1]} {-height 17 -radix unsigned} {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out[0]} {-height 17 -radix unsigned}} /conv_tb_v2/dnn_hw_top_inst/pe_array_inst/pe_final_out
add wave -noupdate -divider PE-IF-DATA
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[3]/genblk1[3]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[3]/genblk1[2]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[3]/genblk1[1]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[3]/genblk1[0]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[2]/genblk1[3]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[2]/genblk1[2]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[2]/genblk1[1]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[2]/genblk1[0]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[1]/genblk1[3]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[1]/genblk1[2]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[1]/genblk1[1]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[1]/genblk1[0]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[3]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[2]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[1]/pe_inst/if_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/if_rf_rd_data}
add wave -noupdate -divider mult
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/clk}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/mc}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/mp}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/start}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/load}
add wave -noupdate -radix unsigned {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/count}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/done}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_inst/prod}
add wave -noupdate -divider add
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/clk}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/data_a}
add wave -noupdate -radix unsigned {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/data_b}
add wave -noupdate {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/piso_a/memory}
add wave -noupdate {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/piso_b/memory}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/cin}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/start}
add wave -noupdate {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/enable}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/done}
add wave -noupdate -radix unsigned {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/count}
add wave -noupdate {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/cout}
add wave -noupdate -radix unsigned {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/addr_inst/out}
add wave -noupdate -divider PE-00
add wave -noupdate -radix unsigned /conv_tb_v2/dnn_hw_top_inst/ml_ctrl_fsm_inst/state
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/conv_actn_in}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/conv_wt_in}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_en}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/add_en}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/acc_wr_en}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/acc_clr}
add wave -noupdate -radix binary {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/pe_resp}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/mult_out}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/add_in}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/conv_acc}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/add_out}
add wave -noupdate {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/of_rf_wr_en}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/of_rf_rd_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/of_rf_wr_data}
add wave -noupdate -radix decimal {/conv_tb_v2/dnn_hw_top_inst/pe_array_inst/genblk1[0]/genblk1[0]/pe_inst/pe_out}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {59760 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 426
configure wave -valuecolwidth 217
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 5
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {5777316 ps} {8911720 ps}
