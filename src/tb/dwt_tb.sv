module dwt_tb();

        parameter X_DIM = 6;
        parameter Y_DIM = 6;
        parameter DATA_WIDTH = 32;

        parameter out_x = 240;
        parameter out_y = 240;  
        parameter out_z =4;

        reg clk,rst;
        reg [DATA_WIDTH-1:0] data_matrix [X_DIM-1:0][Y_DIM-1:0];
        reg [DATA_WIDTH-1:0] transform_matrix [X_DIM-1:0][Y_DIM-1:0];
        wire [DATA_WIDTH-1:0] comp_out [X_DIM-1:0][X_DIM-1:0];

        dwt #(.X_DIM(X_DIM),
                .Y_DIM(Y_DIM),
                .DATA_WIDTH(DATA_WIDTH))
        dwt_inst(
                        .clk(clk),
                        .rst(rst),
                        .data_input(data_matrix),
                        .transform_matrix(transform_matrix),
                        .comp_out(comp_out)
        );

        shortreal output_result[out_x-1:0][out_y-1:0][out_z-1:0];
        shortreal output_result_2[out_x-1:0][out_y-1:0][out_z-1:0];
        shortreal input_transform_matrix[out_x-1:0][out_y-1:0];
        shortreal input_data_matrix[out_x-1:0][out_y-1:0][out_z-1:0];
        shortreal input_transform_matrix_transpose[out_x-1:0][out_y-1:0];

        integer transform_file,data_file,out_file,dwt_out_file,transform_file2;
        int args;

        always #5 clk =~clk;
        initial begin
                clk=0;
                rst=1'b1;
                /////
                dwt_out_file=$fopen("F:/research interest docs/brain-tumour-seg-hardware-main/DWT_3/dwt_out_matrix_data.txt","w");
                if(dwt_out_file==0)begin
                        $display("out file handle was NULL");
                        $finish;
                end
                out_file=$fopen("F:/research interest docs/brain-tumour-seg-hardware-main/DWT_3/out_matrix_data.txt","w");
                if(out_file==0)begin
                        $display("out file handle was NULL");
                        $finish;
                end
                //////
                transform_file=$fopen("F:/research interest docs/brain-tumour-seg-hardware-main/DWT_3/transform_matrix_data.txt","r");
                if(transform_file==0)begin
                        $display("Transform Matrix was NULL");
                        $finish;
                end
                transform_file2=$fopen("F:/research interest docs/brain-tumour-seg-hardware-main/DWT_3/transform_matrix_data.txt","r");
                if(transform_file2==0)begin
                        $display("Transform Matrix was NULL");
                        $finish;
                end
                /////
                data_file=$fopen("F:/research interest docs/brain-tumour-seg-hardware-main/DWT_3/data_matrix_data.txt","r");
                if(data_file==0)begin
                        $display("No Image");
                        $finish;
                end
                /////
                for(int a=0;a<out_x;a++)begin
                        for(int b=0;b<out_y;b++)begin
                             args=$fscanf(transform_file,"%f\n",input_transform_matrix[a][b]);   
                        end     
                end
                ////
                for(int e=0;e<out_x;e++)begin
                        for(int f=0;f<out_y;f++)begin
                                args=$fscanf(transform_file2,"%f\n",input_transform_matrix_transpose[f][e]);
                        end
                end
                ////
                for(int a=0;a<out_x;a++)begin
                        for(int b=0;b<out_y;b++)begin
                                for(int c=0;c<out_z;c++)begin
                                        args=$fscanf(data_file,"%f\n",input_data_matrix[a][b][c]);   
                        end     
                end
                end
                
                /////
                #20
                rst=1'b0;
                for(int x=0;x<out_z;x=x+1)begin
                        for(int i=0;i<out_x;i=i+6)begin
                                for(int j=0;j<out_y;j=j+6)begin
                                        for( int k=0;k<out_x;k=k+6)begin
                                                transform_matrix[0][0]=$shortrealtobits(input_transform_matrix[i][k]);
                                                transform_matrix[0][1]=$shortrealtobits(input_transform_matrix[i][k+1]);
                                                transform_matrix[0][2]=$shortrealtobits(input_transform_matrix[i][k+2]);
                                                transform_matrix[0][3]=$shortrealtobits(input_transform_matrix[i][k+3]);
                                                transform_matrix[0][4]=$shortrealtobits(input_transform_matrix[i][k+4]);
                                                transform_matrix[0][5]=$shortrealtobits(input_transform_matrix[i][k+5]);
                                                ///////
                                                transform_matrix[1][0]=$shortrealtobits(input_transform_matrix[i+1][k]);
                                                transform_matrix[1][1]=$shortrealtobits(input_transform_matrix[i+1][k+1]);
                                                transform_matrix[1][2]=$shortrealtobits(input_transform_matrix[i+1][k+2]);
                                                transform_matrix[1][3]=$shortrealtobits(input_transform_matrix[i+1][k+3]);
                                                transform_matrix[1][4]=$shortrealtobits(input_transform_matrix[i+1][k+4]);
                                                transform_matrix[1][5]=$shortrealtobits(input_transform_matrix[i+1][k+5]);
                                                ///////
                                                transform_matrix[2][0]=$shortrealtobits(input_transform_matrix[i+2][k]);
                                                transform_matrix[2][1]=$shortrealtobits(input_transform_matrix[i+2][k+1]);
                                                transform_matrix[2][2]=$shortrealtobits(input_transform_matrix[i+2][k+2]);
                                                transform_matrix[2][3]=$shortrealtobits(input_transform_matrix[i+2][k+3]);
                                                transform_matrix[2][4]=$shortrealtobits(input_transform_matrix[i+2][k+4]);
                                                transform_matrix[2][5]=$shortrealtobits(input_transform_matrix[i+2][k+5]);
                                                ///////
                                                transform_matrix[3][0]=$shortrealtobits(input_transform_matrix[i+3][k]);
                                                transform_matrix[3][1]=$shortrealtobits(input_transform_matrix[i+3][k+1]);
                                                transform_matrix[3][2]=$shortrealtobits(input_transform_matrix[i+3][k+2]);
                                                transform_matrix[3][3]=$shortrealtobits(input_transform_matrix[i+3][k+3]);
                                                transform_matrix[3][4]=$shortrealtobits(input_transform_matrix[i+3][k+4]);
                                                transform_matrix[3][5]=$shortrealtobits(input_transform_matrix[i+3][k+5]);
                                                ///////
                                                transform_matrix[4][0]=$shortrealtobits(input_transform_matrix[i+4][k]);
                                                transform_matrix[4][1]=$shortrealtobits(input_transform_matrix[i+4][k+1]);
                                                transform_matrix[4][2]=$shortrealtobits(input_transform_matrix[i+4][k+2]);
                                                transform_matrix[4][3]=$shortrealtobits(input_transform_matrix[i+4][k+3]);
                                                transform_matrix[4][4]=$shortrealtobits(input_transform_matrix[i+4][k+4]);
                                                transform_matrix[4][5]=$shortrealtobits(input_transform_matrix[i+4][k+5]);
                                                ///////
                                                transform_matrix[5][0]=$shortrealtobits(input_transform_matrix[i+5][k]);
                                                transform_matrix[5][1]=$shortrealtobits(input_transform_matrix[i+5][k+1]);
                                                transform_matrix[5][2]=$shortrealtobits(input_transform_matrix[i+5][k+2]);
                                                transform_matrix[5][3]=$shortrealtobits(input_transform_matrix[i+5][k+3]);
                                                transform_matrix[5][4]=$shortrealtobits(input_transform_matrix[i+5][k+4]);
                                                transform_matrix[5][5]=$shortrealtobits(input_transform_matrix[i+5][k+5]);
                                                /////////
                                                /////////        
                                                data_matrix[0][0]=$shortrealtobits(input_data_matrix[k][j][x]);
                                                data_matrix[0][1]=$shortrealtobits(input_data_matrix[k][j+1][x]);
                                                data_matrix[0][2]=$shortrealtobits(input_data_matrix[k][j+2][x]);
                                                data_matrix[0][3]=$shortrealtobits(input_data_matrix[k][j+3][x]);
                                                data_matrix[0][4]=$shortrealtobits(input_data_matrix[k][j+4][x]);
                                                data_matrix[0][5]=$shortrealtobits(input_data_matrix[k][j+5][x]);
                                                ///////
                                                data_matrix[1][0]=$shortrealtobits(input_data_matrix[k+1][j][x]);
                                                data_matrix[1][1]=$shortrealtobits(input_data_matrix[k+1][j+1][x]);
                                                data_matrix[1][2]=$shortrealtobits(input_data_matrix[k+1][j+2][x]);
                                                data_matrix[1][3]=$shortrealtobits(input_data_matrix[k+1][j+3][x]);
                                                data_matrix[1][4]=$shortrealtobits(input_data_matrix[k+1][j+4][x]);
                                                data_matrix[1][5]=$shortrealtobits(input_data_matrix[k+1][j+5][x]);
                                                ///////
                                                data_matrix[2][0]=$shortrealtobits(input_data_matrix[k+2][j][x]);
                                                data_matrix[2][1]=$shortrealtobits(input_data_matrix[k+2][j+1][x]);
                                                data_matrix[2][2]=$shortrealtobits(input_data_matrix[k+2][j+2][x]);
                                                data_matrix[2][3]=$shortrealtobits(input_data_matrix[k+2][j+3][x]);
                                                data_matrix[2][4]=$shortrealtobits(input_data_matrix[k+2][j+4][x]);
                                                data_matrix[2][5]=$shortrealtobits(input_data_matrix[k+2][j+5][x]);
                                                ///////
                                                data_matrix[3][0]=$shortrealtobits(input_data_matrix[k+3][j][x]);
                                                data_matrix[3][1]=$shortrealtobits(input_data_matrix[k+3][j+1][x]);
                                                data_matrix[3][2]=$shortrealtobits(input_data_matrix[k+3][j+2][x]);
                                                data_matrix[3][3]=$shortrealtobits(input_data_matrix[k+3][j+3][x]);
                                                data_matrix[3][4]=$shortrealtobits(input_data_matrix[k+3][j+4][x]);
                                                data_matrix[3][5]=$shortrealtobits(input_data_matrix[k+3][j+5][x]);
                                                ///////
                                                data_matrix[4][0]=$shortrealtobits(input_data_matrix[k+4][j][x]);
                                                data_matrix[4][1]=$shortrealtobits(input_data_matrix[k+4][j+1][x]);
                                                data_matrix[4][2]=$shortrealtobits(input_data_matrix[k+4][j+2][x]);
                                                data_matrix[4][3]=$shortrealtobits(input_data_matrix[k+4][j+3][x]);
                                                data_matrix[4][4]=$shortrealtobits(input_data_matrix[k+4][j+4][x]);
                                                data_matrix[4][5]=$shortrealtobits(input_data_matrix[k+4][j+5][x]);
                                                ///////
                                                data_matrix[5][0]=$shortrealtobits(input_data_matrix[k+5][j][x]);
                                                data_matrix[5][1]=$shortrealtobits(input_data_matrix[k+5][j+1][x]);
                                                data_matrix[5][2]=$shortrealtobits(input_data_matrix[k+5][j+2][x]);
                                                data_matrix[5][3]=$shortrealtobits(input_data_matrix[k+5][j+3][x]);
                                                data_matrix[5][4]=$shortrealtobits(input_data_matrix[k+5][j+4][x]);
                                                data_matrix[5][5]=$shortrealtobits(input_data_matrix[k+5][j+5][x]);

                                                #300
                                                output_result[i][j][x]   = output_result[i][j  ][x] + $bitstoshortreal(comp_out[0][0]);
                                                output_result[i][j+1][x] = output_result[i][j+1][x] + $bitstoshortreal(comp_out[0][1]);
                                                output_result[i][j+2][x] = output_result[i][j+2][x] + $bitstoshortreal(comp_out[0][2]);
                                                output_result[i][j+3][x] = output_result[i][j+3][x] + $bitstoshortreal(comp_out[0][3]);
                                                output_result[i][j+4][x] = output_result[i][j+4][x] + $bitstoshortreal(comp_out[0][4]);
                                                output_result[i][j+5][x] = output_result[i][j+5][x] + $bitstoshortreal(comp_out[0][5]);
                                                //////
                                                output_result[i+1][j][x]   = output_result[i+1][j  ][x] + $bitstoshortreal(comp_out[1][0]);
                                                output_result[i+1][j+1][x] = output_result[i+1][j+1][x] + $bitstoshortreal(comp_out[1][1]);
                                                output_result[i+1][j+2][x] = output_result[i+1][j+2][x] + $bitstoshortreal(comp_out[1][2]);
                                                output_result[i+1][j+3][x] = output_result[i+1][j+3][x] + $bitstoshortreal(comp_out[1][3]);
                                                output_result[i+1][j+4][x] = output_result[i+1][j+4][x] + $bitstoshortreal(comp_out[1][4]);
                                                output_result[i+1][j+5][x] = output_result[i+1][j+5][x] + $bitstoshortreal(comp_out[1][5]);
                                                //////
                                                output_result[i+2][j][x]   = output_result[i+2][j  ][x] + $bitstoshortreal(comp_out[2][0]);
                                                output_result[i+2][j+1][x] = output_result[i+2][j+1][x] + $bitstoshortreal(comp_out[2][1]);
                                                output_result[i+2][j+2][x] = output_result[i+2][j+2][x] + $bitstoshortreal(comp_out[2][2]);
                                                output_result[i+2][j+3][x] = output_result[i+2][j+3][x] + $bitstoshortreal(comp_out[2][3]);
                                                output_result[i+2][j+4][x] = output_result[i+2][j+4][x]+ $bitstoshortreal(comp_out[2][4]);
                                                output_result[i+2][j+5][x] = output_result[i+2][j+5][x] + $bitstoshortreal(comp_out[2][5]);
                                                //////
                                                output_result[i+3][j][x]   = output_result[i+3][j  ][x] + $bitstoshortreal(comp_out[3][0]);
                                                output_result[i+3][j+1][x] = output_result[i+3][j+1][x] + $bitstoshortreal(comp_out[3][1]);
                                                output_result[i+3][j+2][x] = output_result[i+3][j+2][x] + $bitstoshortreal(comp_out[3][2]);
                                                output_result[i+3][j+3][x] = output_result[i+3][j+3][x] + $bitstoshortreal(comp_out[3][3]);
                                                output_result[i+3][j+4][x] = output_result[i+3][j+4][x] + $bitstoshortreal(comp_out[3][4]);
                                                output_result[i+3][j+5][x] = output_result[i+3][j+5][x] + $bitstoshortreal(comp_out[3][5]);
                                                //////
                                                output_result[i+4][j][x]   = output_result[i+4][j  ][x] + $bitstoshortreal(comp_out[4][0]);
                                                output_result[i+4][j+1][x] = output_result[i+4][j+1][x] + $bitstoshortreal(comp_out[4][1]);
                                                output_result[i+4][j+2][x] = output_result[i+4][j+2][x] + $bitstoshortreal(comp_out[4][2]);
                                                output_result[i+4][j+3][x] = output_result[i+4][j+3][x] + $bitstoshortreal(comp_out[4][3]);
                                                output_result[i+4][j+4][x] = output_result[i+4][j+4][x] + $bitstoshortreal(comp_out[4][4]);
                                                output_result[i+4][j+5][x] = output_result[i+4][j+5][x] + $bitstoshortreal(comp_out[4][5]);
                                                /////
                                                output_result[i+5][j][x]   = output_result[i+5][j  ][x] + $bitstoshortreal(comp_out[5][0]);
                                                output_result[i+5][j+1][x] = output_result[i+5][j+1][x] + $bitstoshortreal(comp_out[5][1]);
                                                output_result[i+5][j+2][x] = output_result[i+5][j+2][x] + $bitstoshortreal(comp_out[5][2]);
                                                output_result[i+5][j+3][x] = output_result[i+5][j+3][x] + $bitstoshortreal(comp_out[5][3]);
                                                output_result[i+5][j+4][x] = output_result[i+5][j+4][x] + $bitstoshortreal(comp_out[5][4]);
                                                output_result[i+5][j+5][x] = output_result[i+5][j+5][x] + $bitstoshortreal(comp_out[5][5]);

                                        end             
                                end
                        end  
                end
                
                #40
                for(int k=0;k<out_x;k=k+1)begin
                        for(int l=0;l<out_y;l=l+1)begin
                                for(int m=0;m<out_z;m=m+1)begin
                                        $fwrite(out_file,"%f,\n ",output_result[k][l][m]);  
                                end
                        end        
                end

                ///////
                #2000
                for(int x=0;x<out_z;x=x+1)begin
                        for(int i=0;i<out_x;i=i+6)begin
                                for(int j=0;j<out_y;j=j+6)begin
                                        for( int k=0;k<out_x;k=k+6)begin
                                                transform_matrix[0][0]=$shortrealtobits(output_result[i][k][x]);
                                                transform_matrix[0][1]=$shortrealtobits(output_result[i][k+1][x]);
                                                transform_matrix[0][2]=$shortrealtobits(output_result[i][k+2][x]);
                                                transform_matrix[0][3]=$shortrealtobits(output_result[i][k+3][x]);
                                                transform_matrix[0][4]=$shortrealtobits(output_result[i][k+4][x]);
                                                transform_matrix[0][5]=$shortrealtobits(output_result[i][k+5][x]);
                                                ///////
                                                transform_matrix[1][0]=$shortrealtobits(output_result[i+1][k][x]);
                                                transform_matrix[1][1]=$shortrealtobits(output_result[i+1][k+1][x]);
                                                transform_matrix[1][2]=$shortrealtobits(output_result[i+1][k+2][x]);
                                                transform_matrix[1][3]=$shortrealtobits(output_result[i+1][k+3][x]);
                                                transform_matrix[1][4]=$shortrealtobits(output_result[i+1][k+4][x]);
                                                transform_matrix[1][5]=$shortrealtobits(output_result[i+1][k+5][x]);
                                                ///////
                                                transform_matrix[2][0]=$shortrealtobits(output_result[i+2][k][x]);
                                                transform_matrix[2][1]=$shortrealtobits(output_result[i+2][k+1][x]);
                                                transform_matrix[2][2]=$shortrealtobits(output_result[i+2][k+2][x]);
                                                transform_matrix[2][3]=$shortrealtobits(output_result[i+2][k+3][x]);
                                                transform_matrix[2][4]=$shortrealtobits(output_result[i+2][k+4][x]);
                                                transform_matrix[2][5]=$shortrealtobits(output_result[i+2][k+5][x]);
                                                ///////
                                                transform_matrix[3][0]=$shortrealtobits(output_result[i+3][k][x]);
                                                transform_matrix[3][1]=$shortrealtobits(output_result[i+3][k+1][x]);
                                                transform_matrix[3][2]=$shortrealtobits(output_result[i+3][k+2][x]);
                                                transform_matrix[3][3]=$shortrealtobits(output_result[i+3][k+3][x]);
                                                transform_matrix[3][4]=$shortrealtobits(output_result[i+3][k+4][x]);
                                                transform_matrix[3][5]=$shortrealtobits(output_result[i+3][k+5][x]);
                                                ///////
                                                transform_matrix[4][0]=$shortrealtobits(output_result[i+4][k][x]);
                                                transform_matrix[4][1]=$shortrealtobits(output_result[i+4][k+1][x]);
                                                transform_matrix[4][2]=$shortrealtobits(output_result[i+4][k+2][x]);
                                                transform_matrix[4][3]=$shortrealtobits(output_result[i+4][k+3][x]);
                                                transform_matrix[4][4]=$shortrealtobits(output_result[i+4][k+4][x]);
                                                transform_matrix[4][5]=$shortrealtobits(output_result[i+4][k+5][x]);
                                                ///////
                                                transform_matrix[5][0]=$shortrealtobits(output_result[i+5][k][x]);
                                                transform_matrix[5][1]=$shortrealtobits(output_result[i+5][k+1][x]);
                                                transform_matrix[5][2]=$shortrealtobits(output_result[i+5][k+2][x]);
                                                transform_matrix[5][3]=$shortrealtobits(output_result[i+5][k+3][x]);
                                                transform_matrix[5][4]=$shortrealtobits(output_result[i+5][k+4][x]);
                                                transform_matrix[5][5]=$shortrealtobits(output_result[i+5][k+5][x]);
                                                /////////
                                                /////////        
                                                data_matrix[0][0]=$shortrealtobits(input_transform_matrix_transpose[k][j]);
                                                data_matrix[0][1]=$shortrealtobits(input_transform_matrix_transpose[k][j+1]);
                                                data_matrix[0][2]=$shortrealtobits(input_transform_matrix_transpose[k][j+2]);
                                                data_matrix[0][3]=$shortrealtobits(input_transform_matrix_transpose[k][j+3]);
                                                data_matrix[0][4]=$shortrealtobits(input_transform_matrix_transpose[k][j+4]);
                                                data_matrix[0][5]=$shortrealtobits(input_transform_matrix_transpose[k][j+5]);
                                                ///////
                                                data_matrix[1][0]=$shortrealtobits(input_transform_matrix_transpose[k+1][j]);
                                                data_matrix[1][1]=$shortrealtobits(input_transform_matrix_transpose[k+1][j+1]);
                                                data_matrix[1][2]=$shortrealtobits(input_transform_matrix_transpose[k+1][j+2]);
                                                data_matrix[1][3]=$shortrealtobits(input_transform_matrix_transpose[k+1][j+3]);
                                                data_matrix[1][4]=$shortrealtobits(input_transform_matrix_transpose[k+1][j+4]);
                                                data_matrix[1][5]=$shortrealtobits(input_transform_matrix_transpose[k+1][j+5]);
                                                ///////
                                                data_matrix[2][0]=$shortrealtobits(input_transform_matrix_transpose[k+2][j]);
                                                data_matrix[2][1]=$shortrealtobits(input_transform_matrix_transpose[k+2][j+1]);
                                                data_matrix[2][2]=$shortrealtobits(input_transform_matrix_transpose[k+2][j+2]);
                                                data_matrix[2][3]=$shortrealtobits(input_transform_matrix_transpose[k+2][j+3]);
                                                data_matrix[2][4]=$shortrealtobits(input_transform_matrix_transpose[k+2][j+4]);
                                                data_matrix[2][5]=$shortrealtobits(input_transform_matrix_transpose[k+2][j+5]);
                                                ///////
                                                data_matrix[3][0]=$shortrealtobits(input_transform_matrix_transpose[k+3][j]);
                                                data_matrix[3][1]=$shortrealtobits(input_transform_matrix_transpose[k+3][j+1]);
                                                data_matrix[3][2]=$shortrealtobits(input_transform_matrix_transpose[k+3][j+2]);
                                                data_matrix[3][3]=$shortrealtobits(input_transform_matrix_transpose[k+3][j+3]);
                                                data_matrix[3][4]=$shortrealtobits(input_transform_matrix_transpose[k+3][j+4]);
                                                data_matrix[3][5]=$shortrealtobits(input_transform_matrix_transpose[k+3][j+5]);
                                                ///////
                                                data_matrix[4][0]=$shortrealtobits(input_transform_matrix_transpose[k+4][j]);
                                                data_matrix[4][1]=$shortrealtobits(input_transform_matrix_transpose[k+4][j+1]);
                                                data_matrix[4][2]=$shortrealtobits(input_transform_matrix_transpose[k+4][j+2]);
                                                data_matrix[4][3]=$shortrealtobits(input_transform_matrix_transpose[k+4][j+3]);
                                                data_matrix[4][4]=$shortrealtobits(input_transform_matrix_transpose[k+4][j+4]);
                                                data_matrix[4][5]=$shortrealtobits(input_transform_matrix_transpose[k+4][j+5]);
                                                ///////
                                                data_matrix[5][0]=$shortrealtobits(input_transform_matrix_transpose[k+5][j]);
                                                data_matrix[5][1]=$shortrealtobits(input_transform_matrix_transpose[k+5][j+1]);
                                                data_matrix[5][2]=$shortrealtobits(input_transform_matrix_transpose[k+5][j+2]);
                                                data_matrix[5][3]=$shortrealtobits(input_transform_matrix_transpose[k+5][j+3]);
                                                data_matrix[5][4]=$shortrealtobits(input_transform_matrix_transpose[k+5][j+4]);
                                                data_matrix[5][5]=$shortrealtobits(input_transform_matrix_transpose[k+5][j+5]);

                                                #300
                                                output_result_2[i][j][x]   = output_result_2[i][j  ][x] + $bitstoshortreal(comp_out[0][0]);
                                                output_result_2[i][j+1][x] = output_result_2[i][j+1][x] + $bitstoshortreal(comp_out[0][1]);
                                                output_result_2[i][j+2][x] = output_result_2[i][j+2][x] + $bitstoshortreal(comp_out[0][2]);
                                                output_result_2[i][j+3][x] = output_result_2[i][j+3][x] + $bitstoshortreal(comp_out[0][3]);
                                                output_result_2[i][j+4][x] = output_result_2[i][j+4][x] + $bitstoshortreal(comp_out[0][4]);
                                                output_result_2[i][j+5][x] = output_result_2[i][j+5][x] + $bitstoshortreal(comp_out[0][5]);
                                                //////
                                                output_result_2[i+1][j][x]   = output_result_2[i+1][j  ][x] + $bitstoshortreal(comp_out[1][0]);
                                                output_result_2[i+1][j+1][x] = output_result_2[i+1][j+1][x] + $bitstoshortreal(comp_out[1][1]);
                                                output_result_2[i+1][j+2][x] = output_result_2[i+1][j+2][x] + $bitstoshortreal(comp_out[1][2]);
                                                output_result_2[i+1][j+3][x] = output_result_2[i+1][j+3][x] + $bitstoshortreal(comp_out[1][3]);
                                                output_result_2[i+1][j+4][x] = output_result_2[i+1][j+4][x] + $bitstoshortreal(comp_out[1][4]);
                                                output_result_2[i+1][j+5][x] = output_result_2[i+1][j+5][x] + $bitstoshortreal(comp_out[1][5]);
                                                //////
                                                output_result_2[i+2][j][x]   = output_result_2[i+2][j  ][x] + $bitstoshortreal(comp_out[2][0]);
                                                output_result_2[i+2][j+1][x] = output_result_2[i+2][j+1][x] + $bitstoshortreal(comp_out[2][1]);
                                                output_result_2[i+2][j+2][x] = output_result_2[i+2][j+2][x] + $bitstoshortreal(comp_out[2][2]);
                                                output_result_2[i+2][j+3][x] = output_result_2[i+2][j+3][x] + $bitstoshortreal(comp_out[2][3]);
                                                output_result_2[i+2][j+4][x] = output_result_2[i+2][j+4][x] + $bitstoshortreal(comp_out[2][4]);
                                                output_result_2[i+2][j+5][x] = output_result_2[i+2][j+5][x] + $bitstoshortreal(comp_out[2][5]);
                                                //////
                                                output_result_2[i+3][j][x]   = output_result_2[i+3][j  ][x] + $bitstoshortreal(comp_out[3][0]);
                                                output_result_2[i+3][j+1][x] = output_result_2[i+3][j+1][x] + $bitstoshortreal(comp_out[3][1]);
                                                output_result_2[i+3][j+2][x] = output_result_2[i+3][j+2][x] + $bitstoshortreal(comp_out[3][2]);
                                                output_result_2[i+3][j+3][x] = output_result_2[i+3][j+3][x] + $bitstoshortreal(comp_out[3][3]);
                                                output_result_2[i+3][j+4][x] = output_result_2[i+3][j+4][x] + $bitstoshortreal(comp_out[3][4]);
                                                output_result_2[i+3][j+5][x] = output_result_2[i+3][j+5][x] + $bitstoshortreal(comp_out[3][5]);
                                                //////
                                                output_result_2[i+4][j][x]   = output_result_2[i+4][j  ][x] + $bitstoshortreal(comp_out[4][0]);
                                                output_result_2[i+4][j+1][x] = output_result_2[i+4][j+1][x] + $bitstoshortreal(comp_out[4][1]);
                                                output_result_2[i+4][j+2][x] = output_result_2[i+4][j+2][x] + $bitstoshortreal(comp_out[4][2]);
                                                output_result_2[i+4][j+3][x] = output_result_2[i+4][j+3][x] + $bitstoshortreal(comp_out[4][3]);
                                                output_result_2[i+4][j+4][x] = output_result_2[i+4][j+4][x] + $bitstoshortreal(comp_out[4][4]);
                                                output_result_2[i+4][j+5][x] = output_result_2[i+4][j+5][x] + $bitstoshortreal(comp_out[4][5]);
                                                /////
                                                output_result_2[i+5][j][x]   = output_result_2[i+5][j  ][x] + $bitstoshortreal(comp_out[5][0]);
                                                output_result_2[i+5][j+1][x] = output_result_2[i+5][j+1][x] + $bitstoshortreal(comp_out[5][1]);
                                                output_result_2[i+5][j+2][x] = output_result_2[i+5][j+2][x] + $bitstoshortreal(comp_out[5][2]);
                                                output_result_2[i+5][j+3][x] = output_result_2[i+5][j+3][x] + $bitstoshortreal(comp_out[5][3]);
                                                output_result_2[i+5][j+4][x] = output_result_2[i+5][j+4][x] + $bitstoshortreal(comp_out[5][4]);
                                                output_result_2[i+5][j+5][x] = output_result_2[i+5][j+5][x] + $bitstoshortreal(comp_out[5][5]);

                                        end             
                                end
                        end        
                end
                #40
                for(int l=0;l<out_x;l=l+1)begin
                        for(int m=0;m<out_y;m=m+1)begin
                                for(int n=0;n<out_z;n=n+1)begin
                                        $fwrite(dwt_out_file,"%.12f\n",output_result_2[l][m][n]);          
                                end
                        
                        end
                end
                $finish;
        end
endmodule
