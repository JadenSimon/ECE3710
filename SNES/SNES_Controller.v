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
	reg [5:0] SNES_state;
	parameter waiting = 5'b0000, latch = 5'b00001, d0 = 5'b00001, d1 = 5'b00001, d2 = 5'b00001,
		d3 = 5'b00001 d4 = 5'b00001 d5 = 5'b00001 d6 = 5'b00001 d7 = 5'b00001 d8 = 5'b00001,
		d9 = 5'b00001 d10 = 5'b00001 d11 = 5'b00001 d12 = 5'b00001 d13 = 5'b00001 d14 = 5'b00001,
		d15_ready = 5'b00001;
	
	// output registers
	output reg latch, ready;
	output reg [15:0] data_out;
	
	always@(posedge clk)
	begin		
		case (SNES_state)
			waiting:
				if (active)
				begin
					state <= state + 1;
				end
				ready <= 1'b0;
			latch:
				latch <= 1'b1;
			d0:
				data_out[0] <= data_in;
			d1:
				data_out[1] <= data_in;
			d2:
				data_out[2] <= data_in;
			d3:
				data_out[3] <= data_in;
			d4:
				data_out[4] <= data_in;
			d5:
				data_out[5] <= data_in;
			d6:
				data_out[6] <= data_in;
			d7:
				data_out[7] <= data_in;
			d8:
				data_out[8] <= data_in;
			d9:
				data_out[9] <= data_in;
			d10:
				data_out[10] <= data_in;
			d11:
				data_out[11] <= data_in;
			d12:
				data_out[12] <= data_in;
			d13:
				data_out[13] <= data_in;
			d14:
				data_out[14] <= data_in;
			d15_ready:
				data_out[15] <= data_in;
				ready <= 1'b1;
		endcase
	end
endmodule