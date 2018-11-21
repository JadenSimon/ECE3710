`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
//
// Create Date:    11/06/2018
// Design Name:    SNES_Controller
// Module Name:    SNES_Controller
// Project Name:   SNES
//////////////////////////////////////////////////////////////////////////////////

// Instantiates all modules and creates muxes
module SNES_CPU_Emulator(clk, data_in, latch, data_out, slow_clk);

	input wire clk, data_in;
	wire ready;

	wire active;
	output reg [15:0] data_out = 16'd0;

//	wire [15:0] module_data_out;
	output wire latch, slow_clk;
   wire [15:0] led_out;

	assign active = 1'b1;
//	assign data_out = {15'b0, data_in};
	
	SNES_Controller(clk, data_in, active, latch, ready, led_out, slow_clk);
	
	always@(posedge clk)
	begin
		if (ready)
			data_out <= led_out;
		else
			data_out <= data_out;
	end


		
endmodule