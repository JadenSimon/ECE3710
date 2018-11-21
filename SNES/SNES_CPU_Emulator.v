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

// Instantiates SNES modules and map input to 10 on-board leds
module SNES_CPU_Emulator(clk, data_in, latch, led_out, slow_clk);

	input wire clk, data_in;
	
	wire ready;
	wire active;
	wire [15:0] data_out;

	output reg [15:0] led_out = 16'd0;
	output wire latch, slow_clk;

	// controller is always active
	assign active = 1'b1;
	
	SNES_Controller(clk, data_in, active, latch, ready, data_out, slow_clk);
	
	
	// if ready signal is high, capture data.
	always@(posedge clk)
	begin
		if (ready)
			led_out <= data_out;
		else
			led_out <= led_out;
	end

endmodule