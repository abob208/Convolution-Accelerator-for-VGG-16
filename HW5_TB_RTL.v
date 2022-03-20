`timescale 1ns / 1ns
`define period          10
`define img_max_size    224*224*3+54
//---------------------------------------------------------------
//You need specify the path of image in/out
//---------------------------------------------------------------
`define path_img_in     "./cat224.bmp"
`define path_img_out    "./cat_gray.bmp"
module HDL_HW5_TB;
    integer img_in;
	integer conv1_out[0:63] ;
	integer conv2_out[0:63] ;
    integer offset;
    integer img_h;
    integer img_w;
    integer idx;
    integer header;
	integer i ;
	integer j ;
	integer k ;
	integer m ;
	integer n ;
	integer l ;
    reg         clk;
	reg  signed [15:0] weight_sram[0:1727] ;
	reg  signed [15:0] weight2_sram[0:36863] ;
	reg  signed [15:0] bias_sram[0:63] ;
    reg  [7:0]  img_data [0:`img_max_size-1];
	reg  [7:0]  R_padding_img_data [0:225][0:225] ;
	reg  [7:0]  G_padding_img_data [0:225][0:225] ;
	reg  [7:0]  B_padding_img_data [0:225][0:225] ;
    reg  signed [31:0]  conv1_img_data [0:63][0:225][0:225];
	reg  signed [31:0]  conv2_img_data [0:63][0:225][0:225];
    reg  [7:0]  R;
    reg  [7:0]  G;
    reg  [7:0]  B;
    reg  [7:0] Y;
	reg [31:0] counter;
	reg signed [8:0] temp[0:2] ;
	reg signed [15:0] kernal1_00, kernal1_01, kernal1_02, 
				  kernal1_10, kernal1_11, kernal1_12, 
		          kernal1_20, kernal1_21, kernal1_22,
			      kernal2_00, kernal2_01, kernal2_02, 
		          kernal2_10, kernal2_11, kernal2_12, 
		          kernal2_20, kernal2_21, kernal2_22, 
			      kernal3_00, kernal3_01, kernal3_02, 
		          kernal3_10, kernal3_11, kernal3_12, 
		          kernal3_20, kernal3_21, kernal3_22, 
				  kernal4_00, kernal4_01, kernal4_02, 
				  kernal4_10, kernal4_11, kernal4_12, 
				  kernal4_20, kernal4_21, kernal4_22 ;

	reg signed [15:0] bias1, bias2, bias3, bias4 ;
	wire signed [31:0] partial_sum1, partial_sum2, partial_sum3, partial_sum4 ;
    //---------------------------------------------------------------
	//TOP top( clk, Y, Gx, Gy ) ;
    //---------------------------------------------------------------
	TOP top(clk, Y, 
			kernal1_00, kernal1_01, kernal1_02, 
		    kernal1_10, kernal1_11, kernal1_12, 
		    kernal1_20, kernal1_21, kernal1_22,
			kernal2_00, kernal2_01, kernal2_02, 
		    kernal2_10, kernal2_11, kernal2_12, 
		    kernal2_20, kernal2_21, kernal2_22, 
			kernal3_00, kernal3_01, kernal3_02, 
		    kernal3_10, kernal3_11, kernal3_12, 
		    kernal3_20, kernal3_21, kernal3_22, 
			kernal4_00, kernal4_01, kernal4_02, 
			kernal4_10, kernal4_11, kernal4_12, 
			kernal4_20, kernal4_21, kernal4_22,
			bias1, bias2, bias3, bias4, partial_sum1, partial_sum2, partial_sum3, partial_sum4 ) ;

