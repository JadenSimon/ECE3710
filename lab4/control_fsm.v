`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    10/17/2018
// Design Name:    control_fsm
// Module Name:    control_fsm
// Project Name:   Lab 4
//////////////////////////////////////////////////////////////////////////////////

// Control unit for the entire CPU datapath
module control_fsm(clk, reset, mem_data, ld_mux, pc_mux, mux_A, mux_B, Opcode, RegEnable, FlagsEnable, PCEnable, we_a, imm);
	`include "instructionset.v"
	input clk, reset;
	input [15:0] mem_data;
	
	output reg ld_mux;
	output reg pc_mux;
	output reg [7:0] Opcode;
	output reg [15:0] RegEnable;
	output reg [4:0] FlagsEnable;
	output reg PCEnable;
	output reg we_a;
	output reg [3:0] mux_A, mux_B;
	output reg [7:0] imm;
	
	// Allows us to keep track of the instruction across states
	reg [15:0] instr; 
	reg [15:0] last_instr;
	
	reg fsm_state;
	
	always@(posedge clk)
	begin
		if (reset == 1'b1)
		begin
			ld_mux = 1'b0;
			pc_mux = 1'b0;
			Opcode = 8'b0;
			RegEnable = 16'b0;
			FlagsEnable = 5'b0;
			PCEnable = 1'b1;
			we_a = 1'b0;
			mux_A = 4'b0;
			mux_B = 4'b0;
			fsm_state = 1'b0;
			imm = 8'b0;
			instr = 16'b0;
			last_instr = 16'b0;
		end
		else
		begin 
			case (fsm_state)
			1'b0:
			begin
				instr = (last_instr[15:12] == Special && (last_instr[7:4] == LOAD || last_instr[7:4] == STOR)) ? instr : mem_data;
			
				// Set the PC enables
				// If the instr is a load or store then set it to 0
				PCEnable = instr[15:12] != Special || (instr[7:4] != LOAD && instr[7:4] != STOR);
				
				// Set the write enable
				we_a = instr[15:12] == Special && instr[7:4] == STOR;
				
				// Set the pc/ld mux
				// If we are loading or storing we must set the correct address to the memory block
				pc_mux = instr[15:12] == Special && (instr[7:4] == LOAD || instr[7:4] == STOR);
				ld_mux = 0;
				
				// ALU DST/SRC Muxes
				mux_A = instr[11:8];
				mux_B = instr[3:0];
											
				// Decode the DST register for the RegFile. Special cases are CMP, CMPI
				if (instr[15:12] == Register || instr[15:12] == Shift)
					RegEnable = instr[7:4] == CMP ? 16'b0 : 1'b1 << instr[11:8]; // Check for CMP
				else if (instr[15:12] != Special && instr[15:12] != Bcond) // Handle immediates
					RegEnable = instr[15:12] == CMPI ? 16'b0 : 1'b1 << instr[11:8]; // Check for CMPI
				else 
					RegEnable = 16'b0; // Don't write to the regfile
				
				// Set the opcode and immediate
				Opcode = {instr[15:12], instr[7:4]};
				imm = instr[7:0];
		
				// Set the flags enable
				FlagsEnable = 5'b11111;
			
				fsm_state = ~PCEnable;
				
				last_instr = instr;
			end
			1'b1:
			begin
				// Set the PC enable, second stage always increments
				PCEnable = 1;
				
				// Set the write enable
				we_a = 0;
				
				// Set the pc/ld mux
				pc_mux = 0;
				ld_mux = instr[7:4] == LOAD;
				
				// ALU DST/SRC Muxes
				// For loads, it does not matter what the ALU sees
				mux_A = 4'b0;
				mux_B = 4'b0;
				
				RegEnable = instr[7:4] == LOAD ? 1'b1 << instr[11:8] : 16'b0;
				
				// Opcode does not matter here
				Opcode = 8'b0;
				imm = 8'b0;
		
				FlagsEnable = 5'b0;
	
				// Go back to the normal state
				fsm_state = 1'b0;
				instr = mem_data; // mem_data will be the next instruction necessary
			end
			endcase
		end
	end
endmodule
