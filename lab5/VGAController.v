module VGAController(clk, h_count, v_count, pixel);
	parameter INPUT_WIDTH = 10;
	parameter PIXEL_SIZE = 16;
	
	// Static memory locations
	
	
	input clk;
	input wire [(INPUT_WIDTH-1):0] h_count, v_count;
	output reg [(PIXEL_SIZE-1):0] pixel;
	
	// Create x/y position wires
	wire [(INPUT_WIDTH-1):0] x_in, y_in;
	
	// Create pixel output wires
	wire [(PIXEL_SIZE-1):0] player1_pixel, player2_pixel, proj1_pixel, proj2_pixel;
	
	// Create x/y position registers
	reg [(INPUT_WIDTH-1):0] player1_x, player1_y, player2_x, player2_y;
	reg [(INPUT_WIDTH-1):0] proj1_x, proj1_y, proj2_x, proj2_y;

	// Create module active wires
	wire player1_draw, player2_draw, proj1_draw, proj2_draw;
	
	// Instantiate all hardware sprite modules
	HardwareSprite #(10, 16, 32, "test2.data") player1(clk, x_in, y_in, player1_x, player1_y, player1_draw, player1_pixel);
	HardwareSprite #(10, 16, 32, "test2.data") player2(clk, x_in, y_in, player2_x, player2_y, player2_draw, player2_pixel);
	HardwareSprite #(10, 16, 32, "test2.data") proj1(clk, x_in, y_in, proj1_x, proj1_y, proj1_draw, proj1_pixel);
	HardwareSprite #(10, 16, 32, "test2.data") proj2(clk, x_in, y_in, proj2_x, proj2_y, proj2_draw, proj2_pixel);
	
	// Logic to account for counters being able to go off screen plus one to account for delay
	assign x_in = h_count - 10'd143;
	assign y_in = v_count - 10'd34;
	
	
	// test stuff
	reg [9:0] temp_x, temp_y;
	
	
	// Handles vertical blanking loading
	always@(posedge clk)
	begin
		// If we are in the vertical blanking phase
		if (v_count >= 10'd518) begin
			// Load stuff
			player1_x = temp_x;
			player1_y = temp_y;
			player2_x = 10'b0;
			player2_y = 10'b0;
			proj1_x = 10'b0;
			proj1_y = 10'b0;
			proj2_x = 10'b0;
			proj2_y = 10'b0;
		end
	end
	
	// Handles sprite overlap stuff
	always@(posedge clk)
	begin
		if (player1_draw && player1_pixel[15] == 0)
			pixel <= player1_pixel;
		else if (h_count <= 10'd355) 
			pixel <= 16'b1111100000000000;
		else if (h_count <= 10'd568)
			pixel <= 16'b0000011111000000;
		else
			pixel <= 16'b0000000000111110;
	end
	
	// Some test stuff
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
			temp_x <= temp_x - 10'b1;
		else
			temp_x <= temp_x + 10'b1;
		
		temp_y <= 10'd10;
	end
	
endmodule
