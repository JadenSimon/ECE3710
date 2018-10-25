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
// Logic is implemented as a Mealy machine since output is dependent on the previous instruction.
module control_fsm(clk, reset, mem_data, flags, ld_mux, pc_mux, jal_mux, pc_load, mux_A, mux_B, Opcode, RegEnable, FlagsEnable, PCEnable, we_a, imm);
	`include "instructionset.v"
	input clk, reset;
	input [15:0] mem_data;
	input [4:0] flags;
	
	output reg ld_mux = 1'b0;
	output reg pc_mux = 1'b0;
	output reg jal_mux = 1'b0;
	output reg pc_load = 1'b0;
	output reg [7:0] Opcode = 8'b0;
	output reg [15:0] RegEnable = 16'b0;
	output reg [4:0] FlagsEnable = 5'b0;
	output reg PCEnable = 1'b1;
	output reg we_a = 1'b0;
	output reg [3:0] mux_A = 4'b0;
	output reg [3:0] mux_B = 4'b0;
	output reg [7:0] imm = 8'b0;
	
	// Allows us to keep track of the instruction across states
	reg [15:0] instr = 16'b0; 
	
	reg fsm_state = 1'b0;
	
	/*
	The control logic works as follows:
		State 0:
			Instruction to decode is equal to memory_data if the last instruction was not LOAD or STOR
			Otherwise, the instruction to decode is unchanged (it equals its last value)
			Set PCEnable to 1 if not a special instruction
			Set control lines based on instruction
			If the instruction was LOAD/STOR go to State 1
		State 1:
			Always set PCEnable to 1
			If instruction is LOAD set RegEnable and ld_mux
			Set all other control lines to 0
			Set instruction to mem_data
			Go to State 0.		
	The FSM is updated whenever mem_data is changed.		
	*/
	always@(mem_data)
	begin
		if (reset == 1'b1)
		begin
			ld_mux = 1'b0;
			pc_mux = 1'b0;
			jal_mux = 1'b0;
			pc_load = 1'b0;
			Opcode = 8'b0;
			RegEnable = 16'b0;
			FlagsEnable = 5'b0;
			PCEnable = 1'b1;
			we_a = 1'b0;
			mux_A = 4'b0;
			mux_B = 4'b0;
			fsm_state = 2'b00;
			imm = 8'b0;
			instr = 16'b0;
		end
		else
		begin 
			case (fsm_state)
			1'b0:
			begin
				instr = mem_data;
			
				// Set the PC enable, if it's a load/store don't set it
				PCEnable = !(instr[15:12] == Special && (instr[7:4] == LOAD || instr[7:4] == STOR));
				
				// Set the write enable
				we_a = instr[15:12] == Special && instr[7:4] == STOR;			
			
				// Set the pc/ld mux
				// If we are loading or storing we must set the correct address to the memory block
				pc_mux = instr[15:12] == Special && (instr[7:4] == LOAD || instr[7:4] == STOR);
				ld_mux = 0;
				jal_mux = instr[15:12] == Special && instr[7:4] == JAL;
				pc_load = instr[15:12] == Special && (instr[7:4] == JAL || instr[7:4] == JCND);

				// ALU DST/SRC Muxes
				mux_A = instr[11:8];
				mux_B = instr[3:0];	
																			
				// Decode the DST register for the RegFile. Special cases are CMP, CMPI, JAL
				if (instr[15:12] == Register || instr[15:12] == Shift)
					RegEnable = instr[7:4] == CMP ? 16'b0 : 1'b1 << instr[11:8]; // Check for CMP
				else if (instr[15:12] != Special && instr[15:12] != BCND) // Handle immediates
					RegEnable = instr[15:12] == CMPI ? 16'b0 : 1'b1 << instr[11:8]; // Check for CMPI
				else if (instr[15:12] == Special && instr[7:4] == JAL)
					RegEnable = 1'b1 << instr[11:8];
				else 
					RegEnable = 16'b0; // Don't write to the regfile
				
				// Set the opcode and immediate
				Opcode = {instr[15:12], instr[7:4]};
				imm = instr[7:0];
		
				// Set the flags enable
				FlagsEnable = 5'b11111;
											
				fsm_state = ~PCEnable;
			end
			1'b1:
			begin
				// Set the PC enable, second stage always increments
				PCEnable = 1'b1;
				
				// Set the write enable
				we_a = 0;
				
				// Set the pc/ld mux
				pc_mux = 0;
				ld_mux = (instr[15:12] == Special && instr[7:4] == LOAD);
				jal_mux = 0;
				pc_load = 0;
				
				// ALU DST/SRC Muxes
				// For loads, it does not matter what the ALU sees
				mux_A = 4'b0;
				mux_B = 4'b0;
				
				RegEnable = (instr[15:12] == Special && instr[7:4] == LOAD) ? 1'b1 << instr[11:8] : 16'b0;
				
				// Opcode does not matter here
				Opcode = 8'b0;
				imm = 8'b0;
		
				FlagsEnable = 5'b0;
	
				// Go back to normal state
				fsm_state = 1'b0;
			end
			endcase
		end
	end
endmodule
