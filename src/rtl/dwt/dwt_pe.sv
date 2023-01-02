module PE #(parameter DATA_WIDTH)
(
    input clk,
    input rst,
    input[DATA_WIDTH-1:0] transform1,
    input[DATA_WIDTH-1:0] transform2,
    input[DATA_WIDTH-1:0] transform3,
    input[DATA_WIDTH-1:0] transform4,
    input[DATA_WIDTH-1:0] transform5,
    input[DATA_WIDTH-1:0] transform6,
    input[DATA_WIDTH-1:0] data_in1,
    input[DATA_WIDTH-1:0] data_in2,
    input[DATA_WIDTH-1:0] data_in3,
    input[DATA_WIDTH-1:0] data_in4,
    input[DATA_WIDTH-1:0] data_in5,
    input[DATA_WIDTH-1:0] data_in6,
    output reg [DATA_WIDTH-1:0] data_out
);
    wire[31:0] result1;
    multiplier mult1(
        .clk(clk),
        .a_operand(transform1),
        .b_operand(data_in1),
        .result(result1)
    );

    wire[31:0] result2;
    multiplier mult2(
        .clk(clk),
        .a_operand(transform2),
        .b_operand(data_in2),
        .result(result2)
    );

    wire[31:0] result3;
    multiplier mult3(
        .clk(clk),
        .a_operand(transform3),
        .b_operand(data_in3),
        .result(result3)
    );

    wire[31:0] result4;
    multiplier mult4(
        .clk(clk),
        .a_operand(transform4),
        .b_operand(data_in4),
        .result(result4)
    );

    wire[31:0] result5;
    multiplier mult5(
        .clk(clk),
        .a_operand(transform5),
        .b_operand(data_in5),
        .result(result5)
    );
    wire[31:0] result6;
    multiplier mult6(
        .clk(clk),
        .a_operand(transform6),
        .b_operand(data_in6),
        .result(result6)
    );

    wire[31:0] result7;
    adder add1(
        .clk(clk),
        .a_operand(result1),
        .b_operand(result2),
        .AddBar_Sub(1'b0),
        .result(result7)
    );

    wire[31:0] result8;
    adder add2(
        .clk(clk),
        .a_operand(result3),
        .b_operand(result4),
        .AddBar_Sub(1'b0),
        .result(result8)
    );   

    wire[31:0] result9;
    adder add3(
        .clk(clk),
        .a_operand(result5),
        .b_operand(result6),
        .AddBar_Sub(1'b0),
        .result(result9)
    );  

    wire[31:0] result10;
    adder add4(
        .clk(clk),
        .a_operand(result7),
        .b_operand(result8),
        .AddBar_Sub(1'b0),
        .result(result10)
    ); 
    
    wire[31:0] result11;
    adder add5(
        .clk(clk),
        .a_operand(result9),
        .b_operand(result10),
        .AddBar_Sub(1'b0),
        .result(result11)
    ); 
    always @(posedge clk) begin
        if(rst)
            data_out<=32'b0;
        else
            data_out<=result11;
    end
endmodule