`timescale 1 ns / 1ps


/*-----------------------------------------------------------------------
Limitations: 
  1. Strides greater than 1
  2. Only output activtion dims with multiple of X_DIM & Y_DIM works
  3. Convolutions with out dims lower than MAC array size doesn't work.
-------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------
To-Do:
  1. If output dim are less than MAC dim, multiple channels to be calculated 
  at same time.
-------------------------------------------------------------------------*/


/*-----------------------------------------------------------------------

SPARK MODEL CONVOLUTION LAYERS PROPERTIES
  Input: 1 x 240 x 240 x 32  | Filter:  8 x 1 x 1 x 32  | Output: 1 x 240 x 240 x 8  | Stride: 1 | Total clk cycles: 131072
  Input: 1 x 120 x 120 x 64  | Filter: 16 x 1 x 1 x 64  | Output: 1 x 120 x 120 x 16 | Stride: 1 | Total clk cycles: 131072
  Input: 1 x  60 x  60 x 128 | Filter: 32 x 1 x 1 x 128 | Output: 1 x  60 x  60 x 32 | Stride: 1 | Total clk cycles: 131072
  Input: 1 x  30 x  30 x 256 | Filter: 64 x 1 x 1 x 256 | Output: 1 x  30 x  30 x 64 | Stride: 1 | Total clk cycles: 131072
  Input: 1 x  15 x  15 x 512 | Filter: 64 x 1 x 1 x 512 | Output: 1 x  15 x  15 x 64 | Stride: 1 | Total clk cyclsim: 65536

------------------------------------------------------------------------*/

/*

Pre-conv            : 1 x 120 x 120 x 1 | 1 x 3 x 3 x 32 | 1 x 120 x 120 x 32 (padded) = 2119680
# cycle_count:     1622880
# op_count:     6350400

Spark-1:
  squeeze1x1        : 1 x 60 x 60 x 32 | 32 x 1 x 1 x 8  | 1 x 60 x 60 x 8 = 634880 cycle_count:      456320 cycle_count:       28520
  expand1x1         : 1 x 60 x 60 x 8  |  8 x 1 x 1 x 32 | 1 x 60 x 60 x 32 = 634880

  sepconv_expand3x3 : 1 x 60 x 60 x 8  |  8 x 3 x 3 x 1  | 1 x 60 x 60 x 8 (padded) = 634880+59520
                      1 x 60 x 60 x 8  | 32 x 1 x 1 x 8  | 1 x 60 x 60 x 32


Spark-2:
  squeeze1x1        : 1 x 30 x 30 x 64 | 16 x 1 x 1 x 64 | 1 x 30 x 30 x 16 = 634880
  expand1x1         : 1 x 30 x 30 x 16 | 64 x 1 x 1 x 16 | 1 x 30 x 30 x 64 = 634880

  sepconv_expand3x3 : 1 x 30 x 30 x 16 | 16 x 3 x 3 x 1  | 1 x 30 x 30 x 16 (padded) = 
                      1 x 30 x 30 x 16 | 64 x 1 x 1 x 16 | 1 x 30 x 30 x 64 = 


Spark-3:
  squeeze1x1        : 1 x 15 x 15 x 128 |  32 x 1 x 1 x 128 | 1 x 15 x 15 x 32 = 634880
  expand1x1         : 1 x 15 x 15 x 32  | 128 x 1 x 1 x 32  | 1 x 15 x 15 x 128 = 634880

  sepconv_expand3x3 : 1 x 15 x 15 x 32  |  32 x 3 x 3 x 1   | 1 x 15 x 15 x 32 (padded) = 
                      1 x 15 x 15 x 32  | 128 x 1 x 1 x 32  | 1 x 15 x 15 x 128

3809280


Clock period = 9.606 x 10^-10 seconds = 0.9606 ns
*/
// Total cycles: 83

module conv_tb();

    `define NULL 0

    `define DEBUG 1

    // Accelerator parameters
    parameter X_DIM = 4;
    parameter Y_DIM = 4;
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH_WIDTH = 2;

    // Convolution layer parameters
    parameter actn_h = 10;
    parameter actn_w = 10;
    parameter actn_c = 2;

    parameter filt_h = 3;
    parameter filt_w = 3;
    parameter filt_c = 2;
    parameter num_filt = 2;

    parameter stride = 1;

    parameter out_h = ((actn_h - filt_h)/stride)+1;
    parameter out_w = ((actn_w - filt_w)/stride)+1;
    parameter out_c = num_filt;

    parameter blk_h = out_h/Y_DIM;
    parameter blk_w = out_w/X_DIM;
  


	parameter DEFAULT          = 3'b001; 
	parameter LD_WT_SRAM2PE    = 3'b010; 
	parameter LD_IF_SRAM2BUF   = 3'b011; 
	parameter LD_IF_BUF2PE     = 3'b100; 
	parameter DNNEXEC          = 3'b101;
	parameter UNLD_OF_PE2BUF   = 3'b110;  
	parameter UNLD_OF_BUF2SRAM = 3'b111; 


	reg clk, rst;
	reg start, done;
	reg [2:0] fsm_input;
	wire fsm_output;
	reg [4:0] ctrl;
	reg [DATA_WIDTH-1:0] sram_if_in [X_DIM-1:0];
	reg [DATA_WIDTH-1:0] sram_wt_in;
	wire [2*DATA_WIDTH-1:0] sram_of_out [X_DIM-1:0][Y_DIM-1:0];

	reg [2*DATA_WIDTH-1:0] conv_out [out_h-1:0][out_w-1:0];
	
	dnn_hw_top #(
		.X_DIM(X_DIM),
		.Y_DIM(Y_DIM),
		.DATA_WIDTH(DATA_WIDTH),
		.FIFO_DEPTH_WIDTH(FIFO_DEPTH_WIDTH)
	) 
	dnn_hw_top_inst (
		.clk(clk),
		.rst(rst),
		.start(start),
		.done(done),
		.fsm_input  (fsm_input),
		.sram_if_in(sram_if_in),
		.sram_wt_in(sram_wt_in),
		.sram_of_out(sram_of_out)
	);

	integer filt_file, actn_file, out_file, ref_out_file;
	integer debug_actn_file, debug_filt_file;

	int filt_data [num_filt*filt_h*filt_w*filt_c-1:0];
	int actn_data [actn_h*actn_w*actn_c-1:0];
	int out_data [blk_h-1:0][blk_w-1:0][out_c-1:0][out_h-1:0][out_w-1:0];

	int ref_out_data [out_c-1:0][out_h-1:0][out_w-1:0];

	int args;

	int actn_in [blk_h-1:0][blk_w-1:0][actn_c*actn_h*actn_w-1:0];

	int p, temp_px,temp_py;

	int actn_load_w, actn_load_h;
	int out_load_w, out_load_h;

	int cycle_count = 0;
	int op_count = 0;
	int s1_c=0, s2_c=0, s3_c=0, s4_c=0, s5_c=0, s6_c=0, s7_c=0, s8_c=0, s9_c=0;

	int runs = 0;

	int mode = 0, blk_mode = 1, single_mode = 2;
	int bk_h, bk_w;

	always #5 clk = ~clk;
	
	initial begin

		// modify the file path according to your system
		$display("blk_h: %d, blk_w = %d", blk_h, blk_w);
		filt_file = $fopen("src/test-data/test_filt_data.txt", "r");
		if (filt_file == `NULL) begin
		$display("filt_file handle was NULL");
		$finish;
		end

		// modify the file path according to your system
		actn_file = $fopen("src/test-data/test_actn_data.txt", "r");
		if (actn_file == `NULL) begin
		$display("actn_file handle was NULL");
		$finish;
		end

		// modify the file path according to your system
		out_file = $fopen("src/test-data/test_out_data.txt", "w");
		if (out_file == `NULL) begin
		$display("out_file handle was NULL");
		$finish;
		end

		// modify the file path according to your system
		ref_out_file = $fopen("src/test-data/ref_test_out_data.txt", "r");
		if (ref_out_file == `NULL) begin
		$display("ref_out_file handle was NULL");
		$finish;
		end

		// debug_actn_file = $fopen("/home/tirumal/Research-projects/brain-tumour-seg-hardware/src/data/debug_actn_data.txt", "w");
		// if (debug_actn_file == `NULL) begin
		//   $display("ref_out_file handle was NULL");
		//   $finish;
		// end

		// debug_filt_file = $fopen("/home/tirumal/Research-projects/brain-tumour-seg-hardware/src/data/debug_filt_data.txt", "w");
		// if (debug_filt_file == `NULL) begin
		//   $display("ref_out_file handle was NULL");
		//   $finish;
		// end

		for(int i=0; i < num_filt*filt_h*filt_w*filt_c; i++) 
		args = $fscanf(filt_file, "%d\n", filt_data[i]);

		for(int i=0; i < actn_h*actn_w*actn_c; i++)
		args = $fscanf(actn_file, "%d\n", actn_data[i]);
		//$display("%d",actn_data[i]);

		for(int n=0; n < out_c; n++) begin
			for(int h=0; h < out_h; h++) begin
				for(int w=0; w < out_w; w++) begin
					$fscanf(ref_out_file, "%d\n", ref_out_data[n][h][w]);
				end 
			end 
		end 

		clk = 0;
		rst = 1;
		#15;

		rst = 0;
		ctrl[3:0] = 4'b1111;
		#10;
		
		if(out_h>X_DIM && out_w>Y_DIM) begin 
			mode=blk_mode;
			$display("mode: block mode");
		end
		else begin
			mode=single_mode;
			$display("mode: single mode");
		end


		if(mode==blk_mode) begin
			bk_h = blk_h;
			bk_w = blk_w;

			actn_load_w = X_DIM;
			actn_load_h = Y_DIM; 

			out_load_h = Y_DIM;
			out_load_w = X_DIM;
		end 
		else if(mode==single_mode) begin
			bk_h = 1;
			bk_w = 1;

			actn_load_w = actn_w;
			actn_load_h = actn_h;

			out_load_h = out_h;
			out_load_w = out_w;
		end

		// $display("out_h = %d, out_w = %d", out_h, out_w);
		// $display("bk_h = %d, bk_w = %d", bk_h, bk_w);
	
		for(int bh=0; bh < bk_h; bh++) begin     
			for(int bw=0; bw < bk_w; bw++) begin 
				//$display("actn_in----------------");
				p=0;
				for(int c=0; c < actn_c; c++) begin
					for(int h=0; h < actn_h; h++) begin
						for(int w=0; w < actn_w; w++) begin
							actn_in[bh][bw][p] = actn_data[w+h*actn_h+c*actn_w*actn_h+bh*Y_DIM+bw*actn_h*X_DIM];
							//$display("%d", actn_in[bh][bw][pix]);
							p++;
						end 
					end
				end
			end 
		end 

		for(int n=0; n<num_filt; n++) begin
			for(int bh=0; bh < bk_h; bh++) begin     
				for(int bw=0; bw < bk_w; bw++) begin
					runs++;
					$display("run: %d", runs); 
				
				
					for(int c=0; c < filt_c; c++) begin
						for(int w=0; w < filt_w; w++) begin
							for(int h=0; h < filt_h; h++) begin

								start = 1'b1;
								fsm_input=DEFAULT;    
								#10;

								start = 1'b0;
								fsm_input=DEFAULT;    
								#10;

								sram_wt_in = filt_data[h+(w*filt_h)+(c*filt_h*filt_w)+(n*filt_c*filt_h*filt_w)];       

								//$display("filt_in[]: %d", sram_wt_in);         
								fsm_input=LD_WT_SRAM2PE;
								#10;

								cycle_count = cycle_count +3;
								s1_c = s1_c + 1;
						
								for(int i=0; i<actn_load_w+1; i++) begin // why +1 ??
									temp_py = 0;
									for(int j=0; j<actn_load_h; j++) begin
										p = (i*actn_w*stride)+(j*stride)+(w*actn_w)+h+(c*actn_w*actn_h);
										//$display("%d %d %d %d %d", j, i, h, w, p);
										sram_if_in[temp_py] = actn_in[bh][bw][p]; 
										//$display("actn_in[%d]: %d", temp_py, sram_if_in[temp_py]);
										temp_py++;
									end
									//$display("\n");		
									fsm_input=LD_IF_SRAM2BUF;
									#20;
									cycle_count = cycle_count+2;
									s2_c = s2_c + 2;
								end 

								for(int i=0; i<actn_load_w+1; i++)  begin
									fsm_input=LD_IF_BUF2PE;
									#30;
									cycle_count = cycle_count+3;
									s3_c = s3_c + 3;
								end
								
								fsm_input=DNNEXEC;
								#270;
								op_count = op_count + 450;

								cycle_count = cycle_count+27;

								s5_c = s5_c + 27;


								fsm_input=DEFAULT;    
								#10;

								for(int i=0; i<actn_load_w+1; i++)  begin
									fsm_input=UNLD_OF_PE2BUF;
									#30;
									cycle_count = cycle_count+3;
									s3_c = s3_c + 3;
								end

								// $fwrite(debug_actn_file,"\n");
								// //Load weight data from memory bank to MAC array                
								// $fwrite(debug_filt_file,"%d",filt_in);

								if(w==0 && h==0 && c==0)
									ctrl[4] = 1'b1;
								else
									ctrl[4] = 1'b0;

								#20

								cycle_count += 2;
							end
							$fwrite(debug_filt_file,"\n"); 
						end
						$fwrite(debug_filt_file,"\n");
					end 
					$fwrite(debug_filt_file,"\n");

					//$display("--------------pe_out----------------");
					for(int h=0; h < out_load_w; h++) begin
						for(int w=0; w < out_load_h; w++) begin
							//$display("%d" ,sram_of_out[h][w]);
							out_data[bh][bw][n][h][w] = sram_of_out[w][h];
						end 
						//$display("\n");
					end
					//$display("\n"); 

					rst = 1;
					#15;

					rst = 0;
					ctrl[3:0] = 4'b1111;
					#10;

					//   for(int i=0; i<actn_load_w; i++)  begin
						//   fsm_input=UNLD_OF_PE2BUF;
						//   #30;
						//   cycle_count = cycle_count+3;
						//   s6_c = s6_c + 3;
					// end

				end
			end

		end


		$display("cycle_count: %d",cycle_count);
		$display("op_count: %d",op_count);
		$display("s1_c: %d",s1_c);
		$display("s2_c: %d",s2_c);
		$display("s3_c: %d",s3_c);
		$display("s4_c: %d",s4_c);
		$display("s5_c: %d",s5_c);
		$display("s6_c: %d",s6_c);
		$display("s7_c: %d",s7_c);



		for(int n=0; n < out_c; n++) begin
			for(int bw=0; bw < bk_w; bw++) begin 
				for(int h=0; h < out_load_h; h++) begin
					for(int bh=0; bh < bk_h; bh++) begin
						for(int w=0; w < out_load_w; w++) begin     
							$fwrite(out_file,"%d ",out_data[bh][bw][n][h][w]);
						end 
					end 
					$fwrite(out_file,"\n");
				end
			end 
			$fwrite(out_file,"\n");
		end

		for(int n=0; n < out_c; n++) begin
			temp_py=0;
			for(int bw=0; bw < bk_w; bw++) begin
				for(int h=0; h < out_load_h; h++) begin
					temp_px=0;
					for(int bh=0; bh < bk_h; bh++) begin					
						for(int w=0; w < out_load_w; w++) begin
							if(ref_out_data[n][temp_py][temp_px]!=out_data[bh][bw][n][h][w]) begin
								$display("------------------------------------------------\n");
								$display("                  TEST FAILED                   \n");
								$display("------------------------------------------------\n");
								$display("Incorrect output [Expected:%d, Inference:%d] at dim: [%d][%d][%d]\n",ref_out_data[n][h][w],out_data[bh][bw][n][h][w],n,h,w);
								$finish;
							end
							//$display("CORRECT: %d, %d", ref_out_data[n][h][w],out_data[bh][bw][n][h][w]);
							temp_px++;
						end 
					end
					temp_py++; 
				end
			end 
		end  

		$display("------------------------------------------------\n");
		$display("                  TEST PASSED                   \n");
		$display("------------------------------------------------\n");

		$display("Total number of cycles: %d", cycle_count);

		$finish;
 	end
endmodule
    
    
    
          

