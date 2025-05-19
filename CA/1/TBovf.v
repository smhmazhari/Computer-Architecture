module TB_ovf;
	reg [9:0] A , B ;
	wire [9:0] Q;
	reg reset,start,clock;
	wire busy,ovf,valid;
	wire dvz;
 	divider CUT(A,B,Q,reset,start,clock,busy,dvz,ovf,valid);
	
	initial
	begin
	start = 1'b0;
	clock = 1'b0;

	A = 10'b10_0000_0000;B = 10'b00_0000_0001;
	#10 reset = 1;
	#20 reset = 0;
	#20 start = 1;
	#20 start = 0;
	#2650 $stop;
	end
	always	
	begin
	#20 clock = ~clock;
	end
endmodule