module TOP( clk, in_pixel, 
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

	input clk, in_pixel, bias1, bias2, bias3, bias4 ;
	input kernal1_00, kernal1_01, kernal1_02, 
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

	wire signed [15:0] bias1, bias2, bias3, bias4 ;
	output  wire [31:0] partial_sum1, partial_sum2, partial_sum3, partial_sum4 ;
	wire [7:0] in_pixel ;
	wire [7:0] pixel_00, pixel_01, pixel_02, 
		       pixel_10, pixel_11, pixel_12, 
		       pixel_20, pixel_21, pixel_22 ;

	wire signed [31:0] out_pixel_pe1, out_pixel_pe2, out_pixel_pe3,
			   out_pixel_pe4, out_pixel_pe5, out_pixel_pe6,
			   out_pixel_pe7, out_pixel_pe8, out_pixel_pe9,
			   out2_pixel_pe1, out2_pixel_pe2, out2_pixel_pe3,
			   out2_pixel_pe4, out2_pixel_pe5, out2_pixel_pe6,
			   out2_pixel_pe7, out2_pixel_pe8, out2_pixel_pe9,
			   out3_pixel_pe1, out3_pixel_pe2, out3_pixel_pe3,
			   out3_pixel_pe4, out3_pixel_pe5, out3_pixel_pe6,
			   out3_pixel_pe7, out3_pixel_pe8, out3_pixel_pe9 ,
			   	out4_pixel_pe1, out4_pixel_pe2, out4_pixel_pe3,
			 out4_pixel_pe4, out4_pixel_pe5, out4_pixel_pe6,
			 out4_pixel_pe7, out4_pixel_pe8, out4_pixel_pe9;

	wire signed [15:0] kernal1_00, kernal1_01, kernal1_02, 
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
	wire signed [31:0] adder1_out, adder2_out, adder3_out, adder4_out ;
	//output wire signed [31:0] adder1_out, adder2_out, adder3_out, adder4_out ;
	line_buffer LB( clk, pixel_00, pixel_01, pixel_02, 
		                 pixel_10, pixel_11, pixel_12, 
		                 pixel_20, pixel_21, pixel_22, in_pixel ) ;

	PE pe1( pixel_00, pixel_01, pixel_02, 
		     pixel_10, pixel_11, pixel_12, 
		     pixel_20, pixel_21, pixel_22,
			kernal1_00, kernal1_01, kernal1_02, 
		    kernal1_10, kernal1_11, kernal1_12, 
		    kernal1_20, kernal1_21, kernal1_22,
			 out_pixel_pe1, out_pixel_pe2, out_pixel_pe3,
			 out_pixel_pe4, out_pixel_pe5, out_pixel_pe6,
			 out_pixel_pe7, out_pixel_pe8, out_pixel_pe9, adder1_out, clk ) ;
	PE pe2( pixel_00, pixel_01, pixel_02, 
		     pixel_10, pixel_11, pixel_12, 
		     pixel_20, pixel_21, pixel_22,
			kernal2_00, kernal2_01, kernal2_02, 
		    kernal2_10, kernal2_11, kernal2_12, 
		    kernal2_20, kernal2_21, kernal2_22, 			 
			 out2_pixel_pe1, out2_pixel_pe2, out2_pixel_pe3,
			 out2_pixel_pe4, out2_pixel_pe5, out2_pixel_pe6,
			 out2_pixel_pe7, out2_pixel_pe8, out2_pixel_pe9, adder2_out,clk ) ;
	PE pe3( pixel_00, pixel_01, pixel_02, 
		     pixel_10, pixel_11, pixel_12, 
		     pixel_20, pixel_21, pixel_22,
			 kernal3_00, kernal3_01, kernal3_02, 
		    kernal3_10, kernal3_11, kernal3_12, 
		    kernal3_20, kernal3_21, kernal3_22, 
			 out3_pixel_pe1, out3_pixel_pe2, out3_pixel_pe3,
			 out3_pixel_pe4, out3_pixel_pe5, out3_pixel_pe6,
			 out3_pixel_pe7, out3_pixel_pe8, out3_pixel_pe9, adder3_out,clk ) ;

	PE pe4( pixel_00, pixel_01, pixel_02, 
		     pixel_10, pixel_11, pixel_12, 
		     pixel_20, pixel_21, pixel_22,
			 kernal4_00, kernal4_01, kernal4_02, 
		    kernal4_10, kernal4_11, kernal4_12, 
		    kernal4_20, kernal4_21, kernal4_22, 
			 out4_pixel_pe1, out4_pixel_pe2, out4_pixel_pe3,
			 out4_pixel_pe4, out4_pixel_pe5, out4_pixel_pe6,
			 out4_pixel_pe7, out4_pixel_pe8, out4_pixel_pe9, adder4_out,clk ) ;

	Adder_tree adder_tree1( out_pixel_pe1, out_pixel_pe2, out_pixel_pe3,
							out_pixel_pe4, out_pixel_pe5, out_pixel_pe6,
							out_pixel_pe7, out_pixel_pe8, out_pixel_pe9, partial_sum1, clk ) ;

	Adder_tree adder_tree2( out2_pixel_pe1, out2_pixel_pe2, out2_pixel_pe3,
							out2_pixel_pe4, out2_pixel_pe5, out2_pixel_pe6,
							out2_pixel_pe7, out2_pixel_pe8, out2_pixel_pe9, partial_sum2, clk ) ;

	Adder_tree adder_tree3( out3_pixel_pe1, out3_pixel_pe2, out3_pixel_pe3,
							out3_pixel_pe4, out3_pixel_pe5, out3_pixel_pe6,
							out3_pixel_pe7, out3_pixel_pe8, out3_pixel_pe9, partial_sum3, clk ) ;

	Adder_tree adder_tree4( out4_pixel_pe1, out4_pixel_pe2, out4_pixel_pe3,
							out4_pixel_pe4, out4_pixel_pe5, out4_pixel_pe6,
							out4_pixel_pe7, out4_pixel_pe8, out4_pixel_pe9, partial_sum4, clk ) ;
endmodule