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

	wire [15:0] data_out;

	output wire [15:0] led_out;
	output wire latch;
	output reg slow_clk;
	
	SNES_Controller(slow_clk, data_in, latch, data_out);
	
	reg [2:0] slow_clk_counter = 3'b0;
	
	always@(posedge clk)
	begin
		slow_clk_counter <= slow_clk_counter + 1'b1;
	
		if (slow_clk_counter == 3'd4)
		begin
			slow_clk_counter <= 3'd0;
			slow_clk <= ~slow_clk;
		end
	end
	
	assign led_out = data_out;
	
endmodule
