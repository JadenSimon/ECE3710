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
// Modified to use an additional register to act as a buffer for user input.
// In this way we can be sure that the output of the module is always valid.
// Input clock should be a slow clock
module SNES_Controller(clk, data_in, latch, data_out);

	// Global wires
	input wire clk, data_in;

	// state variable
	reg [1:0] state = 2'b00;
	
	// data counter and slow clock counter
	reg [3:0] counter = 4'b0000;
	reg [15:0] temp_data = 16'b0;

	// 4 states
	parameter start = 2'b00, latch_set = 2'b01, reading = 2'b10, done_reading = 2'b11;

	// output registers
	output reg latch;
	output reg [15:0] data_out = 16'b0;
	
	// capture serial data on serial line on negedge clk
	always@(negedge clk)
	begin
		temp_data <= (temp_data << 1'b1) | data_in;
	end
		
	// state logic
	always@(posedge clk)
	begin
		case (state)
			start:
			begin
				state <= latch_set;
				latch <= 1'b0;
				data_out <= 16'b0;
			end
			latch_set:
			begin
				state <= reading;
				latch <= 1'b1;
			end
			reading:
			begin
				// bring latch back down
				latch = 1'b0;
			
			   // count to 15 go to next state
				counter <= counter + 1'b1;
				
				if (counter == 4'b1111)
				begin
					state <= done_reading;
				end
			end
			done_reading:
			begin
				// reset counter
				counter <= 4'b0000;
				latch <= 1'b0;
				state <= latch_set;
				
				// set the data_out to our temp data
				data_out <= temp_data;
			end
			default:
			begin
				counter <= 4'b0000;
				latch <= 1'b0;
				state <= start;
			end
		endcase
	end
	
endmodule
