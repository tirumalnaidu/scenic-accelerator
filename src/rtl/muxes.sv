module mux_param
 #( parameter inputs = 4,
    parameter width = 8 )
  ( output reg [width-1:0] out,
    input  sel[inputs],
    input  [width-1:0] in[inputs] );

    always_comb
    begin
        out = {width{1'b0}};
        for (int index = 0; index < inputs; index=index+1)
        begin
            out |= {width{sel[index]}} & in[index];
        end
    end
endmodule

module mux2to1 #(parameter DATA_WIDTH = 8)			
 (
	input [DATA_WIDTH-1:0] in [1:0],
	input sel,
	output [DATA_WIDTH-1:0] out
);

  assign out = sel ? in[0] : in[1];

endmodule : mux2to1

module mux1to2 #(parameter DATA_WIDTH = 8)      
 (
  input [DATA_WIDTH-1:0] in,
  input sel,
  output reg [DATA_WIDTH-1:0] out [1:0]
);

always @(in or sel) begin
  case (sel)
    1'b0: begin
      out[0] <= in;
      out[1] <= 0;
    end
    1'b1: begin
      out[0] <= 0;
      out[1] <= in;
    end
  endcase 
end
endmodule : mux1to2
 
module mux_4x1 #(parameter DATA_WIDTH = 8)      
 (
  input [DATA_WIDTH-1:0] in [3:0],
  input [1:0] sel ,
  output [DATA_WIDTH-1:0] out
);

  wire [DATA_WIDTH-1:0] mux_out [1:0];

  mux2to1 mux_1 ({in[0],in[1]}, sel[1], mux_out[0]);
  mux2to1 mux_2 ({in[2],in[3]}, sel[1], mux_out[1]);
  mux2to1 mux_3 ({mux_out[0],mux_out[1]}, sel[0], out);

endmodule : mux_4x1 

module demux_1x4
 (
    input  [7:0] in,               // 1 Input
    input  [1:0] sel,       // Select
    output reg [7:0] out [3:0]       // 4 Outputs
);

always @ (in or sel) begin
    case(sel)
        2'b00 : begin
            out[0] <= in;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
        end

        2'b01 : begin
            out[0] <= 8'bz;
            out[1] <= in;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
        end

        2'b10 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= in;
            out[3] <= 8'bz;
        end

        2'b11 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= in;
        end
      endcase
    end
endmodule : demux_1x4

module demux_1x15 
  (
    input  [7:0] in,               // 1 Input
    input  [3:0] sel,       // Select
    output reg [7:0] out [14:0]      
);

always @ (in or sel) begin
    case(sel)
        4'b0000 : begin
            out[0] <= in;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0001 : begin
            out[0] <= 8'bz;
            out[1] <= in;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0010 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= in;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0011 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= in;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0100 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= in;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0101 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= in;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0110 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= in;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b0111 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= in;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b1000 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= in;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
        end

        4'b1001 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= in;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
          end

        4'b1010 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= in;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
            end

        4'b1011 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= in;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
            end

        4'b1100 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= in;
            out[13] <= 8'bz;
            out[14] <= 8'bz;
            end

        4'b1101 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= in;
            out[14] <= 8'bz;
            end

        4'b1110 : begin
            out[0] <= 8'bz;
            out[1] <= 8'bz;
            out[2] <= 8'bz;
            out[3] <= 8'bz;
            out[4] <= 8'bz;
            out[5] <= 8'bz;
            out[6] <= 8'bz;
            out[7] <= 8'bz;
            out[8] <= 8'bz;
            out[9] <= 8'bz;
            out[10] <= 8'bz;
            out[11] <= 8'bz;
            out[12] <= 8'bz;
            out[13] <= 8'bz;
            out[14] <= in;
            end

    endcase
end

endmodule