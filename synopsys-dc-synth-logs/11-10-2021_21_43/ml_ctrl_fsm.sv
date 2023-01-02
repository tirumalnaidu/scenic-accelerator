module ml_ctrl_fsm #(
	parameter X_DIM = 15,
  	parameter Y_DIM = 15
)
(
	input clk,
	input rst,
	input start,
	input [2:0] fsm_input,
	output reg done,
	input [1:0] pe_resp,
  	output reg [3:0] pe_mux_ctrl,
  	output reg [4:0] pe_compute_ctrl,
  	output reg  pe_if_rf_ctrl [1:0][Y_DIM-1:0],
  	output reg  pe_wt_rf_ctrl [1:0],
  	output reg  pe_of_rf_ctrl [1:0][Y_DIM-1:0],
	input [1:0] if_fifo_resp, of_fifo_resp,
	output reg [1:0] if_fifo_ctrl, of_fifo_ctrl
);

	// FSM states
	localparam S0 = 3'b000;
	localparam S1 = 3'b001;
	localparam S2 = 3'b010;
	localparam S3 = 3'b011;
	localparam S4 = 3'b100;
	localparam S5 = 3'b101;
	localparam S6 = 3'b110;
	localparam S7 = 3'b111;

	// FSM inputs
	localparam DEFAULT          = 3'b001; 
	localparam LD_WT_SRAM2PE    = 3'b010; 
	localparam LD_IF_SRAM2BUF   = 3'b011; 
	localparam LD_IF_BUF2PE 	= 3'b100; 
	localparam DNNEXEC 	        = 3'b101;
	localparam UNLD_OF_PE2BUF   = 3'b110;  
	localparam UNLD_OF_BUF2SRAM = 3'b111; 

	reg [2:0] state, next_state;
	reg [1:0] if_fifo_ctrl_reg;
	reg [1:0] of_fifo_ctrl_reg;
	reg [6:0] if_data_idx, of_data_idx;

	assign if_fifo_ctrl = if_fifo_ctrl_reg;
	assign of_fifo_ctrl = of_fifo_ctrl_reg;

	always@(posedge clk) begin
			state <= next_state;
	end

	always@(*) begin

		if(rst) begin
			if_data_idx=0;
			of_data_idx=0;
			next_state <= S1;
			pe_compute_ctrl[2] <= 1'b1;
		end
		else if(start) begin
			if_data_idx=0;
			of_data_idx=0;
			next_state <= S1;
		end

		case(state)

			S0: begin
				if(fsm_input==LD_WT_SRAM2PE) begin
					if_fifo_ctrl_reg[0] <= 1'b0;
					next_state <= S1;
				end
				else if(fsm_input==LD_IF_SRAM2BUF) begin
					if_fifo_ctrl_reg[0] <= 1'b0;	
					next_state <= S2;
				end
				else if(fsm_input==LD_IF_BUF2PE) begin
					pe_if_rf_ctrl[0][if_data_idx] <= 1'b1;	
					if_fifo_ctrl_reg[1] <= 1'b0;
					next_state <= S4;
				end
				else if(fsm_input==UNLD_OF_PE2BUF) begin
					pe_of_rf_ctrl[0][of_data_idx] <= 1'b1;	
					next_state <= S6;
				end
				else if(fsm_input==DNNEXEC) begin
					if(pe_resp[0]==1'b1 && pe_resp[1]==1'b0) begin
						pe_compute_ctrl[0] <= 1'b0;
				 		pe_compute_ctrl[1] <= 1'b0;
				 		pe_compute_ctrl[2] <= 1'b0;
				 		pe_compute_ctrl[3] <= 1'b0;
				 		pe_compute_ctrl[4] <= 1'b1;
					end
					else if(pe_resp[0]==1'b1 && pe_resp[1]==1'b1) begin
						next_state <= S5;
					end
				end

				if(if_fifo_resp[0]==1'b1) begin
					next_state <= S3;
				end
			end

			S1: begin
				if(fsm_input==LD_WT_SRAM2PE) begin
					pe_wt_rf_ctrl[0] <= 1'b1;
					next_state <= S2;
				end
			end

			S2: begin 	
				if(fsm_input==LD_IF_SRAM2BUF) begin 
					if_fifo_ctrl_reg[0] <= 1'b1;
				 	
					next_state <= S0;
				end
												
			end

			S3: begin 
				pe_mux_ctrl <= 4'b1111;

				if(fsm_input==LD_IF_BUF2PE) begin
					if_fifo_ctrl_reg[1] <= 1'b1;
					next_state <= S0;
				end
			 end 

			S4: begin
				if(fsm_input==LD_IF_BUF2PE) begin
					pe_if_rf_ctrl[0][if_data_idx] <= 1'b0;
					if_data_idx = if_data_idx + 1;	
					next_state <= S3;
				end

				if(if_fifo_resp[1]==1'b1) begin
					pe_if_rf_ctrl[0][if_data_idx] <= 1'b0;
				 	pe_compute_ctrl[0] <= 1'b0;
				 	pe_compute_ctrl[1] <= 1'b1;
				 	pe_compute_ctrl[2] <= 1'b0;
				 	pe_compute_ctrl[3] <= 1'b1;
				 	pe_compute_ctrl[4] <= 1'b0;
				 	next_state <= S5;
				 end 
			end

			S5: begin 
				if(fsm_input==DNNEXEC) begin

					if(pe_resp[0]==1'b0 && pe_resp[1]==1'b0) begin
						pe_compute_ctrl[0] <= 1'b1;
					 	pe_compute_ctrl[1] <= 1'b1;
					 	pe_compute_ctrl[2] <= 1'b0;
					 	pe_compute_ctrl[3] <= 1'b0;
					 	pe_compute_ctrl[4] <= 1'b0;
					 end
					else if(pe_resp[0]==1'b1 & pe_resp[1]==1'b0) begin
						pe_compute_ctrl[0] <= 1'b0;
					 	pe_compute_ctrl[1] <= 1'b1;
					 	pe_compute_ctrl[2] <= 1'b0;
					 	pe_compute_ctrl[3] <= 1'b0;
					 	pe_compute_ctrl[4] <= 1'b0;
					 	next_state <= S0;
					 end
					else if(pe_resp[1]==1'b1) begin
						pe_compute_ctrl[0] <= 1'b0;
				 		pe_compute_ctrl[1] <= 1'b0;
				 		pe_compute_ctrl[2] <= 1'b0;
				 		pe_compute_ctrl[3] <= 1'b0;
				 		pe_compute_ctrl[4] <= 1'b1;	
						next_state <= S0;
					end
			  	end 
			end

			S6: begin 
				if(fsm_input==UNLD_OF_PE2BUF) begin
					pe_of_rf_ctrl[0][of_data_idx] <= 1'b0;
					of_data_idx = of_data_idx + 1;		
					next_state <= S0;
				end
			end

		endcase
	end

endmodule
