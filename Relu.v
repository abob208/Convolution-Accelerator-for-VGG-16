module Relu( in, out, bias, clk ) ;

	input in ;
	input clk ;
	input bias ;
	wire signed [15:0] bias ;
	wire [7:0] in ;
	output reg [31:0] out ;
	always@(posedge clk ) begin
		if ( in + bias < 0 )
			out = 0 ;
		else if ( in + bias > 0 )
			out = in + bias ;
	end




endmodule