//---------------------------------------------------------------------------------------Take out the color image(cat) of RGB----------------------------------------------
    //---------------------------------------------------------------
    //This initial block write the pixel 
    //---------------------------------------------------------------
    initial begin
        clk = 1'b1;
		counter = 0 ;
		
    #(`period)
		for ( i = 0 ; i < 64 ; i = i + 1 ) begin
			for ( j = 0 ; j < 226 ; j = j + 1 ) begin
				for ( k = 0 ; k < 226 ; k = k + 1 ) begin
					conv1_img_data[i][j][k] = 0 ;
					conv2_img_data[i][j][k] = 0 ;
				end
			end
		end
		for ( i = 0 ; i < 226 ; i = i + 1 ) begin
			for ( j = 0 ; j < 226 ; j = j + 1 ) begin
				R_padding_img_data[i][j] = 0 ;
				G_padding_img_data[i][j] = 0 ;
				B_padding_img_data[i][j] = 0 ;
			end
		end

        for(idx = 0; idx < img_h*img_w; idx = idx+1) begin
            R = img_data[idx*3 + offset + 2];
            G = img_data[idx*3 + offset + 1];
            B = img_data[idx*3 + offset + 0];
			R_padding_img_data[idx/224+1][idx%224+1] = R ;
			G_padding_img_data[idx/224+1][idx%224+1] = G ;
			B_padding_img_data[idx/224+1][idx%224+1] = B ;
        end

		for ( i = 0 ; i < 64 ; i = i + 4 ) begin
			for ( k = 0 ; k < 3 ; k = k + 1 ) begin
				kernal1_00 = weight_sram[i*27+k*9] ;
				kernal1_01 = weight_sram[i*27+1+k*9] ;
				kernal1_02 = weight_sram[i*27+2+k*9] ;
				kernal1_10 = weight_sram[i*27+3+k*9] ;
				kernal1_11 = weight_sram[i*27+4+k*9] ;
				kernal1_12 = weight_sram[i*27+5+k*9] ;
				kernal1_20 = weight_sram[i*27+6+k*9] ;
				kernal1_21 = weight_sram[i*27+7+k*9] ;
				kernal1_22 = weight_sram[i*27+8+k*9] ;
				kernal2_00 = weight_sram[i*27+27+k*9] ;
				kernal2_01 = weight_sram[i*27+28+k*9] ;
				kernal2_02 = weight_sram[i*27+29+k*9] ;
				kernal2_10 = weight_sram[i*27+30+k*9] ;
				kernal2_11 = weight_sram[i*27+31+k*9] ;
				kernal2_12 = weight_sram[i*27+32+k*9] ;
				kernal2_20 = weight_sram[i*27+33+k*9] ;
				kernal2_21 = weight_sram[i*27+34+k*9] ;
				kernal2_22 = weight_sram[i*27+35+k*9] ;
				kernal3_00 = weight_sram[i*27+54+k*9] ;
				kernal3_01 = weight_sram[i*27+55+k*9] ;
				kernal3_02 = weight_sram[i*27+56+k*9] ;
				kernal3_10 = weight_sram[i*27+57+k*9] ;
				kernal3_11 = weight_sram[i*27+58+k*9] ;	
				kernal3_12 = weight_sram[i*27+59+k*9] ;
				kernal3_20 = weight_sram[i*27+60+k*9] ;
				kernal3_21 = weight_sram[i*27+61+k*9] ;
				kernal3_22 = weight_sram[i*27+62+k*9] ;
				kernal4_00 = weight_sram[i*27+81+k*9] ;
				kernal4_01 = weight_sram[i*27+82+k*9] ;
				kernal4_02 = weight_sram[i*27+83+k*9] ;
				kernal4_10 = weight_sram[i*27+84+k*9] ;
				kernal4_11 = weight_sram[i*27+85+k*9] ;	
				kernal4_12 = weight_sram[i*27+86+k*9] ;
				kernal4_20 = weight_sram[i*27+87+k*9] ;
				kernal4_21 = weight_sram[i*27+88+k*9] ;
				kernal4_22 = weight_sram[i*27+89+k*9] ;
				bias1 = bias_sram[i] ;
				bias2 = bias_sram[i+1] ;
				bias3 = bias_sram[i+2] ;
				bias4 = bias_sram[i+3] ;
				for ( m = 0 ; m < 2 ; m = m + 1 ) begin
					for ( n = 0 ; n < 226 ; n = n + 1 ) begin
						if( k == 0 )
							Y = R_padding_img_data[m][n] ;
						else if ( k == 1 )
							Y = G_padding_img_data[m][n] ;
						else if ( k == 2 )
							Y = B_padding_img_data[m][n] ;
						#(`period) ;
					end
				end

				if( k == 0 ) begin 
					Y = R_padding_img_data[2][0] ;
					#(`period) ;
					Y = R_padding_img_data[2][1] ;
					#(`period) ;
					Y = R_padding_img_data[2][2] ;
					#(`period) ;
				end
				else if ( k == 1 ) begin
					Y = G_padding_img_data[2][0] ;
					#(`period) ;
					Y = G_padding_img_data[2][1] ;
					#(`period) ;
					Y = G_padding_img_data[2][2] ;
					#(`period) ;
				end
				else if ( k == 2 ) begin
					Y = B_padding_img_data[2][0] ;
					#(`period) ;
					Y = B_padding_img_data[2][1] ;
					#(`period) ;
					Y = B_padding_img_data[2][2] ;
					#(`period) ;
				end
				#(`period) ;
				#(`period) ;
				#(`period) ;
				for ( j = 0 ; j < 224 ; j = j + 1 ) begin
					for ( l = 0 ; l < 224 ; l = l + 1 ) begin
						conv1_img_data[i][j+1][l+1] = conv1_img_data[i][j+1][l+1] + partial_sum1 ;
						conv1_img_data[i+1][j+1][l+1] = conv1_img_data[i+1][j+1][l+1] + partial_sum2 ;
						conv1_img_data[i+2][j+1][l+1] = conv1_img_data[i+2][j+1][l+1] + partial_sum3 ;
						conv1_img_data[i+3][j+1][l+1] = conv1_img_data[i+3][j+1][l+1] + partial_sum4 ;
						if ( k == 2 ) begin
							//$display( "%d", temp ) ;
							
							temp[0][8:0] = 0 ;
							temp[1][8:0] = 0 ;
							temp[2][8:0] = 0 ;
							conv1_img_data[i][j+1][l+1] = conv1_img_data[i][j+1][l+1][12:5] + bias1 ;
							conv1_img_data[i+1][j+1][l+1] = conv1_img_data[i+1][j+1][l+1][12:5] + bias2 ;
							conv1_img_data[i+2][j+1][l+1] = conv1_img_data[i+2][j+1][l+1][12:5] + bias3 ;
							conv1_img_data[i+3][j+1][l+1] = conv1_img_data[i+3][j+1][l+1][12:5] + bias4 ;
							if ( conv1_img_data[i][j+1][l+1] < 0 ) begin
								conv1_img_data[i][j+1][l+1] = 0 ;
							end
							if ( conv1_img_data[i+1][j+1][l+1] < 0 ) begin
								conv1_img_data[i+1][j+1][l+1] = 0 ;
							end
							if ( conv1_img_data[i+2][j+1][l+1] < 0 ) begin
								conv1_img_data[i+2][j+1][l+1] = 0 ;
							end
							if ( conv1_img_data[i+3][j+1][l+1] < 0 ) begin
								conv1_img_data[i+3][j+1][l+1] = 0 ;
							end
						
							//$display( "%b", conv1_img_data[i][j][11:4] ) ;
							$fwrite( conv1_out[i], "%c%c%c", conv1_img_data[i][j+1][l+1], conv1_img_data[i][j+1][l+1], conv1_img_data[i][j+1][l+1] );
							$fwrite( conv1_out[i+1], "%c%c%c", conv1_img_data[i+1][j+1][l+1], conv1_img_data[i+1][j+1][l+1], conv1_img_data[i+1][j+1][l+1] );
							$fwrite( conv1_out[i+2], "%c%c%c", conv1_img_data[i+2][j+1][l+1], conv1_img_data[i+2][j+1][l+1], conv1_img_data[i+2][j+1][l+1] );
							$fwrite( conv1_out[i+3], "%c%c%c", conv1_img_data[i+3][j+1][l+1], conv1_img_data[i+3][j+1][l+1], conv1_img_data[i+3][j+1][l+1] );
						end

						if( k == 0 ) begin
							if ( l % 226 + 3 <= 225 )
								Y = R_padding_img_data[j+2][l%226+3] ;
							else begin
								Y = R_padding_img_data[j+3][0] ;
							end
						end
						else if ( k == 1 ) begin
							if ( l % 226 + 3 <= 225 )
								Y = G_padding_img_data[j+2][l%226+3] ;
							else begin
								Y = G_padding_img_data[j+3][0] ;
							end
						end
						else if ( k == 2 ) begin
							if ( l % 226 + 3 <= 225 )
								Y = B_padding_img_data[j+2][l%226+3] ;
							else begin
								Y = B_padding_img_data[j+3][0] ;
							end
						end
						#(`period ) ;
					end
					
					if ( k == 0 ) begin
						Y = R_padding_img_data[j+3][1] ;
						#( `period ) ;
						Y = R_padding_img_data[j+3][2] ;
						#( `period ) ;
					end
					else if ( k == 1 ) begin
						Y = G_padding_img_data[j+3][1] ;
						#( `period ) ;
						Y = G_padding_img_data[j+3][2] ;
						#( `period ) ;

					end
					else if ( k == 2 ) begin
						Y = B_padding_img_data[j+3][1] ;
						#( `period ) ;
						Y = B_padding_img_data[j+3][2] ;
						#( `period ) ;

					end
					#(`period) ;
					#(`period) ;
					#(`period) ;
				end
			end
			
		end
		#(`period) ;
		$fclose(img_in);
		for ( i = 0 ; i < 64 ; i = i + 1 ) begin
			$fclose( conv1_out[i] ) ;
		end

		$readmemh( "conv2_kernel_hex.txt", weight2_sram ) ;
		$readmemh( "conv2_bias_hex.txt", bias_sram ) ;

		for ( i = 0 ; i < 64 ; i = i + 4 ) begin
			for ( k = 0 ; k < 64 ; k = k + 1 ) begin
				kernal1_00 = weight2_sram[i*576+k*9] ;
				kernal1_01 = weight2_sram[i*576+1+k*9] ;
				kernal1_02 = weight2_sram[i*576+2+k*9] ;
				kernal1_10 = weight2_sram[i*576+3+k*9] ;
				kernal1_11 = weight2_sram[i*576+4+k*9] ;
				kernal1_12 = weight2_sram[i*576+5+k*9] ;
				kernal1_20 = weight2_sram[i*576+6+k*9] ;
				kernal1_21 = weight2_sram[i*576+7+k*9] ;
				kernal1_22 = weight2_sram[i*576+8+k*9] ;
				kernal2_00 = weight2_sram[i*576+576+k*9] ;
				kernal2_01 = weight2_sram[i*576+577+k*9] ;
				kernal2_02 = weight2_sram[i*576+578+k*9] ;
				kernal2_10 = weight2_sram[i*576+579+k*9] ;
				kernal2_11 = weight2_sram[i*576+580+k*9] ;
				kernal2_12 = weight2_sram[i*576+581+k*9] ;
				kernal2_20 = weight2_sram[i*576+582+k*9] ;
				kernal2_21 = weight2_sram[i*576+583+k*9] ;
				kernal2_22 = weight2_sram[i*576+584+k*9] ;
				kernal3_00 = weight2_sram[i*576+1152+k*9] ;
				kernal3_01 = weight2_sram[i*576+1153+k*9] ;
				kernal3_02 = weight2_sram[i*576+1154+k*9] ;
				kernal3_10 = weight2_sram[i*576+1155+k*9] ;
				kernal3_11 = weight2_sram[i*576+1156+k*9] ;	
				kernal3_12 = weight2_sram[i*576+1157+k*9] ;
				kernal3_20 = weight2_sram[i*576+1158+k*9] ;
				kernal3_21 = weight2_sram[i*576+1159+k*9] ;
				kernal3_22 = weight2_sram[i*576+1160+k*9] ;
				kernal4_00 = weight2_sram[i*576+1728+k*9] ;
				kernal4_01 = weight2_sram[i*576+1729+k*9] ;
				kernal4_02 = weight2_sram[i*576+1730+k*9] ;
				kernal4_10 = weight2_sram[i*576+1731+k*9] ;
				kernal4_11 = weight2_sram[i*576+1732+k*9] ;	
				kernal4_12 = weight2_sram[i*576+1733+k*9] ;
				kernal4_20 = weight2_sram[i*576+1734+k*9] ;
				kernal4_21 = weight2_sram[i*576+1735+k*9] ;
				kernal4_22 = weight2_sram[i*576+1736+k*9] ;
				bias1 = bias_sram[i] ;
				bias2 = bias_sram[i+1] ;
				bias3 = bias_sram[i+2] ;
				bias4 = bias_sram[i+3] ;
				for ( m = 0 ; m < 2 ; m = m + 1 ) begin
					for ( n = 0 ; n < 226 ; n = n + 1 ) begin
						Y = conv1_img_data[k][m][n][12:5] ;
						#(`period) ;
					end
				end

				Y = conv1_img_data[k][2][0][12:5] ;
				#(`period) ;
				Y = conv1_img_data[k][2][1][12:5] ;
				#(`period) ;
				Y = conv1_img_data[k][2][2][12:5] ;
				#(`period) ;
				#(`period) ;
				#(`period) ;
				#(`period) ;
				for ( j = 0 ; j < 224 ; j = j + 1 ) begin
					for ( l = 0 ; l < 224 ; l = l + 1 ) begin
						conv2_img_data[i][j+1][l+1] = conv2_img_data[i][j+1][l+1] + partial_sum1 ;
						conv2_img_data[i+1][j+1][l+1] = conv2_img_data[i+1][j+1][l+1] + partial_sum2 ;
						conv2_img_data[i+2][j+1][l+1] = conv2_img_data[i+2][j+1][l+1] + partial_sum3 ;
						conv2_img_data[i+3][j+1][l+1] = conv2_img_data[i+3][j+1][l+1] + partial_sum4 ;
						if ( k == 63 ) begin
							//$display( "%d", temp ) ;
							temp[0][8:0] = 0 ;
							temp[1][8:0] = 0 ;
							temp[2][8:0] = 0 ;
							conv2_img_data[i][j+1][l+1] = conv2_img_data[i][j+1][l+1] + bias1 ;
							conv2_img_data[i+1][j+1][l+1] = conv2_img_data[i+1][j+1][l+1] + bias2 ;
							conv2_img_data[i+2][j+1][l+1] = conv2_img_data[i+2][j+1][l+1] + bias3 ;
							conv2_img_data[i+3][j+1][l+1] = conv2_img_data[i+3][j+1][l+1] + bias4 ;
							if ( conv2_img_data[i][j+1][l+1] < 0 ) begin
								conv2_img_data[i][j+1][l+1] = 0 ;
							end
							if ( conv2_img_data[i+1][j+1][l+1] < 0 ) begin
								conv2_img_data[i+1][j+1][l+1] = 0 ;
							end
							if ( conv2_img_data[i+2][j+1][l+1] < 0 ) begin
								conv2_img_data[i+2][j+1][l+1] = 0 ;
							end
							if ( conv2_img_data[i+3][j+1][l+1] < 0 ) begin
								conv2_img_data[i+3][j+1][l+1] = 0 ;
							end
							//$display( "%b", conv1_img_data[i][j][11:4] ) ;
							$fwrite( conv2_out[i], "%c%c%c", conv2_img_data[i][j+1][l+1][12:5], conv2_img_data[i][j+1][l+1][12:5], conv2_img_data[i][j+1][l+1][12:5] );
							$fwrite( conv2_out[i+1], "%c%c%c", conv2_img_data[i+1][j+1][l+1][12:5], conv2_img_data[i+1][j+1][l+1][12:5], conv2_img_data[i+1][j+1][l+1][12:5] );
							$fwrite( conv2_out[i+2], "%c%c%c", conv2_img_data[i+2][j+1][l+1][12:5], conv2_img_data[i+2][j+1][l+1][12:5], conv2_img_data[i+2][j+1][l+1][12:5] );
							$fwrite( conv2_out[i+3], "%c%c%c", conv2_img_data[i+3][j+1][l+1][12:5], conv2_img_data[i+3][j+1][l+1][12:5], conv2_img_data[i+3][j+1][l+1][12:5] );
						end

						if ( l % 226 + 3 <= 225 )
							Y = conv1_img_data[k][j+2][l%226+3][12:5] ;
						else begin
							Y = conv1_img_data[k][j+3][0][12:5] ;
						end

						#(`period ) ;
					end
					

					Y = conv1_img_data[k][j+3][1][12:5] ;
					#( `period ) ;
					Y = conv1_img_data[k][j+3][2][12:5] ;
					#( `period ) ;
					#(`period) ;
					#(`period) ;
					#(`period) ;
				end
			end
			
		end

		#(`period) ;
		$fclose(img_in);
		for ( i = 0 ; i < 64 ; i = i + 1 ) begin
			$fclose( conv2_out[i] ) ;
		end

		$stop;
    end

    //---------------------------------------------------------------
    //This initial block read the pixel 
    //---------------------------------------------------------------
    initial begin
		$readmemh( "conv1_kernel_hex.txt", weight_sram ) ;
		$readmemh( "conv1_bias_hex.txt", bias_sram ) ;
        img_in  = $fopen(`path_img_in, "rb");
        conv1_out[0] = $fopen( "./conv1_1.bmp", "wb");
        conv1_out[1] = $fopen("./conv1_2.bmp", "wb");
        conv1_out[2] = $fopen("./conv1_3.bmp", "wb");
        conv1_out[3] = $fopen("./conv1_4.bmp", "wb");
        conv1_out[4] = $fopen("./conv1_5.bmp", "wb");
        conv1_out[5] = $fopen("./conv1_6.bmp", "wb");
        conv1_out[6] = $fopen("./conv1_7.bmp", "wb");
        conv1_out[7] = $fopen("./conv1_8.bmp", "wb");
        conv1_out[8] = $fopen("./conv1_9.bmp", "wb");
        conv1_out[9] = $fopen("./conv1_10.bmp", "wb");
        conv1_out[10] = $fopen("./conv1_11.bmp", "wb");
        conv1_out[11] = $fopen("./conv1_12.bmp", "wb");
        conv1_out[12] = $fopen("./conv1_13.bmp", "wb");
        conv1_out[13] = $fopen("./conv1_14.bmp", "wb");
        conv1_out[14] = $fopen("./conv1_15.bmp", "wb");
        conv1_out[15] = $fopen("./conv1_16.bmp", "wb");
        conv1_out[16] = $fopen("./conv1_17.bmp", "wb");
        conv1_out[17] = $fopen("./conv1_18.bmp", "wb");
        conv1_out[18] = $fopen("./conv1_19.bmp", "wb");
        conv1_out[19] = $fopen("./conv1_20.bmp", "wb");
        conv1_out[20] = $fopen("./conv1_21.bmp", "wb");
        conv1_out[21] = $fopen("./conv1_22.bmp", "wb");
        conv1_out[22] = $fopen("./conv1_23.bmp", "wb");
        conv1_out[23] = $fopen("./conv1_24.bmp", "wb");
        conv1_out[24] = $fopen("./conv1_25.bmp", "wb");
        conv1_out[25] = $fopen("./conv1_26.bmp", "wb");
        conv1_out[26] = $fopen("./conv1_27.bmp", "wb");
        conv1_out[27] = $fopen("./conv1_28.bmp", "wb");
        conv1_out[28] = $fopen("./conv1_29.bmp", "wb");
        conv1_out[29] = $fopen("./conv1_30.bmp", "wb");
        conv1_out[30] = $fopen("./conv1_31.bmp", "wb");
        conv1_out[31] = $fopen("./conv1_32.bmp", "wb");
        conv1_out[32] = $fopen("./conv1_33.bmp", "wb");
        conv1_out[33] = $fopen("./conv1_34.bmp", "wb");
        conv1_out[34] = $fopen("./conv1_35.bmp", "wb");
        conv1_out[35] = $fopen("./conv1_36.bmp", "wb");
        conv1_out[36] = $fopen("./conv1_37.bmp", "wb");
        conv1_out[37] = $fopen("./conv1_38.bmp", "wb");
        conv1_out[38] = $fopen("./conv1_39.bmp", "wb");
        conv1_out[39] = $fopen("./conv1_40.bmp", "wb");
        conv1_out[40] = $fopen("./conv1_41.bmp", "wb");
        conv1_out[41] = $fopen("./conv1_42.bmp", "wb");
        conv1_out[42] = $fopen("./conv1_43.bmp", "wb");
        conv1_out[43] = $fopen("./conv1_44.bmp", "wb");
        conv1_out[44] = $fopen("./conv1_45.bmp", "wb");
        conv1_out[45] = $fopen("./conv1_46.bmp", "wb");
        conv1_out[46] = $fopen("./conv1_47.bmp", "wb");
        conv1_out[47] = $fopen("./conv1_48.bmp", "wb");
        conv1_out[48] = $fopen("./conv1_49.bmp", "wb");
        conv1_out[49] = $fopen("./conv1_50.bmp", "wb");
        conv1_out[50] = $fopen("./conv1_51.bmp", "wb");
        conv1_out[51] = $fopen("./conv1_52.bmp", "wb");
        conv1_out[52] = $fopen("./conv1_53.bmp", "wb");
        conv1_out[53] = $fopen("./conv1_54.bmp", "wb");
        conv1_out[54] = $fopen("./conv1_55.bmp", "wb");
        conv1_out[55] = $fopen("./conv1_56.bmp", "wb");
        conv1_out[56] = $fopen("./conv1_57.bmp", "wb");
        conv1_out[57] = $fopen("./conv1_58.bmp", "wb");
        conv1_out[58] = $fopen("./conv1_59.bmp", "wb");
        conv1_out[59] = $fopen("./conv1_60.bmp", "wb");
        conv1_out[60] = $fopen("./conv1_61.bmp", "wb");
        conv1_out[61] = $fopen("./conv1_62.bmp", "wb");
        conv1_out[62] = $fopen("./conv1_63.bmp", "wb");
        conv1_out[63] = $fopen("./conv1_64.bmp", "wb");
		

        conv2_out[0] = $fopen( "./conv2_1.bmp", "wb");
        conv2_out[1] = $fopen("./conv2_2.bmp", "wb");
        conv2_out[2] = $fopen("./conv2_3.bmp", "wb");
        conv2_out[3] = $fopen("./conv2_4.bmp", "wb");
        conv2_out[4] = $fopen("./conv2_5.bmp", "wb");
        conv2_out[5] = $fopen("./conv2_6.bmp", "wb");
        conv2_out[6] = $fopen("./conv2_7.bmp", "wb");
        conv2_out[7] = $fopen("./conv2_8.bmp", "wb");
        conv2_out[8] = $fopen("./conv2_9.bmp", "wb");
        conv2_out[9] = $fopen("./conv2_10.bmp", "wb");
        conv2_out[10] = $fopen("./conv2_11.bmp", "wb");
        conv2_out[11] = $fopen("./conv2_12.bmp", "wb");
        conv2_out[12] = $fopen("./conv2_13.bmp", "wb");
        conv2_out[13] = $fopen("./conv2_14.bmp", "wb");
        conv2_out[14] = $fopen("./conv2_15.bmp", "wb");
        conv2_out[15] = $fopen("./conv2_16.bmp", "wb");
        conv2_out[16] = $fopen("./conv2_17.bmp", "wb");
        conv2_out[17] = $fopen("./conv2_18.bmp", "wb");
        conv2_out[18] = $fopen("./conv2_19.bmp", "wb");
        conv2_out[19] = $fopen("./conv2_20.bmp", "wb");
        conv2_out[20] = $fopen("./conv2_21.bmp", "wb");
        conv2_out[21] = $fopen("./conv2_22.bmp", "wb");
        conv2_out[22] = $fopen("./conv2_23.bmp", "wb");
        conv2_out[23] = $fopen("./conv2_24.bmp", "wb");
        conv2_out[24] = $fopen("./conv2_25.bmp", "wb");
        conv2_out[25] = $fopen("./conv2_26.bmp", "wb");
        conv2_out[26] = $fopen("./conv2_27.bmp", "wb");
        conv2_out[27] = $fopen("./conv2_28.bmp", "wb");
        conv2_out[28] = $fopen("./conv2_29.bmp", "wb");
        conv2_out[29] = $fopen("./conv2_30.bmp", "wb");
        conv2_out[30] = $fopen("./conv2_31.bmp", "wb");
        conv2_out[31] = $fopen("./conv2_32.bmp", "wb");
        conv2_out[32] = $fopen("./conv2_33.bmp", "wb");
        conv2_out[33] = $fopen("./conv2_34.bmp", "wb");
        conv2_out[34] = $fopen("./conv2_35.bmp", "wb");
        conv2_out[35] = $fopen("./conv2_36.bmp", "wb");
        conv2_out[36] = $fopen("./conv2_37.bmp", "wb");
        conv2_out[37] = $fopen("./conv2_38.bmp", "wb");
        conv2_out[38] = $fopen("./conv2_39.bmp", "wb");
        conv2_out[39] = $fopen("./conv2_40.bmp", "wb");
        conv2_out[40] = $fopen("./conv2_41.bmp", "wb");
        conv2_out[41] = $fopen("./conv2_42.bmp", "wb");
        conv2_out[42] = $fopen("./conv2_43.bmp", "wb");
        conv2_out[43] = $fopen("./conv2_44.bmp", "wb");
        conv2_out[44] = $fopen("./conv2_45.bmp", "wb");
        conv2_out[45] = $fopen("./conv2_46.bmp", "wb");
        conv2_out[46] = $fopen("./conv2_47.bmp", "wb");
        conv2_out[47] = $fopen("./conv2_48.bmp", "wb");
        conv2_out[48] = $fopen("./conv2_49.bmp", "wb");
        conv2_out[49] = $fopen("./conv2_50.bmp", "wb");
        conv2_out[50] = $fopen("./conv2_51.bmp", "wb");
        conv2_out[51] = $fopen("./conv2_52.bmp", "wb");
        conv2_out[52] = $fopen("./conv2_53.bmp", "wb");
        conv2_out[53] = $fopen("./conv2_54.bmp", "wb");
        conv2_out[54] = $fopen("./conv2_55.bmp", "wb");
        conv2_out[55] = $fopen("./conv2_56.bmp", "wb");
        conv2_out[56] = $fopen("./conv2_57.bmp", "wb");
        conv2_out[57] = $fopen("./conv2_58.bmp", "wb");
        conv2_out[58] = $fopen("./conv2_59.bmp", "wb");
        conv2_out[59] = $fopen("./conv2_60.bmp", "wb");
        conv2_out[60] = $fopen("./conv2_61.bmp", "wb");
        conv2_out[61] = $fopen("./conv2_62.bmp", "wb");
        conv2_out[62] = $fopen("./conv2_63.bmp", "wb");
        conv2_out[63] = $fopen("./conv2_64.bmp", "wb");
        $fread(img_data, img_in);

        img_w   = {img_data[21],img_data[20],img_data[19],img_data[18]};
        img_h   = {img_data[25],img_data[24],img_data[23],img_data[22]};
        offset  = {img_data[13],img_data[12],img_data[11],img_data[10]};


        for(header = 0; header < 54; header = header + 1) begin
			$fwrite(conv1_out[0], "%c", img_data[header]);
			$fwrite(conv1_out[1], "%c", img_data[header]);
			$fwrite(conv1_out[2], "%c", img_data[header]);
			$fwrite(conv1_out[3], "%c", img_data[header]);
			$fwrite(conv1_out[4], "%c", img_data[header]);
			$fwrite(conv1_out[5], "%c", img_data[header]);
			$fwrite(conv1_out[6], "%c", img_data[header]);
			$fwrite(conv1_out[7], "%c", img_data[header]);
			$fwrite(conv1_out[8], "%c", img_data[header]);
			$fwrite(conv1_out[9], "%c", img_data[header]);
			$fwrite(conv1_out[10], "%c", img_data[header]);
			$fwrite(conv1_out[11], "%c", img_data[header]);
			$fwrite(conv1_out[12], "%c", img_data[header]);
			$fwrite(conv1_out[13], "%c", img_data[header]);
			$fwrite(conv1_out[14], "%c", img_data[header]);
			$fwrite(conv1_out[15], "%c", img_data[header]);
			$fwrite(conv1_out[16], "%c", img_data[header]);
			$fwrite(conv1_out[17], "%c", img_data[header]);
			$fwrite(conv1_out[18], "%c", img_data[header]);
			$fwrite(conv1_out[19], "%c", img_data[header]);
			$fwrite(conv1_out[20], "%c", img_data[header]);
			$fwrite(conv1_out[21], "%c", img_data[header]);
			$fwrite(conv1_out[22], "%c", img_data[header]);
			$fwrite(conv1_out[23], "%c", img_data[header]);
			$fwrite(conv1_out[24], "%c", img_data[header]);
			$fwrite(conv1_out[25], "%c", img_data[header]);
			$fwrite(conv1_out[26], "%c", img_data[header]);
			$fwrite(conv1_out[27], "%c", img_data[header]);
			$fwrite(conv1_out[28], "%c", img_data[header]);
			$fwrite(conv1_out[29], "%c", img_data[header]);
			$fwrite(conv1_out[30], "%c", img_data[header]);
			$fwrite(conv1_out[31], "%c", img_data[header]);
			$fwrite(conv1_out[32], "%c", img_data[header]);
			$fwrite(conv1_out[33], "%c", img_data[header]);
			$fwrite(conv1_out[34], "%c", img_data[header]);
			$fwrite(conv1_out[35], "%c", img_data[header]);
			$fwrite(conv1_out[36], "%c", img_data[header]);
			$fwrite(conv1_out[37], "%c", img_data[header]);
			$fwrite(conv1_out[38], "%c", img_data[header]);
			$fwrite(conv1_out[39], "%c", img_data[header]);
			$fwrite(conv1_out[40], "%c", img_data[header]);
			$fwrite(conv1_out[41], "%c", img_data[header]);
			$fwrite(conv1_out[42], "%c", img_data[header]);
			$fwrite(conv1_out[43], "%c", img_data[header]);
			$fwrite(conv1_out[44], "%c", img_data[header]);
			$fwrite(conv1_out[45], "%c", img_data[header]);
			$fwrite(conv1_out[46], "%c", img_data[header]);
			$fwrite(conv1_out[47], "%c", img_data[header]);
			$fwrite(conv1_out[48], "%c", img_data[header]);
			$fwrite(conv1_out[49], "%c", img_data[header]);
			$fwrite(conv1_out[50], "%c", img_data[header]);
			$fwrite(conv1_out[51], "%c", img_data[header]);
			$fwrite(conv1_out[52], "%c", img_data[header]);
			$fwrite(conv1_out[53], "%c", img_data[header]);
			$fwrite(conv1_out[54], "%c", img_data[header]);
			$fwrite(conv1_out[55], "%c", img_data[header]);
			$fwrite(conv1_out[56], "%c", img_data[header]);
			$fwrite(conv1_out[57], "%c", img_data[header]);
			$fwrite(conv1_out[58], "%c", img_data[header]);
			$fwrite(conv1_out[59], "%c", img_data[header]);
			$fwrite(conv1_out[60], "%c", img_data[header]);
			$fwrite(conv1_out[61], "%c", img_data[header]);
			$fwrite(conv1_out[62], "%c", img_data[header]);
			$fwrite(conv1_out[63], "%c", img_data[header]);
			
			
			$fwrite(conv2_out[0], "%c", img_data[header]);
			$fwrite(conv2_out[1], "%c", img_data[header]);
			$fwrite(conv2_out[2], "%c", img_data[header]);
			$fwrite(conv2_out[3], "%c", img_data[header]);
			$fwrite(conv2_out[4], "%c", img_data[header]);
			$fwrite(conv2_out[5], "%c", img_data[header]);
			$fwrite(conv2_out[6], "%c", img_data[header]);
			$fwrite(conv2_out[7], "%c", img_data[header]);
			$fwrite(conv2_out[8], "%c", img_data[header]);
			$fwrite(conv2_out[9], "%c", img_data[header]);
			$fwrite(conv2_out[10], "%c", img_data[header]);
			$fwrite(conv2_out[11], "%c", img_data[header]);
			$fwrite(conv2_out[12], "%c", img_data[header]);
			$fwrite(conv2_out[13], "%c", img_data[header]);
			$fwrite(conv2_out[14], "%c", img_data[header]);
			$fwrite(conv2_out[15], "%c", img_data[header]);
			$fwrite(conv2_out[16], "%c", img_data[header]);
			$fwrite(conv2_out[17], "%c", img_data[header]);
			$fwrite(conv2_out[18], "%c", img_data[header]);
			$fwrite(conv2_out[19], "%c", img_data[header]);
			$fwrite(conv2_out[20], "%c", img_data[header]);
			$fwrite(conv2_out[21], "%c", img_data[header]);
			$fwrite(conv2_out[22], "%c", img_data[header]);
			$fwrite(conv2_out[23], "%c", img_data[header]);
			$fwrite(conv2_out[24], "%c", img_data[header]);
			$fwrite(conv2_out[25], "%c", img_data[header]);
			$fwrite(conv2_out[26], "%c", img_data[header]);
			$fwrite(conv2_out[27], "%c", img_data[header]);
			$fwrite(conv2_out[28], "%c", img_data[header]);
			$fwrite(conv2_out[29], "%c", img_data[header]);
			$fwrite(conv2_out[30], "%c", img_data[header]);
			$fwrite(conv2_out[31], "%c", img_data[header]);
			$fwrite(conv2_out[32], "%c", img_data[header]);
			$fwrite(conv2_out[33], "%c", img_data[header]);
			$fwrite(conv2_out[34], "%c", img_data[header]);
			$fwrite(conv2_out[35], "%c", img_data[header]);
			$fwrite(conv2_out[36], "%c", img_data[header]);
			$fwrite(conv2_out[37], "%c", img_data[header]);
			$fwrite(conv2_out[38], "%c", img_data[header]);
			$fwrite(conv2_out[39], "%c", img_data[header]);
			$fwrite(conv2_out[40], "%c", img_data[header]);
			$fwrite(conv2_out[41], "%c", img_data[header]);
			$fwrite(conv2_out[42], "%c", img_data[header]);
			$fwrite(conv2_out[43], "%c", img_data[header]);
			$fwrite(conv2_out[44], "%c", img_data[header]);
			$fwrite(conv2_out[45], "%c", img_data[header]);
			$fwrite(conv2_out[46], "%c", img_data[header]);
			$fwrite(conv2_out[47], "%c", img_data[header]);
			$fwrite(conv2_out[48], "%c", img_data[header]);
			$fwrite(conv2_out[49], "%c", img_data[header]);
			$fwrite(conv2_out[50], "%c", img_data[header]);
			$fwrite(conv2_out[51], "%c", img_data[header]);
			$fwrite(conv2_out[52], "%c", img_data[header]);
			$fwrite(conv2_out[53], "%c", img_data[header]);
			$fwrite(conv2_out[54], "%c", img_data[header]);
			$fwrite(conv2_out[55], "%c", img_data[header]);
			$fwrite(conv2_out[56], "%c", img_data[header]);
			$fwrite(conv2_out[57], "%c", img_data[header]);
			$fwrite(conv2_out[58], "%c", img_data[header]);
			$fwrite(conv2_out[59], "%c", img_data[header]);
			$fwrite(conv2_out[60], "%c", img_data[header]);
			$fwrite(conv2_out[61], "%c", img_data[header]);
			$fwrite(conv2_out[62], "%c", img_data[header]);
			$fwrite(conv2_out[63], "%c", img_data[header]);
        end
    end
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    always begin
		#(`period/2.0) clk <= ~clk;
	end


endmodule