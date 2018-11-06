`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    10/17/2018
// Design Name:    simple_test
// Module Name:    simple_test
// Project Name:   Lab 4
//////////////////////////////////////////////////////////////////////////////////

// Tests the CPU datapath
// Uses the memory loaded into program.txt
module simple_test();

	// Create clock and reset
	reg clock, reset;
	wire [15:0] d_out;
	
	// Create the CPU
	cpu_datapath CPU(clock, reset, d_out);	
		
	// Do some stuff
	initial begin
		clock = 0;
		reset = 1;
		#40
		reset = 0;
			
		#20000
		
		reset = 1;
		#40
		reset = 0;
		
		#20000
		
		$finish;
	end
	
	initial begin
		forever #20 clock = ~clock;
	end
	
endmodule
