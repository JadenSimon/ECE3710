`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    10/17/2018
// Design Name:    cpu_datapath
// Module Name:    cpu_datapath
// Project Name:   Lab 4
//////////////////////////////////////////////////////////////////////////////////

// Instantiates all modules and creates muxes
module cpu_datapath(clk, reset, controller1_data, controller2_data, addr_b, q_b);
	// Global wires
	input wire clk, reset;
	input wire [15:0] controller1_data, controller2_data;
	input wire [15:0] addr_b; // Used by VGA
	output wire [15:0] q_b; // Used by VGA

	// Set up bram wires
	wire [15:0] data_a, data_b;
	wire we_a, we_b, fsm_we;
	wire [15:0] q_a;
	
	// Set up ALU wires
	wire [15:0] DST, SRC, ALUOutput;
	wire [7:0] Immediate, Opcode;
	wire [4:0] ALUFlags;
	
	// Set up register wires
	wire [15:0] RegEnable;
	wire [15:0] RegWire [15:0];
	wire [4:0] FlagsEnable;
	wire [4:0] RegFlags;
	
	// Set up select lines
	wire [3:0] mux_A, mux_B;
	wire [1:0] snes_mux;
	wire ld_mux, pc_mux, jal_mux, branch_mux;
	
	// Set up PC wires
	wire PCEnable, pc_load, fsm_pc;
	wire [15:0] PCOut;
	
	// Set up mux output wires
	wire [15:0] LoadMuxOut;
	wire [15:0] PCMuxOut, PCMuxIn;
	
	// Generate muxes and assign values to wires
	assign DST = branch_mux ? PCOut : RegWire[mux_A];
	assign SRC = RegWire[mux_B];
	assign PCMuxOut = pc_mux ? ALUOutput : PCOut;
	assign LoadMuxOut = snes_mux[0] ? (snes_mux[1] ? controller2_data : controller1_data) : (jal_mux ? PCOut : (ld_mux ? q_a : ALUOutput));
	assign PCMuxIn = (pc_load ? ALUOutput : PCOut) + 1'b1;

	// Connect DST to data_a
	assign data_a = DST;
	assign we_a = reset ? 1'b0 : fsm_we;
	assign PCEnable = reset ? 1'b0 : fsm_pc;
	
	// The b port is never being written to.
	assign data_b = 16'b0;
	assign we_b = 1'b0;
	
	// Instantiate our modules
	flags FlagsRegUnit(clk, reset, FlagsEnable, ALUFlags, RegFlags);
	ALU ALUUnit(DST, SRC, Immediate, ALUOutput, RegFlags[3], Opcode, ALUFlags);
	Bram BlockRam(data_a, data_b, PCMuxOut, addr_b, we_a, we_b, clk, q_a, q_b);
	control_fsm FSMUnit(clk, reset, q_a, RegFlags, ld_mux, pc_mux, jal_mux, pc_load, branch_mux, snes_mux, mux_A, mux_B, Opcode, RegEnable, FlagsEnable, fsm_pc, fsm_we, Immediate);
	program_counter PC(clk, reset, PCEnable, PCMuxIn, PCOut);
	RegFile RegFileUnit(LoadMuxOut, RegWire[0], RegWire[1], RegWire[2], RegWire[3],
										RegWire[4], RegWire[5], RegWire[6], RegWire[7],
										RegWire[8], RegWire[9], RegWire[10], RegWire[11],
										RegWire[12], RegWire[13], RegWire[14], RegWire[15],
										RegEnable, clk, reset);									
	
endmodule
