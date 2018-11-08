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
module SNES_Controller(clk, data_in, active, latch, ready, data_out);

	// Global wires
	input wire clk, data_in, active;

	// state variable
	reg [1:0] state = 2'b00;
	reg [3:0] counter = 4'b0000;

	parameter waiting = 2'b00, latch_set = 2'b01, reading = 2'b10, done_reading = 2'b11;

	// output registers
	output reg latch, ready;
	output reg [15:0] data_out = 16'b0000000000000000;

	always@(posedge clk)
	begin
		case (state)
			waiting:
			begin
				if (active)
				begin
					state <= latch_set;
				end
			end
			latch_set:
			begin
				state <= reading;
			end
			reading:
			begin
				counter <= counter + 1;
				if (counter == 4'b1111)
				begin
					state <= done_reading;
				end
			end
			done_reading:
			begin
				counter <= 4'b0000;
				state <= waiting;
			end
			default:
			begin
				state <= waiting;
			end
		endcase
	end


	always@(state)
	begin
		case (state)
			waiting:
			begin
				ready = 1'b0;
				latch = 1'b0;
			end
			latch_set:
			begin
				ready = 1'b0;
				latch = 1'b1;
			end
			reading:
			begin
				latch =1'b0;
				ready = 1'b0;
				data_out[counter] = data_in;
			end
			done_reading:
			begin
				latch = 1'b0;
				ready = 1'b1;
			end
			default:
			begin
				latch = 1'b0;
				ready = 1'b0;
			end
		endcase
	end

endmodule
