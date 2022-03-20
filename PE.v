module PE( pixel_00, pixel_01, pixel_02, 
		     pixel_10, pixel_11, pixel_12, 
		     pixel_20, pixel_21, pixel_22,
			 weight_00, weight_01, weight_02, 
		     weight_10, weight_11, weight_12, 
		     weight_20, weight_21, weight_22,
			 out_pixel_00, out_pixel_01, out_pixel_02, 
		     out_pixel_10, out_pixel_11, out_pixel_12, 
		     out_pixel_20, out_pixel_21, out_pixel_22, total, clk ) ;


	input pixel_00, pixel_01, pixel_02, 
		  pixel_10, pixel_11, pixel_12, 
		  pixel_20, pixel_21, pixel_22,
		  weight_00, weight_01, weight_02, 
		  weight_10, weight_11, weight_12, 
		  weight_20, weight_21, weight_22 ;
	
	input clk ;
	output out_pixel_00, out_pixel_01, out_pixel_02, 
		   out_pixel_10, out_pixel_11, out_pixel_12, 
		   out_pixel_20, out_pixel_21, out_pixel_22 ;
	output total ;
	reg signed[31:0] out_pixel_00, out_pixel_01, out_pixel_02, 
		      out_pixel_10, out_pixel_11, out_pixel_12, 
		      out_pixel_20, out_pixel_21, out_pixel_22 ;

	reg signed[31:0] total ;

	wire [7:0] pixel_00, pixel_01, pixel_02, 
		      pixel_10, pixel_11, pixel_12, 
		      pixel_20, pixel_21, pixel_22 ;
	wire signed [15:0] weight_00, weight_01, weight_02, 
		       weight_10, weight_11, weight_12, 
		       weight_20, weight_21, weight_22 ;			  
	always@( posedge clk )begin
		out_pixel_00 = pixel_00 * weight_00 ;
		out_pixel_01 = pixel_01 * weight_01 ;
		out_pixel_02 = pixel_02 * weight_02 ;
		out_pixel_10 = pixel_10 * weight_10 ;
		out_pixel_11 = pixel_11 * weight_11 ;
		out_pixel_12 = pixel_12 * weight_12 ;
		out_pixel_20 = pixel_20 * weight_20 ;
		out_pixel_21 = pixel_21 * weight_21 ;
		out_pixel_22 = pixel_22 * weight_22 ;
		// total = out_pixel_00 + out_pixel_01 + out_pixel_02 + out_pixel_10 + out_pixel_11 + out_pixel_12 + out_pixel_20 + out_pixel_21 + out_pixel_22 ;
			
	end
	

endmodule

