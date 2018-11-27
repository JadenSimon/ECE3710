// Tester module
module VGA_Tb();

	reg clk, reset;
	
	wire slowclk, hSync, vSync;
	wire [4:0] red, green, blue;

	// Instantiate the VGA_Display and VGAController modules
	VGA_Top top(clk, reset, slowclk, red, green, blue, hSync, vSync);

	initial begin
		clk = 0;
		reset = 0;
		
		#100000;
		
		$finish;
	end
	
	always begin
		#10;
		clk = ~clk;
	end

endmodule
