`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    08/30/2018 
// Design Name:    tb_SNES
// Module Name:    tb_SNES
// Project Name:   SNES
//////////////////////////////////////////////////////////////////////////////////


// This testbench succeeds when no errors are displayed.
module tb_SNES;

	// Inputs
	reg clk = 1'b0;
	wire data_in;
	
	// Outputs
	wire [15:0] data_out;
	wire slow_clk;
	
	// Test input
	reg [15:0] shift_reg = 16'b0;
	reg [15:0] snes_input = 16'b0;
	
	// Create the controller module
	SNES_Controller test1(
		.clk(clk), 
		.data_in(data_in), 
		.latch(latch), 
		.data_out(data_out),
		.slow_clk(slow_clk)
	);
	
	// Data into the controller module is the last bit of the shift register
	assign data_in = shift_reg[15];
	
	// Every clock cycle shift the shift_reg
	// If latch is high then dump snes_input into shift_reg
	always@(posedge slow_clk)
	begin
		if (latch)
			shift_reg <= snes_input;
		else
			shift_reg <= shift_reg << 1;
	end
	
	task simulate_SNES_input(input [15:0] button_vector);
	begin
		// Set the snes_input register
		snes_input = button_vector;
		
		// Wait 18 slow cycles to guarantee it shows at the output
		#3600
		
		// Check to verify the output matches the input
		if (data_out != button_vector)
			$display("button_vector: %b, data_out incorrect: %b", button_vector, data_out);
	end
	endtask
	
	initial begin
		#200
	
		// alternating		
		simulate_SNES_input(16'b1010101010101010);
	
		// first and last 
		simulate_SNES_input(16'b1000000000000001); 
		
		// alternating	2	
		simulate_SNES_input(16'b0101010101010101);
		
		// blocks of 4
		simulate_SNES_input(16'b1111000011110000);
		
		// blocks of 4 (2)
		simulate_SNES_input(16'b0000111100001111);
		
		// all 1s
		simulate_SNES_input(16'b1111111111111111);
		
		// all 0s
		simulate_SNES_input(16'b0000000000000000);
		
		// one 1
		simulate_SNES_input(16'b1000000000000000);
		
		// one 0
		simulate_SNES_input(16'b1111111011111111);

		$finish(2);
	end
	
	// Creates a 50 MHz clock
	always begin
		#10
		clk = ~clk;
	end
	
endmodule
