module Adder_tree( in1, in2, in3, 
				   in4, in5, in6,
				   in7, in8, in9, total, clk ) ;
	
	
	input in1, in2, in3, 
		  in4, in5, in6,
		  in7, in8, in9 ;
	
	input clk ;
	output total ;
	wire signed [31:0] in1, in2, in3, 
		          in4, in5, in6,
		          in7, in8, in9 ;

    wire signed [15:0] bias ;
	reg signed [31:0] total ;
	reg signed [31:0] temp12, temp34, temp56, temp78, temp9, temp9_2,
					  temp1234, temp5678 ;	
	always@( posedge clk )begin

		temp12 <= in1 + in2 ;
		temp34 <= in3 + in4 ;
		temp56 <= in5 + in6 ;
		temp78 <= in7 + in8 ;
		temp9 <= in9 ;

		temp1234 <= temp12 + temp34 ;
		temp5678 <= temp56 + temp78 ;
		temp9_2 <= temp9 ;

		total <= temp1234 + temp5678 + temp9_2 ;

		// total <= in1 + in2 + in3 + in4 + in5 + in6 + in7 + in8 + in9 ;
	end
				   
				   
				   
				   

endmodule