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
module cpu_datapath(clk, reset);
	// Global wires
	input wire clk, reset;

	// Set up bram wires
	wire [15:0] data_a, data_b;
	wire [15:0] addr_b;
	wire we_a, we_b;
	wire [15:0] q_a, q_b;
	
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
	wire ld_mux, pc_mux, jal_mux, branch_mux;
	
	// Set up PC wires
	wire PCEnable, pc_load;
	wire [15:0] PCOut;
	wire [15:0] PCAdder;
	
	// Set up mux output wires
	wire [15:0] LoadMuxOut;
	wire [15:0] PCMuxOut, PCMuxIn;
	
	// Generate muxes and assign values to wires
	assign DST = RegWire[mux_A];
	assign SRC = RegWire[mux_B];
	assign PCMuxOut = reset ? 16'bz : (pc_mux ? SRC : (pc_load ? ALUOutput : PCOut));
	assign LoadMuxOut = jal_mux ? PCOut : (ld_mux ? q_a : ALUOutput);
	assign PCAdder = branch_mux ? Immediate : 16'b1;
	assign PCMuxIn = pc_load ? (ALUOutput + 1'b1) : (PCOut + PCAdder);

	// Connect DST to data_a
	assign data_a = DST;
	
	// Assign dummy values for unhooked up components
	assign addr_b = 16'b0;
	assign data_b = 16'b0;
	assign we_b = 1'b0;
	
	// Instantiate our modules
	flags FlagsRegUnit(clk, reset, FlagsEnable, ALUFlags, RegFlags);
	ALU ALUUnit(DST, SRC, Immediate, ALUOutput, RegFlags[3], Opcode, ALUFlags);
	Bram BlockRam(data_a, data_b, PCMuxOut, addr_b, we_a, we_b, clk, q_a, q_b);
	control_fsm FSMUnit(clk, reset, q_a, RegFlags, ld_mux, pc_mux, jal_mux, pc_load, branch_mux, mux_A, mux_B, Opcode, RegEnable, FlagsEnable, PCEnable, we_a, Immediate);
	program_counter PC(clk, reset, PCEnable, PCMuxIn, PCOut);
	RegFile RegFileUnit(LoadMuxOut, RegWire[0], RegWire[1], RegWire[2], RegWire[3],
										RegWire[4], RegWire[5], RegWire[6], RegWire[7],
										RegWire[8], RegWire[9], RegWire[10], RegWire[11],
										RegWire[12], RegWire[13], RegWire[14], RegWire[15],
										RegEnable, clk, reset);	
										
	
endmodule
