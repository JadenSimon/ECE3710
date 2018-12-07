// Highest level module for the whole project
// Ties everything together

module TankGame(clk, reset, snes1_in, snes2_in, snes1_latch, snes2_latch, hSync, vSync, red, green, blue, vga_slow_clk, snes1_slow_clk, snes2_slow_clk, snes1_fake_data, snes2_fake_data, snes1_start);
	// Input wires
	input clk, reset;
	input snes1_in, snes2_in;

	// Output wires/registers
	output wire snes1_latch, snes2_latch;
	output wire hSync, vSync;
	output wire [4:0] red, green, blue;
	output reg vga_slow_clk;
	output reg snes1_slow_clk, snes2_slow_clk;
	
	// SNES wires
	wire [15:0] snes1_data, snes2_data; 
	
	input wire [4:0] snes1_fake_data; 
	input wire [4:0] snes2_fake_data; 
	input wire snes1_start;
	
	wire [15:0] snes1_padded_data;
	wire [15:0] snes2_padded_data;
	wire new_reset;
	
	assign snes1_padded_data = snes1_data | {3'b0, ~snes1_start, snes1_fake_data, 7'b0};  
	assign snes2_padded_data = snes2_data | {4'b0, snes2_fake_data, 7'b0};
	
	assign new_reset = ~reset;
	
	// VGA wires
	wire bright;
	wire [9:0] hCount, vCount;
	wire [15:0] vga_addr, vga_out;
	wire [15:0] pixel; 
	
	// Create the CPU
	cpu_datapath CPU(clk, new_reset, snes1_padded_data, snes2_padded_data, vga_addr, vga_out);

	// Create the SNES controller modules
	SNES_Controller controller1(snes1_slow_clk, snes1_in, snes1_latch, snes1_data);
	SNES_Controller controller2(snes2_slow_clk, snes2_in, snes2_latch, snes2_data);
	
	// Create the VGA modules 
	VGA_Display display(clk, vga_slow_clk, new_reset, hSync, vSync, hCount, vCount, bright);
	VGAController controller(clk, hCount, vCount, vga_addr, vga_out, pixel);
	
	// Assign VGA outputs based off bright/pixel.
	assign red = bright ? pixel[15:11] : 5'b0;
	assign green = bright ? pixel[10:6] : 5'b0;
	assign blue = bright ? pixel[5:1] : 5'b0;
	
	// Create a slower vga signal
	always@(posedge clk)
	begin
		if (new_reset)
			vga_slow_clk <= 1'b0;
		else
			vga_slow_clk <= ~vga_slow_clk;
	end
	
	// Create a slow 5 MHz clock for the SNES controllers
	reg [2:0] snes1_slow_clk_counter = 3'b0;
	reg [2:0] snes2_slow_clk_counter = 3'b0;

	
	always@(posedge clk) 
	begin
		snes1_slow_clk_counter <= snes1_slow_clk_counter + 1'b1; 
		snes2_slow_clk_counter <= snes2_slow_clk_counter + 1'b1;
		if (snes1_slow_clk_counter == 3'b100)
		begin
			snes1_slow_clk <= ~snes1_slow_clk;
			snes1_slow_clk_counter <= 3'b0;
		end
		if (snes2_slow_clk_counter == 3'b100)
		begin
			snes2_slow_clk <= ~snes2_slow_clk;
			snes2_slow_clk_counter <= 3'b0;
		end
	end
	
endmodule
