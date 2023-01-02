module d_flipflop(d, clk, enable, start, out);
  input d, clk, enable, start;
  output out;

  reg out;

  always @ (posedge clk or posedge start) begin
    if (start)
      out <= 0;
    else if (enable)
        out <= d;
  end
endmodule

module full_adder(a, b, cin, sum, cout);
  input a, b, cin;
  output sum;
  output cout;

  assign {cout, sum} = a + b + cin;

endmodule

module piso(clk, enable, rst, data, out);
  input enable, clk, rst;
  input[7:0] data;
  output out;

  reg out;
  reg[7:0] memory;

  always @ (posedge clk, posedge rst) begin
    if (rst == 1'b1) begin
      out <= 1'b0;
      memory <= data;
    end
    else begin
      if (enable) begin
        out <= memory[0];
        memory <= memory >> 1'b1;
      end
    end
  end
endmodule

module serial_adder(data_a, data_b, clk, start, out, done);
  input[7:0] data_a, data_b;
  input clk, start;
  output done;
  output[7:0] out;

  reg[7:0] out;
  reg [3:0] count;
  reg enable, cout;
  wire wire_a, wire_b, cout_temp, cin, sum;

  piso piso_a(clk, enable, start, data_a, wire_a);
  piso piso_b(clk, enable, start, data_b, wire_b);
  full_adder adder(wire_a, wire_b, cin, sum, cout_temp);
  d_flipflop dff(cout_temp, clk, enable, start, cin);
  
  assign done=(count>8);

  always @ (posedge clk or posedge start) begin
    if (start) begin
      enable = 1; count = 4'b0; out = 8'b0;
    end
    else begin
      if (count > 4'b1000)
        enable = 0;
      else begin
        if (enable) begin
          cout = cout_temp;
          count = count + 1;
          out = out >> 1;
          out[7] = sum;
        end
      end
    end
  end
endmodule