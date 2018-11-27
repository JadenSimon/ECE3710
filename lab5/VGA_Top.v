module VGA_Top(clk, reset, slowclk, red, green, blue, hSync, vSync);

	input clk, reset;
	output reg slowclk = 1'b0;
	output wire [4:0] red, green, blue;
	output wire hSync, vSync;
	
	wire bright;
	wire [9:0] hCount, vCount;
	wire [15:0] pixel;

	// Instantiate the VGA_Display and VGAController modules
	VGA_Display display(slowclk, reset, hSync, vSync, hCount, vCount, bright);
	VGAController controller(clk, hCount, vCount, pixel);
	
	// Don't use the alpha bit and check for bright
	assign red = bright ? pixel[15:11] : 5'b0;
	assign green = bright ? pixel[10:6] : 5'b0;
	assign blue = bright ? pixel[5:1] : 5'b0;
	
	// 50 MHz clock to 25 MHz
	always@(posedge clk)
	begin
		slowclk <= ~slowclk;
	end


endmodule
