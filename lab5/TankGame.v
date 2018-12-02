// Highest level module for the whole project
// Ties everything together

module TankGame(clk, reset, snes1_in, snes2_in, snes1_latch, snes2_latch, hSync, vSync, red, green, blue, vga_slow_clk, snes_slow_clk);
	// Input wires
	input clk, reset;
	input snes1_in, snes2_in;

	// Output wires/registers
	output wire snes1_latch, snes2_latch;
	output wire hSync, vSync;
	output wire [4:0] red, green, blue;
	output reg vga_slow_clk;
	output reg snes_slow_clk;
	
	// SNES wires
	wire [15:0] snes1_data, snes2_data;
	
	// VGA wires
	wire bright;
	wire [9:0] hCount, vCount;
	wire [15:0] vga_addr, vga_out;
	wire [15:0] pixel;
	
	// Create the CPU
	cpu_datapath CPU(clk, reset, snes1_data, snes2_data, vga_addr, vga_out);

	// Create the SNES controller modules
	SNES_Controller controller1(snes_slow_clk, snes1_in, snes1_latch, snes1_data);
	SNES_Controller controller2(snes_slow_clk, snes2_in, snes2_latch, snes2_data);
	
	// Create the VGA modules 
	VGA_Display display(vga_slow_clk, reset, hSync, vSync, hCount, vCount, bright);
	VGAController controller(clk, hCount, vCount, vga_addr, vga_out, pixel);
	
	// Assign VGA outputs based off bright/pixel.
	assign red = bright ? pixel[15:11] : 5'b0;
	assign green = bright ? pixel[10:6] : 5'b0;
	assign blue = bright ? pixel[5:1] : 5'b0;
	
	always@(posedge clk)
	begin
		vga_slow_clk <= ~vga_slow_clk;
	end
	
	// Create a slow 5 MHz clock for the SNES controllers
	reg [2:0] snes_slow_clk_counter = 3'b0;
	
	always@(posedge clk)
	begin
		snes_slow_clk_counter <= snes_slow_clk_counter + 1'b1;
		if (snes_slow_clk_counter == 3'b100)
		begin
			snes_slow_clk <= !snes_slow_clk;
			snes_slow_clk_counter <= 3'b0;
		end
	end
	
	
endmodule
