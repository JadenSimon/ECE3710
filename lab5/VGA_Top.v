module VGA_Top(clk, reset, slowclk, red, green, blue, hSync, vSync);

	input clk, reset;
	output reg slowclk = 1'b0;
	output wire [4:0] red, green, blue;
	output wire hSync, vSync;
	
	wire bright;
	wire [9:0] hCount, vCount;
	wire [15:0] pixel;
	
	wire [15:0] test_addr;
	reg [15:0] test_out;

	// Instantiate the VGA_Display and VGAController modules
	VGA_Display display(slowclk, reset, hSync, vSync, hCount, vCount, bright);
	VGAController controller(clk, hCount, vCount, test_addr, test_out, pixel);
	
	// Don't use the alpha bit and check for bright
	assign red = bright ? pixel[15:11] : 5'b0;
	assign green = bright ? pixel[10:6] : 5'b0;
	assign blue = bright ? pixel[5:1] : 5'b0;
	
	// 50 MHz clock to 25 MHz
	always@(posedge clk)
	begin
		slowclk <= ~slowclk;
	end

	// Some test stuff
	reg [9:0] temp_x, temp_y;
	reg [1:0] temp_angle;
	reg [19:0] test_counter = 20'b0;
	reg swap = 1'b0;
	always@(posedge clk) test_counter <= test_counter + 1'b1;
	
	always@(posedge test_counter[19])
	begin
		if (temp_x == 10'd10 && swap)
			swap <= 1'b0;
		else if (temp_x == 10'd598 && !swap)
			swap <= 1'b1;
		
		if (swap)
		begin
			temp_x <= temp_x - 10'b1;
			temp_angle <= 2'b01;
		end
		else
		begin
			temp_x <= temp_x + 10'b1;
			temp_angle <= 2'b11;
		end
		
		temp_y <= 10'd10;
	end
	
	always@(*)
	begin
		if (test_addr == 16'b0000_1111_0000_1111)
			test_out = temp_x;
		else if (test_addr == 16'b0000_1111_0000_1110)
			test_out = temp_y;
		else if (test_addr == 16'b0000_1110_0111_0010)
			test_out = temp_angle;
		else if (test_addr[15:4] == 12'b0000_1111_1111)
			test_out = {12'b0, test_addr[3:0] + swap};
		else
			test_out = 16'b0001;
	end
	

endmodule
