// The background controller handles all background drawing. It internally stores
// the glyph sprite sheet as well as a glyph id mapping. The glyph mapping can be
// updated every clock cycle.

module BackgroundController(clk, x_in, y_in, write_glyph, addr, glyph_id, pixel);
	parameter INPUT_WIDTH = 10;
	parameter PIXEL_SIZE = 16;
	parameter GLYPH_SIZE = 32;
	parameter ID_SIZE = 4;
	parameter MAP_SIZE_X = 20;
	parameter MAP_SIZE_Y = 15;
	
	input clk, write_glyph;
	input [(INPUT_WIDTH-1):0] x_in, y_in;
	input [(ID_SIZE-1):0] glyph_id;
	input [8:0] addr;
	output reg [(PIXEL_SIZE-1):0] pixel;
	
	// Holds the glyph sprite sheet
	reg [(PIXEL_SIZE-1):0] glyph_buffer [(ID_SIZE * ID_SIZE * GLYPH_SIZE * GLYPH_SIZE - 1):0];
	
	// Holds the glyph id mapping
	reg [(ID_SIZE-1):0] glyph_mapping [(MAP_SIZE_X * MAP_SIZE_Y - 1):0];

	// Load the two ROM files into memory
	initial begin
		$readmemh("background.data", glyph_buffer);
		$readmemh("map.data", glyph_mapping);
	end
	
	// Simply writing logic
	always@(posedge clk)
	begin
		if (write_glyph)
			glyph_mapping[addr] <= glyph_id;
	end
	
	// Lower 5 bits of x/y determine the corresponding x/y pixel position in a glyph
	// Upper 5 bits of x/y determine the location of the glyph id in the mapping
	// Some wires to help with computing x/y offsets
	wire [6:0] x_offset, y_offset;
	assign x_offset = glyph_mapping[y_in[9:5] * MAP_SIZE_X + x_in[9:5]][1:0] * GLYPH_SIZE;
	assign y_offset = glyph_mapping[y_in[9:5] * MAP_SIZE_X + x_in[9:5]][3:2] * GLYPH_SIZE;
	
	// Given an x/y position, the correct pixel value will be found based off the glyph_mapping
	always@(posedge clk) 
	begin
		pixel <= glyph_buffer[((y_in[4:0] + y_offset) * GLYPH_SIZE * ID_SIZE) + (x_in[4:0] + x_offset)];
	end

endmodule
