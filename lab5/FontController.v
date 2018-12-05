// The font controller handles all font drawing to the screen.
// Font drawing takes priority over every other pixel module.
// Font glyphs are 8x8, thus there are 80 columns and 60 rows for characters.
// The current font file contains 128 slots, characters are 33-126, all others are blanks.
// Effectively is a duplicate of the background controller.
// Leftover 9 bits of the total font footprint is used for color (3-bit per channel)

module FontController(clk, x_in, y_in, write_glyph, addr, glyph_id, scale, pixel);
	parameter INPUT_WIDTH = 10;
	parameter PIXEL_SIZE = 16;
	parameter GLYPH_SIZE = 8;
	parameter ID_SIZE = 7;
	parameter MAP_SIZE_X = 80;
	parameter MAP_SIZE_Y = 60;
	
	input clk, write_glyph;
	input [(INPUT_WIDTH-1):0] x_in, y_in;
	input [15:0] glyph_id;
	input [12:0] addr;
	input [1:0] scale;
	output reg [(PIXEL_SIZE-1):0] pixel;
	
	// Holds the glyph sprite sheet
	reg [(PIXEL_SIZE-1):0] glyph_buffer [((1 << ID_SIZE) * GLYPH_SIZE * GLYPH_SIZE - 1):0];
	
	// Holds the glyph id mapping
	reg [15:0] glyph_mapping [(MAP_SIZE_X * MAP_SIZE_Y - 1):0];

	// Load the glyph file.
	initial begin
		$readmemh("font.data", glyph_buffer);
	end
	
	// Simply writing logic 
   reg [15:0] write_out;
	always@(posedge clk)
	begin
		if (write_glyph)
		begin
			glyph_mapping[addr] <= glyph_id;
			write_out <= glyph_id;
		end
		else
			write_out <= glyph_mapping[addr];
	end
	
	// For normal scale:
	// Lower 3 bits of x/y determine the corresponding x/y pixel position in a glyph
	// Upper 7 bits of x/y determine the location of the glyph id in the mapping
	
	// For 2x, 4x, and 8x scale we just reduce the bits used for the glyph map and increase the bits used for pixels in the glyph.
	
	// Temp glyph mapping is used to find the correct glyph to used for the current x/y location.
	reg [15:0] temp_glyph_mapping;
	
	// Given an x/y position, the correct pixel value will be found based off the glyph_mapping
	// A pixel value is found within a 2D 128x64 array. All the math is used to compute offsets within the array.
	always@(posedge clk) 
	begin		
		if (scale == 2'b00)
		begin
			temp_glyph_mapping <= glyph_mapping[y_in[9:3] * MAP_SIZE_X + x_in[9:3]];
			pixel <= {temp_glyph_mapping[15:13], 2'b00, temp_glyph_mapping[12:10], 2'b00, temp_glyph_mapping[9:7], 3'b000}
						+ glyph_buffer[((y_in[2:0] + temp_glyph_mapping[6:4] * GLYPH_SIZE) * GLYPH_SIZE * 16) + (x_in[2:0] + temp_glyph_mapping[3:0] * GLYPH_SIZE)];
		end
		else if (scale == 2'b01)
		begin
			temp_glyph_mapping <= glyph_mapping[{y_in[9:4], 1'b0} * MAP_SIZE_X + {x_in[9:4], 1'b0}];
			pixel <= {temp_glyph_mapping[15:13], 2'b00, temp_glyph_mapping[12:10], 2'b00, temp_glyph_mapping[9:7], 3'b000}
						+ glyph_buffer[((y_in[3:1] + temp_glyph_mapping[6:4] * GLYPH_SIZE) * GLYPH_SIZE * 16) + (x_in[3:1] + temp_glyph_mapping[3:0] * GLYPH_SIZE)];
		end	
		else if (scale == 2'b10)
		begin
			temp_glyph_mapping <= glyph_mapping[{y_in[9:5], 2'b0} * MAP_SIZE_X + {x_in[9:5], 2'b0}];
			pixel <= {temp_glyph_mapping[15:13], 2'b00, temp_glyph_mapping[12:10], 2'b00, temp_glyph_mapping[9:7], 3'b000}
						+ glyph_buffer[((y_in[4:2] + temp_glyph_mapping[6:4] * GLYPH_SIZE) * GLYPH_SIZE * 16) + (x_in[4:2] + temp_glyph_mapping[3:0] * GLYPH_SIZE)];
		end	
		else 
		begin
			temp_glyph_mapping <= glyph_mapping[{y_in[9:6], 3'b0} * MAP_SIZE_X + {x_in[9:6], 3'b0}];
			pixel <= {temp_glyph_mapping[15:13], 2'b00, temp_glyph_mapping[12:10], 2'b00, temp_glyph_mapping[9:7], 3'b000}
						+ glyph_buffer[((y_in[5:3] + temp_glyph_mapping[6:4] * GLYPH_SIZE) * GLYPH_SIZE * 16) + (x_in[5:3] + temp_glyph_mapping[3:0] * GLYPH_SIZE)];
		end				
	end

endmodule
