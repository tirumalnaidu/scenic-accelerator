module dwt #(parameter X_DIM,
                  parameter Y_DIM,
                  parameter DATA_WIDTH)
                  
              ( input clk,
                input rst, 
                input [DATA_WIDTH-1:0] data_input [X_DIM-1:0][Y_DIM-1:0],
                input [DATA_WIDTH-1:0] transform_matrix [X_DIM-1:0][Y_DIM-1:0],
                output reg [DATA_WIDTH-1:0] comp_out [X_DIM-1:0][Y_DIM-1:0]
              );

              generate

                genvar i;
                for(i=0;i<X_DIM;i++)begin

                  genvar j;
                  for(j=0;j<Y_DIM;j++)begin
                    
                      PE #(.DATA_WIDTH(DATA_WIDTH))
                        mac_inst(
                          .clk(clk),
                          .rst(rst),
                          .transform1(transform_matrix[i][0]),
                          .transform2(transform_matrix[i][1]),
                          .transform3(transform_matrix[i][2]),
                          .transform4(transform_matrix[i][3]),
                          .transform5(transform_matrix[i][4]),
                          .transform6(transform_matrix[i][5]),
                          .data_in1(data_input[0][j]),
                          .data_in2(data_input[1][j]),
                          .data_in3(data_input[2][j]),
                          .data_in4(data_input[3][j]),
                          .data_in5(data_input[4][j]),
                          .data_in6(data_input[5][j]),
                          .data_out(comp_out[i][j])
                      );
                    end  
                  end
              endgenerate

        
endmodule