module regfile #(parameter DATA_WIDTH = 8)  

    (input clk, 
     input wr_en, 
     input [DATA_WIDTH-1:0] wr_data,
     output  [DATA_WIDTH-1:0] rd_data);

reg [DATA_WIDTH-1:0] reg_file;

always @(posedge clk) begin
    if (wr_en)
        reg_file <= wr_data;
end
    assign rd_data = reg_file;
endmodule

