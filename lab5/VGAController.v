module VGAController(clk, h_count, v_count, mem_addr, mem_out, pixel);
	parameter INPUT_WIDTH = 10;
	parameter PIXEL_SIZE = 16;
	
	/* STATIC MEMORY LOCATIONS */
	localparam PLAYER1_X = 					16'b0000_1111_0000_1111;
	localparam PLAYER1_Y = 					16'b0000_1111_0000_1110;
	localparam PLAYER2_X = 					16'b0000_1111_0000_1101;
	localparam PLAYER2_Y = 					16'b0000_1111_0000_1100;
	localparam PLAYER1_HEALTH = 			16'b0000_1110_0111_0100;
	localparam PLAYER2_HEALTH = 			16'b0000_1110_0111_0011;
	localparam PLAYER1_ANGLE =				16'b0000_1110_0111_0010;
	localparam PLAYER2_ANGLE =				16'b0000_1110_0111_0001;
	localparam PROJ1_ANGLE =				16'b0000_1110_0111_0000;
	localparam PROJ2_ANGLE =				16'b0000_1110_0110_1111;
	localparam PROJ1_X =						16'b0000_1111_0000_1011;
	localparam PROJ1_Y =						16'b0000_1111_0000_1010;
	localparam PROJ2_X =						16'b0000_1111_0000_1001;
	localparam PROJ2_Y =						16'b0000_1111_0000_1000;
	localparam EXPLO1_FRAME_ID =			16'b0001_0001_0010_0001;
	localparam EXPLO1_X =					16'b0001_0001_0010_0000;
	localparam EXPLO1_Y =					16'b0001_0001_0001_1111;
	localparam EXPLO2_FRAME_ID =			16'b0001_0001_0001_1110;
	localparam EXPLO2_X =					16'b0001_0001_0001_1101;
	localparam EXPLO2_Y =					16'b0001_0001_0001_1100;
	localparam PLAYER1_ID =					16'b0000_1111_0001_0000;
	localparam PLAYER2_ID =					16'b0000_1111_0001_0001;
	localparam PROJ1_ID =					16'b0000_1111_0001_0010;
	localparam PROJ2_ID =					16'b0000_1111_0001_0011;
	localparam GAME_STATE = 				16'b0000_1111_0000_0111;
	localparam MAPPING = 					16'b0000_1111_1111_0000;
	localparam FONT_MAPPING = 				16'b0001_0001_0001_1111;
	localparam FONT_SCALE =					16'b0001_0001_0001_1110;
	/***************************/ 
	
	 
	input clk;
	input wire [(INPUT_WIDTH-1):0] h_count, v_count;
	input wire [15:0] mem_out; // Used to read from main memory
	output reg [15:0] mem_addr;
	output reg [(PIXEL_SIZE-1):0] pixel;
	
	// Create wires for the sprite modules
	wire [(INPUT_WIDTH-1):0] x_in, y_in;
	wire [(PIXEL_SIZE-1):0] player1_pixel, player2_pixel, proj1_pixel, proj2_pixel, explo1_pixel, explo2_pixel;
	wire [(PIXEL_SIZE-1):0] background_pixel, font_pixel;
	
	// Create registers to store memory data
	reg [(INPUT_WIDTH-1):0] player1_x, player1_y, player2_x, player2_y; 
	reg [(INPUT_WIDTH-1):0] proj1_x, proj1_y, proj2_x, proj2_y;
	reg [(INPUT_WIDTH-1):0] explo1_x, explo1_y, explo2_x, explo2_y;
	reg [1:0] player1_angle, player2_angle, proj1_angle, proj2_angle, explo1_angle, explo2_angle;
	reg [3:0] player1_frame, player2_frame, proj1_frame, proj2_frame, explo1_frame, explo2_frame;
	reg [1:0] game_state; // 4 game states
	reg [3:0] player1_health, player2_health;
	
	// Background module inputs
	reg [8:0] background_addr;
	reg [3:0] background_id;
	reg write_background;
	
	// Font module inputs
	reg [12:0] font_addr;
	reg [15:0] font_id;
	reg [1:0] font_scale;
	reg write_font;
	
	// Create module active wires
	wire player1_draw, player2_draw, proj1_draw, proj2_draw, explo1_draw, explo2_draw;
	
	// Create the background module
	BackgroundController background(clk, x_in, y_in, write_background, background_addr, background_id, background_pixel);
	
	// Create the font module
	FontController font(clk, x_in, y_in, write_font, font_addr, font_id, font_scale, font_pixel);
	
	// Instantiate all hardware sprite modules
	HardwareSprite #(10, 16, 32, 4, "murica_tank.data") player1(clk, x_in, y_in, player1_x, player1_y, player1_angle, player1_frame, player1_draw, player1_pixel);
	HardwareSprite #(10, 16, 32, 4, "ussr_tank.data") player2(clk, x_in, y_in, player2_x, player2_y, player2_angle, player2_frame, player2_draw, player2_pixel);
	HardwareSprite #(10, 16, 32, 4, "eagle.data") proj1(clk, x_in, y_in, proj1_x, proj1_y, proj1_angle, proj1_frame, proj1_draw, proj1_pixel);
	HardwareSprite #(10, 16, 32, 4, "nuke.data") proj2(clk, x_in, y_in, proj2_x, proj2_y, proj2_angle, proj2_frame, proj2_draw, proj2_pixel);
	HardwareSprite #(10, 16, 32, 4, "explosion.data") explo1(clk, x_in, y_in, explo1_x, explo1_y, explo1_angle, explo1_frame, explo1_draw, explo1_pixel);
	HardwareSprite #(10, 16, 32, 4, "explosion.data") explo2(clk, x_in, y_in, explo2_x, explo2_y, explo2_angle, explo2_frame, explo2_draw, explo2_pixel);

	
	// Logic to account for counters being able to go off screen plus one to account for delay
	assign x_in = h_count - 10'd142;
	assign y_in = v_count - 10'd33;
	
	// Handles sprite overlap stuff
	always@(posedge clk) 
	begin 
		if (font_pixel[0] == 1) 
			pixel <= font_pixel;
		else if (explo1_draw && explo1_pixel[0] == 1)
			pixel <= explo1_pixel;
		else if (explo2_draw && explo2_pixel[0] == 1)
			pixel <= explo2_pixel;
		else if (proj1_draw && proj1_pixel[0] == 1)
			pixel <= proj1_pixel;
		else if (proj2_draw && proj2_pixel[0] == 1)
			pixel <= proj2_pixel;
		else if (player1_draw && player1_pixel[0] == 1)
			pixel <= player1_pixel;
		else if (player2_draw && player2_pixel[0] == 1)
			pixel <= player2_pixel;
		else if (background_pixel[0] == 1)
			pixel <= background_pixel;
		else
			pixel <= 16'b0;
	end
	
	
	// This block handles loading from memory during the vertical front porch.
	// Uses its own state variable to determine what to load and when.
	reg [7:0] load_state = 8'b0;
	
	always@(posedge clk)
	begin
		// If we are in the vertical blanking phase
		if (v_count >= 10'd511) 
		begin
			// Increase the load state every cycle
			if (load_state != 8'b11111111)
				load_state <= load_state + 1'b1;
		
			// Sets the correct addresses
			case (load_state)
				8'b00000000: mem_addr <= PLAYER1_X;
				8'b00000001: mem_addr <= PLAYER1_Y;
				8'b00000010: mem_addr <= PLAYER2_X;
				8'b00000011: mem_addr <= PLAYER2_Y;
				8'b00000100: mem_addr <= PLAYER1_HEALTH;
				8'b00000101: mem_addr <= PLAYER2_HEALTH;
				8'b00000110: mem_addr <= PLAYER1_ANGLE;
				8'b00000111: mem_addr <= PLAYER2_ANGLE;
				8'b00001000: mem_addr <= PROJ1_ANGLE;
				8'b00001001: mem_addr <= PROJ2_ANGLE;
				8'b00001010: mem_addr <= PROJ1_X;
				8'b00001011: mem_addr <= PROJ1_Y;
				8'b00001100: mem_addr <= PROJ2_X;
				8'b00001101: mem_addr <= PROJ2_Y;
				8'b00001110: mem_addr <= EXPLO1_FRAME_ID;
				8'b00001111: mem_addr <= EXPLO1_X;
				8'b00010000: mem_addr <= EXPLO1_Y;
				8'b00010001: mem_addr <= EXPLO2_FRAME_ID;
				8'b00010010: mem_addr <= EXPLO2_X;
				8'b00010011: mem_addr <= EXPLO2_Y;		
				8'b00010100: mem_addr <= PLAYER1_ID;
				8'b00010101: mem_addr <= PLAYER2_ID;
				8'b00010110: mem_addr <= PROJ1_ID;
				8'b00010111: mem_addr <= PROJ2_ID;
				8'b00011000: mem_addr <= GAME_STATE;
				8'b00011001: mem_addr <= FONT_SCALE;
				8'b00011010: mem_addr <= MAPPING;
				8'b00011011: // Game mapping load state
					begin
						if (background_addr < 9'd300)
						begin
							load_state <= load_state; // Stay on this state until we go through the whole map.
							mem_addr <= mem_addr + 1'b1;
						end
					end
//				8'b00011100: mem_addr <= FONT_MAPPING;
//				8'b00011101: // Font mapping load state
//					begin
//						if (font_addr < 13'd4800)
//						begin
//							load_state <= load_state;
//							mem_addr <= mem_addr + 1'b1;
//						end
//					end
				
				default: load_state <= 8'b11111111; // End
			endcase
			
			// Sets the corresponding memory register
			case (load_state)
				8'b00000000: player1_x <= player1_x; // Do nothing to buffer the data
				8'b00000001: player1_x <= player1_x; // Do nothing to buffer the data
				8'b00000010: player1_x <= mem_out[9:0] - 10'd16;
				8'b00000011: player1_y <= mem_out[9:0] - 10'd16;
				8'b00000100: player2_x <= mem_out[9:0] - 10'd16;
				8'b00000101: player2_y <= mem_out[9:0] - 10'd16;
				8'b00000110: player1_health <= mem_out[3:0];
				8'b00000111: player2_health <= mem_out[3:0];
				8'b00001000: player1_angle <= mem_out[1:0];
				8'b00001001: player2_angle <= mem_out[1:0];
				8'b00001010: proj1_angle <= mem_out[1:0];
				8'b00001011: proj2_angle <= mem_out[1:0];
				8'b00001100: proj1_x <= mem_out[9:0] - 10'd16;
				8'b00001101: proj1_y <= mem_out[9:0] - 10'd16;
				8'b00001110: proj2_x <= mem_out[9:0] - 10'd16;
				8'b00001111: proj2_y <= mem_out[9:0] - 10'd16;
				8'b00010000: explo1_frame <= mem_out[3:0];
				8'b00010001: explo1_x <= mem_out[9:0] - 10'd16;
				8'b00010010: explo1_y <= mem_out[9:0] - 10'd16;
				8'b00010011: explo2_frame <= mem_out[3:0];
				8'b00010100: explo2_x <= mem_out[9:0] - 10'd16;
				8'b00010101: explo2_y <= mem_out[9:0] - 10'd16;
				8'b00010110: player1_frame <= mem_out[3:0];
				8'b00010111: player2_frame <= mem_out[3:0];
				8'b00011000: proj1_frame <= mem_out[3:0];
				8'b00011001: proj2_frame <= mem_out[3:0];
				8'b00011010: game_state <= mem_out[1:0];
				8'b00011011: game_state <= game_state; //font_scale <= mem_out[1:0];
				8'b00011100: // Game mapping load state
					begin
						write_background <= 1'b1;
						background_id <= mem_out[3:0];
						
						// Don't increment it on the first iteration
						if (write_background == 1'b1)
							background_addr <= background_addr + 1'b1;
					end
//				8'b00011101: // Font mapping load state
//					begin
//						write_font <= 1'b1;
//						font_id <= mem_out[15:0];
//						
//						// Don't increment it on the first iteration
//						if (write_font == 1'b1)
//							font_addr <= font_addr + 1'b1;
//					end
					
				default: load_state <= 8'b11111111; // End
			endcase
		end
		else 
		begin
			//font_addr <= 13'b0;
			background_addr <= 9'b0;
			load_state <= 8'b0;
			background_id <= 4'b0;
			//font_id <= 16'b0;
			//write_font <= 1'b0;
			write_background <= 1'b0;
		end
	end
	
	
	// Draws Player1: HEALTH Player2: HEALTH onto the screen
	reg [4:0] font_state = 5'b0;
	
	always@(posedge clk)
	begin
		if (v_count >= 10'd514)
			font_state <= 5'b0;
	
		write_font <= 1'b1;
		font_addr <= font_addr + 2'b10;
		font_state <= font_state + 1'b1;
		font_scale <= 2'b01;

		if (font_state == 5'b11111 && v_count < 10'd514)
		begin
			font_state <= font_state;
			write_font <= 1'b0;
		end

		case (font_state)
			5'b00000: font_addr <= 13'd172;
			5'b00001: font_id <= {9'b111000000, 7'd80};
			5'b00010: font_id <= {9'b111000000, 7'd108};
			5'b00011: font_id <= {9'b111000000, 7'd97};
			5'b00100: font_id <= {9'b111000000, 7'd121};
			5'b00101: font_id <= {9'b111000000, 7'd101}; 
			5'b00110: font_id <= {9'b111000000, 7'd114};
			5'b00111: font_id <= {9'b111000000, 7'd49};
			5'b01000: font_id <= {9'b111000000, 7'd58};
			5'b01001: font_id <= 7'd00;
			5'b01010: font_id <= {9'b111000000, 7'd48 + player1_health};
			5'b01110: font_id <= {9'b000000111, 7'd80};
			5'b01111: font_id <= {9'b000000111, 7'd108};
			5'b10000: font_id <= {9'b000000111, 7'd97};
			5'b10001: font_id <= {9'b000000111, 7'd121};
			5'b10010: font_id <= {9'b000000111, 7'd101};
			5'b10011: font_id <= {9'b000000111, 7'd114};
			5'b10100: font_id <= {9'b000000111, 7'd50};
			5'b10101: font_id <= {9'b000000111, 7'd58};
			5'b10110: font_id <= 7'd00;
			5'b10111: font_id <= {9'b000000111, 7'd48 + player2_health};				
			default: font_id <= 7'd0;
		endcase
	end
	
endmodule
