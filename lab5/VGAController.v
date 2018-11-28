module VGAController(clk, h_count, v_count, pixel);
	parameter INPUT_WIDTH = 10;
	parameter PIXEL_SIZE = 16;
	
	// Static memory locations
	
	
	input clk;
	input wire [(INPUT_WIDTH-1):0] h_count, v_count;
	output reg [(PIXEL_SIZE-1):0] pixel;
	
	// Create wires for the sprite modules
	wire [(INPUT_WIDTH-1):0] x_in, y_in;
	wire [(PIXEL_SIZE-1):0] player1_pixel, player2_pixel, proj1_pixel, proj2_pixel;
	wire [(PIXEL_SIZE-1):0] background_pixel;
	
	// Create registers to store memory data
	reg [(INPUT_WIDTH-1):0] player1_x, player1_y, player2_x, player2_y;
	reg [(INPUT_WIDTH-1):0] proj1_x, proj1_y, proj2_x, proj2_y;
	reg [1:0] player1_angle, player2_angle, proj1_angle, proj2_angle;
	reg [1:0] game_state;
	
	// Background module inputs
	reg [8:0] glyph_addr = 9'd42;
	reg [3:0] glyph_id;
	reg write_glyph;
	
	// Create module active wires
	wire player1_draw, player2_draw, proj1_draw, proj2_draw;
	
	// Create the background module
	BackgroundController background(clk, x_in, y_in, write_glyph, glyph_addr, glyph_id, background_pixel); 
	
	// Instantiate all hardware sprite modules
	HardwareSprite #(10, 16, 32, "eagle_up.data") player1(clk, x_in, y_in, player1_x, player1_y, player1_angle, player1_draw, player1_pixel);
	HardwareSprite #(10, 16, 32, "murica_tank_up.data") player2(clk, x_in, y_in, player2_x, player2_y, player2_angle, player2_draw, player2_pixel);
	HardwareSprite #(10, 16, 32, "ussr_tank_up.data") proj1(clk, x_in, y_in, proj1_x, proj1_y, proj1_angle, proj1_draw, proj1_pixel);
	HardwareSprite #(10, 16, 32, "bear_up.data") proj2(clk, x_in, y_in, proj2_x, proj2_y, proj2_angle, proj2_draw, proj2_pixel);
	
	// Logic to account for counters being able to go off screen plus one to account for delay
	assign x_in = h_count - 10'd143;
	assign y_in = v_count - 10'd33;
	
	// test stuff
	reg [9:0] temp_x, temp_y;
	reg [1:0] temp_angle;
	reg [3:0] temp_id;
	
	// Handles vertical blanking loading
	always@(posedge clk)
	begin
		// If we are in the vertical blanking phase
		if (v_count >= 10'd518) 
		begin
			// Load stuff
			player1_x = temp_x;
			player1_y = temp_y;
			player1_angle = temp_angle;
			player2_x = 10'd10;
			player2_y = 10'd10;
			player2_angle = 2'b0;
			proj1_x = 10'd42;
			proj1_y = 10'd10;
			proj1_angle = 2'b10;
			proj2_x = 10'd42;
			proj2_y = 10'd42;
			proj2_angle = 2'b0;
			game_state = 2'b0;
			glyph_id = temp_id;
			write_glyph = 1'b1;
		end
		else
			write_glyph = 1'b0;
	end
	
	// Handles sprite overlap stuff
	always@(posedge clk)
	begin
		if (player1_draw && player1_pixel[0] == 1)
			pixel <= player1_pixel;
		else if (player2_draw && player2_pixel[0] == 1)
			pixel <= player2_pixel;
		else if (proj1_draw && proj1_pixel[0] == 1)
			pixel <= proj1_pixel;
		else if (proj2_draw && proj2_pixel[0] == 1)
			pixel <= proj2_pixel;
		else if (background_pixel[0] == 1)
			pixel <= background_pixel;
		else
			pixel <= 16'b0;
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
		begin
			temp_x <= temp_x - 10'b1;
			temp_angle <= 2'b01;
			temp_id = 4'b10;
		end
		else
		begin
			temp_x <= temp_x + 10'b1;
			temp_angle <= 2'b11;
			temp_id = 4'b01;
		end
		
		temp_y <= 10'd10;
	end
	
endmodule
