module multiplier(
    input clk,
		input [31:0] a_operand,
		input [31:0] b_operand,
		output reg Exception,Overflow,Underflow,
		output reg [31:0] result
		);



reg sign,product_round,normalised,zero;
reg [8:0] exponent,sum_exponent;
reg [22:0] product_mantissa;
reg [23:0] operand_a,operand_b;
reg [47:0] product,product_normalised; 

wire sign1,product_round1,normalised1,zero1;////
wire [8:0] exponent1,sum_exponent1;//
wire [22:0] product_mantissa1;
wire [23:0] operand_a1,operand_b1;//
wire [47:0] product1,product_normalised1;//
wire Exception1,Overflow1,Underflow1;//
wire [31:0] result1;
reg [31:0] res1,res2,res3;

assign sign1 = a_operand[31] ^ b_operand[31];

//Exception flag sets 1 if either one of the exponent is 255.
assign Exception1 = (&a_operand[30:23]) | (&b_operand[30:23]);

//Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1

assign operand_a1 = (|a_operand[30:23]) ? {1'b1,a_operand[22:0]} : {1'b0,a_operand[22:0]};

assign operand_b1 = (|b_operand[30:23]) ? {1'b1,b_operand[22:0]} : {1'b0,b_operand[22:0]};

assign product1 = operand_a * operand_b;			//Calculating Product

assign product_round1 = |product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.

assign normalised1 = product[47] ? 1'b1 : 1'b0;	

assign product_normalised1 = normalised ? product : product << 1;	//Assigning Normalised value based on 48th bit

//Final Manitssa.
assign product_mantissa1 = product_normalised[46:24] + {21'b0,(product_normalised[23] & product_round)};

assign zero1 = Exception ? 1'b0 : (product_mantissa == 23'd0) ? 1'b1 : 1'b0;

assign sum_exponent1 = a_operand[30:23] + b_operand[30:23];

assign exponent1 = sum_exponent - 8'd127 + normalised;


assign Overflow1 = ((exponent[8] & !exponent[7]) & !zero) ; //If overall exponent is greater than 255 then Overflow condition.


//Exception Case when exponent reaches its maximu value that is 384.

//If sum of both exponents is less than 127 then Underflow condition.
assign Underflow1 = ((exponent[8] & exponent[7]) & !zero) ? 1'b1 : 1'b0; 


assign result1 = Exception ? 32'd0 : zero ? {sign,31'd0} : Overflow ? {sign,8'hFF,23'd0} : Underflow ? {sign,31'd0} : {sign,exponent[7:0],product_mantissa};
always@(posedge clk)
begin
  sign<=sign1;
  Exception<=Exception1;
  operand_a<=operand_a1;
  operand_b<=operand_b1;
  product<=product1;
  product_round<=product_round1;
  normalised<=normalised1;
  product_normalised<=product_normalised1;
  product_mantissa<=product_mantissa1;
  zero<=zero1;
  sum_exponent<=sum_exponent1;
  exponent<=exponent1;
  Overflow<=Overflow1;
  Underflow<=Underflow1;
  
  res1<=result1;
  res2<=res1;
  res3<=res2;
  result<=res3;
end


endmodule

