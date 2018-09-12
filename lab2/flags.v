`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    9/12/2018 
// Design Name:    
// Module Name:    flags
// Project Name:   Lab 2
module flags(clk, reset, flags_in, flags_out);
	input clk, reset;
	input [4:0] flags_in;
	output reg [4:0] flags_out; 

	always@(posedge clk)
	begin
		if (reset == 1'b1)
			flags_out <= 5'b0;
		else
			flags_out <= flags_in;	
	end
endmodule
