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
	reg clk, active, data_in;
	
	// Outputs
	wire [15:0] data_out;
	wire ready;
	
	// counter variable
	integer i, failed;
	
	
	// Instantiate the DE1 Soc(de1soc)
	SNES_Controller test1(
		.clk(clk), 
		.data_in(data_in), 
		.active(active),
		.latch(latch), 
		.ready(ready), 
		.data_out(data_out)
	);
	
	task simulate_SNES_input(input [15:0] button_vector);
	begin
		
		// set active high and wait a cycle
		active = 1; cycle_fast_clk_by(10); active = 0; 
		
		// wait 1 cycle so latch can be set
		cycle_fast_clk_by(10);
		for (i = 15; i >= 0; i = i - 1)
		begin
			data_in = button_vector[i];
		   cycle_fast_clk_by(10);

		end	
		
		if (data_out != button_vector)
		begin
		failed = 1;
		$display("button_vector: %b, data_out incorrect: %b", button_vector, data_out);
		end		
	end
	endtask
	
	// provides a way to cycle the clock 10 times which is 1 (5Mhz) cycle
	task cycle_fast_clk_by(input integer cycles);
	begin
		for (i = 0; i < cycles; i = i + 1)
		begin
			clk = 1; #10; clk = 0; #10; 
		end	
	end
	endtask
	
	
	initial begin
	
		//init inputs
		clk = 0; active = 0; data_in = 0; failed = 0; 
	
		// alternating		
		simulate_SNES_input(16'b1010101010101010);
	
//		// first and last 
//		simulate_SNES_input(16'b1000000000000001); 
//	
//		
//		// alternating	2	
////		#10; clk = 1; #10; clk = 0; #10;
//		simulate_SNES_input(16'b0101010101010101);
//		
//		// blocks of 4
////		#10; clk = 1; #10; clk = 0; #10;
//		simulate_SNES_input(16'b1111000011110000);
//		
//		// blocks of 4 (2)
////		#10; clk = 1; #10; clk = 0; #10;
//		simulate_SNES_input(16'b0000111100001111);
//		
//		// all 1s
////		#10; clk = 1; #10; clk = 0; #10;
//		simulate_SNES_input(16'b1111111111111111);
//		
//		// all 0s
////		#10; clk = 1; #10; clk = 0; #10;
//		simulate_SNES_input(16'b0000000000000000);
		
		if (!failed)
		begin
		$display("%s", "All tests passed.");
		end
		
	$finish(2);
	end
endmodule