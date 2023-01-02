module booth_multiplier(
	output signed  [15:0] prod, 
	output done, 
	input signed [7:0] mc, mp, 
	input clk, start, load
	); 

reg signed [7:0] A, Q, M; 
reg Q_1, done_reg; 
reg [3:0] count;  
wire signed [7:0] sum, difference;  

always @(posedge clk) begin    
	if (load) begin       
		A <= 8'b0;             
		M <= mc;       
		Q <= mp;       
		Q_1 <= 1'b0;             
		count <= 4'b0;
		done_reg <= 0;    
	end    
	else if(start) begin       
		case ({Q[0], Q_1})          
			2'b0_1 : {A, Q, Q_1} <= {sum[7], sum, Q};          
			2'b1_0 : {A, Q, Q_1} <= {difference[7], difference, Q};          
			default: {A, Q, Q_1} <= {A[7], A, Q};       
		endcase       
		count <= count + 1'b1;  
	end 
end 


	alu adder (sum, A, M, 1'b0); 
	alu subtracter (difference, A, ~M, 1'b1);  
	assign prod = {A, Q};
	assign done = load ? 0 : !(count < 8);  
endmodule   

module alu(out, a, b, cin); 
	output signed [7:0] out; 
	input signed[7:0] a; 
	input signed[7:0] b; 
	input cin;  
	assign out = a + b + cin;  
endmodule 