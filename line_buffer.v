module line_buffer( clk, pixel_00, pixel_01, pixel_02, 
		                 pixel_10, pixel_11, pixel_12, 
		                 pixel_20, pixel_21, pixel_22, in_pixel ) ;
	input clk ;
	input in_pixel ;
	wire [7:0] in_pixel ;
	integer i ;
	output pixel_00, pixel_01, pixel_02, 
		   pixel_10, pixel_11, pixel_12, 
		   pixel_20, pixel_21, pixel_22 ;
		   
	reg [7:0] pixel_00, pixel_01, pixel_02, 
		      pixel_10, pixel_11, pixel_12, 
		      pixel_20, pixel_21, pixel_22 ;
			  

	reg [7:0] row1_buffer[0:225] ;
	reg [7:0] row2_buffer[0:225] ;
	reg [7:0] row3_buffer[0:2] ;
	

	always@( posedge clk ) begin
	
		pixel_00 <= row1_buffer[0] ;
		pixel_01 <= row1_buffer[1] ;
		pixel_02 <= row1_buffer[2] ;
		pixel_10 <= row2_buffer[0] ;
		pixel_11 <= row2_buffer[1] ;
		pixel_12 <= row2_buffer[2] ;
		pixel_20 <= row3_buffer[0] ;
		pixel_21 <= row3_buffer[1] ;
		pixel_22 <= row3_buffer[2] ;
		for ( i = 0 ; i < 225 ; i = i + 1 ) begin
			row1_buffer[i] <= row1_buffer[i+1] ;
			row2_buffer[i] <= row2_buffer[i+1] ;
		end

		row1_buffer[225] <= row2_buffer[0] ;
		row2_buffer[225] <= row3_buffer[0] ;
		row3_buffer[0] <= row3_buffer[1] ;
		row3_buffer[1] <= row3_buffer[2] ;
		row3_buffer[2] <= in_pixel ;
	
	end
endmodule