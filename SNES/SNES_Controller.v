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
	reg [5:0] state;
	parameter waiting = 5'b00000, latch = 5'b00001, d0 = 5'b00010, d1 = 5'b00011, d2 = 5'b00100,
		d3 = 5'b00101 d4 = 5'b00110 d5 = 5'b00111 d6 = 5'b01000 d7 = 5'b01001 d8 = 5'b01010,
		d9 = 5'b01011 d10 = 5'b01100 d11 = 5'b01101 d12 = 5'b01110 d13 = 5'b01111 d14 = 5'b10000,
		d15_ready = 5'b10001;

	// output registers
	output reg latch, ready;
	output reg [15:0] data_out;

	always@(posedge clk)
	begin
		// latch <= 1'b0;
		// ready <= 1'b0;
		case (state)
			waiting:
				if (active)
				begin
					state <= state + 1;
				end
				ready <= 1'b0;
			latch:
				latch <= 1'b1;
				state <= state + 1;
			d0:
				latch <= 1'b0;
				data_out[0] <= data_in;
				state <= state + 1;
			d1:
				data_out[1] <= data_in;
				state <= state + 1;
			d2:
				data_out[2] <= data_in;
				state <= state + 1;
			d3:
				data_out[3] <= data_in;
				state <= state + 1;
			d4:
				data_out[4] <= data_in;
				state <= state + 1;
			d5:
				data_out[5] <= data_in;
				state <= state + 1;
			d6:
				data_out[6] <= data_in;
				state <= state + 1;
			d7:
				data_out[7] <= data_in;
				state <= state + 1;
			d8:
				data_out[8] <= data_in;
				state <= state + 1;
			d9:
				data_out[9] <= data_in;
				state <= state + 1;
			d10:
				data_out[10] <= data_in;
				state <= state + 1;
			d11:
				data_out[11] <= data_in;
				state <= state + 1;
			d12:
				data_out[12] <= data_in;
				state <= state + 1;
			d13:
				data_out[13] <= data_in;
				state <= state + 1;
			d14:
				data_out[14] <= data_in;
				state <= state + 1;
			d15_ready:
				data_out[15] <= data_in;
				ready <= 1'b1;
				state <= waiting;
			default:
				state <= waiting;
		endcase
	end
endmodule
