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
module control_fsm(clk, reset, instr, flags, ld_mux, pc_mux, jal_mux, pc_load, branch_mux, mux_A, mux_B, Opcode, RegEnable, FlagsEnable, PCEnable, we_a, imm);
	`include "instructionset.v"
	input clk, reset;
	input [15:0] instr;
	input [4:0] flags;
	
	output reg ld_mux = 1'b0;
	output reg pc_mux = 1'b0;
	output reg jal_mux = 1'b0;
	output reg pc_load = 1'b0;
	output reg branch_mux = 1'b0;
	output reg [7:0] Opcode = 8'b0;
	output reg [15:0] RegEnable = 16'b0;
	output reg [4:0] FlagsEnable = 5'b0;
	output reg PCEnable = 1'b1;
	output reg we_a = 1'b0;
	output reg [3:0] mux_A = 4'b0;
	output reg [3:0] mux_B = 4'b0;
	output reg [7:0] imm = 8'b0;
	
	// Allows us to keep track of the instruction across states
	reg [15:0] last_instr = 16'b0; 
	reg [2:0] fsm_state = 3'b000;
	
	// Decodes condition and sets our condition flag
	function check_condition;
	input [3:0] opcode;
	begin
		case (opcode)
			NC: check_condition = 1'b1;
			EQ: check_condition = flags[4];
			NE: check_condition = !flags[4];
			CS: check_condition = flags[3];
			CC: check_condition = !flags[3];
			HI: check_condition = !flags[1];
			LS: check_condition = flags[1] || flags[4];
			GT: check_condition = !flags[0];
			LE: check_condition = flags[0] || flags[4];
			FS: check_condition = flags[2];
			FC: check_condition = !flags[2];
			LO: check_condition = flags[1];
			HS: check_condition = !flags[1];
			LT: check_condition = flags[0];
			GE: check_condition = !flags[0];
			NJ: check_condition = 1'b0;
			default: check_condition = 1'b0;
		endcase
	end
	endfunction
	
	always@(posedge clk)
	begin
		if (reset)
		begin
			fsm_state <= 3'b111;
			last_instr <= 16'b0;
		end
		else
		begin
			last_instr <= instr; // Only used for loads currently
		
			case (fsm_state)
			
				3'b000 :
				begin					
					if (instr[15:12] == Special && instr[7:4] == LOAD)
						fsm_state <= 3'b001; // LOAD can only move data into the register on the next cycle
					else if (instr[15:12] == Special && instr[7:4] == STOR)
						fsm_state <= 3'b010; // STOR must wait a cycle for the next instruction
					else
						fsm_state <= 3'b000;
				end
				
				// If coming out of reset, wait a cycle to increment PC
				3'b111 : fsm_state <= 3'b010;
				
				default: fsm_state <= 3'b000;
			endcase
		end
	end
	
	/*
	The control logic works as follows:
		State 0: (Fetch/Execute)
			Instruction to decode is equal to memory_data 
			Otherwise, the instruction to decode is unchanged (it equals its last value)
			Set PCEnable to 1 if not a special instruction
			Set control lines based on instruction
		State 1: (Load state)
			Always set PCEnable to 1
			Set RegEnable and ld_mux
			Set all other control lines to 0
		State 2: (Wait state)
			Set PCEnable to 1
			Everything else to 0
		State 7: (Reset state)
			Just waits a clock cycle without incrementing PC
			
	The FSM is updated whenever fsm_state or mem_data is changed	
	*/
	
	// Control signals (1 or 0)
	/*
		ld_mux : regfile write from alu output or memory output
		pc_mux : bram address from alu output or pc
		jal_mux : regfile write from pc or load mux
		pc_load : pc write from alu output or pc + pcadder
		branch_mux : pcadder uses either immediate or 1
	*/
	
	
	// Conditional branch/jumps decoding and logic
	/*
		NC No Condition always branch/jump
	   EQ Equal Z flag  is  1
		NE Not  Equal Z flag  is  0
		CS Carry  Set C flag  is  1
		CC Carry  Clear C flag  is  0
		HI Higher L flag  is  0
		LS Lower  or  Same L flag  is  1
		GT Greater  Than N flag  is  0
		LE Less  Than  or  Equal N flag  is  1
		FS Flag  Set F flag  is  1
		FC Flag  Clear F flag  is  0
		LO Lower Z  and  L flags  are  1
		HS Higher  or  Same Z  or  L flag  is  0
		LT Less  Than Z  and  N flags  are  1
		GE Greater  Than  or  Equal Z  or  N flag  is  0
		NJ No jump
	*/
	
	always@(*)
	begin		
		case (fsm_state)
		3'b000:
		begin					
			// Set the PC enable, if it's a load/store don't set it
			PCEnable = !(instr[15:12] == Special && (instr[7:4] == LOAD || instr[7:4] == STOR));
			
			// Set the write enable
			we_a = instr[15:12] == Special && instr[7:4] == STOR;			
		
			// Set our mux signal lines
			// If we are loading or storing we must set the correct address to the memory block
			// This only applies if its a special instruction.
			if (instr[15:12] == Special)
			begin
				pc_mux = instr[7:4] == JAL || instr[7:4] == LOAD || instr[7:4] == STOR || 
						(instr[7:4] == JCND && check_condition(instr[11:8]));
				ld_mux = 0;
				jal_mux = instr[7:4] == JAL;
				pc_load = instr[7:4] == JAL || (check_condition(instr[11:8]) && instr[7:4] == JCND);
			end
			else
			begin
				pc_mux = check_condition(instr[11:8]) && instr[15:12] == BCND;
				ld_mux = 0;
				jal_mux = 0;
				pc_load = 0;
			end
			
			// Set the branch mux control line
			branch_mux = check_condition(instr[11:8]) && instr[15:12] == BCND; 

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
		end
		3'b001:
		begin
			// Set the PC enable
			PCEnable = 1'b1;
			
			// Set the write enable
			we_a = 0;
			
			// Set the pc/ld mux
			pc_mux = 0;
			ld_mux = 1;
			jal_mux = 0;
			pc_load = 0;
			branch_mux = 0;
			
			// ALU DST/SRC Muxes
			// For loads, it does not matter what the ALU sees
			mux_A = 4'b0;
			mux_B = 4'b0;
			
			// Sets the regfile to load the mem_data
			RegEnable = 1'b1 << last_instr[11:8];
			
			// Opcode does not matter here
			Opcode = 8'b0;
			imm = 8'b0;
	
			FlagsEnable = 5'b0;
		end
		3'b010:
		begin
			// Set the PC enable
			PCEnable = 1'b1;
			
			// Set everything else to 0
			we_a = 0;			
			pc_mux = 0;
			ld_mux = 0;
			jal_mux = 0;
			pc_load = 0;
			branch_mux = 0;
			mux_A = 4'b0;
			mux_B = 4'b0;
			RegEnable = 16'b0;			
			Opcode = 8'b0;
			imm = 8'b0;
			FlagsEnable = 5'b0;
		end
		default: // Do nothing
		begin
			ld_mux = 1'b0;
			pc_mux = 1'b0;
			jal_mux = 1'b0;
			pc_load = 1'b0;
			branch_mux = 1'b0;
			Opcode = 8'b0;
			RegEnable = 16'b0;
			FlagsEnable = 5'b0;
			PCEnable = 1'b0;
			we_a = 1'b0;
			mux_A = 4'b0;
			mux_B = 4'b0;
			imm = 8'b0;
		end
		endcase
	end
endmodule
