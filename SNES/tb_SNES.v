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
	integer i;
	
	
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
		active = 1; #10; clk = 1; #10; clk = 0; active = 0; #10; 
		
		// wait 1 cycle so latch can be set
		clk = 1; #10; clk = 0; #10;
		$display("button_vector: %b", button_vector);
	
		for (i = 15; i >= 0; i = i - 1)
		begin
			data_in = button_vector[i];
			clk = 1; #10; clk = 0; #10; 

		end		
		clk = 1; #10; clk = 0; 
	end
	endtask
	
	initial begin
	
		//init inputs
		clk = 0; active = 0; data_in = 0; 
	
		// alternating
		simulate_SNES_input(16'b1010101010101010);
		$display("data_out: %b", data_out);
		
		// first and last 
		#10; clk = 1; #10; clk = 0; #10;
		simulate_SNES_input(16'b1000000000000001); 
		$display("data_out: %b", data_out);
		
		// blocks of 4
		#10; clk = 1; #10; clk = 0; #10;
		simulate_SNES_input(16'b1111000011110000);
		$display("data_out: %b", data_out);
		
	$finish(2);
	end
endmodule