`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    10/17/2018
// Design Name:    program_counter
// Module Name:    program_counter
// Project Name:   Lab 4
//////////////////////////////////////////////////////////////////////////////////

// Stores next instruction address
module program_counter(clk, reset, PCEnable, PCIn, PCOut);
	input clk, reset, PCEnable;
	input [15:0] PCIn;
	
	reg [15:0] counter = 16'b0;
	
	output [15:0] PCOut;

	always@(posedge clk)
	begin
		if (reset == 1'b1)
			counter <= 16'b0;
		else if (PCEnable == 1'b1)
			counter <= PCIn;
		else
			counter <= counter;
	end
	
	
	assign PCOut = counter;
	
endmodule
