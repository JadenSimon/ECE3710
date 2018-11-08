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
	
	task simulate_SNES_input();
	begin
		
		// set active high and wait a cycle
		active = 1; #10; clk = 1; #10; clk = 0; active = 0;
		
		// wait 1 cycle so latch can be set
		clk = 1; clk = 0;
		$display("SNES begin:");
	
		for (i = 0; i < 16; i = i + 1)
		begin
		
			// alternate between ones and zeroes
			data_in = i[0];
			#10; clk = 1; #10; clk = 0;

		end		
	end
	endtask
	
	initial begin
	
		//init inputs
		clk = 0; 
		active = 0;
		data_in = 0;
	
		
		simulate_SNES_input();
		$display("data_out: %b", data_out);
		
	$finish(2);
	end
endmodule