// Sprite Module
// 1 bit of the pixel is reserved for transparency (either opaque or transparent)
// x and y position define the upper left corner of the sprite
module HardwareSprite(clk, x_in, y_in, x_pos, y_pos, d_en, pixel);
	parameter INPUT_WIDTH = 10;
	parameter PIXEL_SIZE = 16;
	parameter SPRITE_SIZE = 32;
	parameter FILE_NAME = "test.data";
	
	input clk;
	input [(INPUT_WIDTH-1):0] x_in, y_in, x_pos, y_pos;
	output reg [(PIXEL_SIZE-1):0] pixel;
	output reg d_en; // d_en is whether or not this sprite's pixel is visible
	
	// Holds all pixels for the sprite
	reg [(PIXEL_SIZE-1):0] sprite_buffer [(SPRITE_SIZE * SPRITE_SIZE - 1):0];
	
	// Load a ROM file into memory
	initial begin
		$readmemh(FILE_NAME, sprite_buffer);
	end
	
	// Hardware sprite logic is triggered on positive clock edge
	always@(posedge clk) 
	begin
		// Only draw if in range
		if (x_in >= x_pos && y_in >= y_pos && x_in < x_pos + SPRITE_SIZE && y_in < y_pos + SPRITE_SIZE)
		begin
			d_en <= 1;
			pixel <= sprite_buffer[((y_in - y_pos) * SPRITE_SIZE) + (x_in - x_pos)];
		end
		else
		begin
			d_en <= 0;
			pixel <= 0;
		end
	end
	
endmodule
