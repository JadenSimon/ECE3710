`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    09/13/2018 
// Design Name:    Decoder
// Module Name:    Decoder
// Project Name:   Lab 2
//////////////////////////////////////////////////////////////////////////////////

module Decoder(Instruction, Clock, Reset, Flags, ALUBus);
	input [15:0] Instruction;
	input Clock, Reset;
	output [4:0] Flags;
	output [15:0] ALUBus;

	// Set up some wires
	wire [15:0] RegWire [15:0];
	wire [15:0] InputDST, InputSRC;
	wire [15:0] RegEnable;
	wire [7:0] Opcode;
	wire [4:0] ALUFlags;
	wire [4:0] FlagsEnable;
	
	// ALU DST/SRC Muxes
	assign InputDST = RegWire[Instruction[11:8]];
	assign InputSRC = RegWire[Instruction[3:0]];

	// Decode the DST register for the RegFile. If the instruction is CMP or CMPI set all to 0.
	assign RegEnable = (Instruction[15:12] == 4'b1011 || (Instruction[15:12] == 4'b0000 && Instruction[7:4] == 4'b1011)) ? 16'b0 : 16'b1 << Instruction[11:8];
	
	// Set the opcode
	assign Opcode = {Instruction[15:12], Instruction[7:4]};
	
	// Set the flags enable
	assign FlagsEnable = 5'b11111;
	
	// Instantiate the ALU, RegFile and flags register
	flags FlagsRegUnit(Clock, Reset, FlagsEnable, ALUFlags, Flags);
	ALU ALUUnit(InputDST, InputSRC, Instruction[7:0], ALUBus, Flags[3], Opcode, ALUFlags);
	RegFile RegFileUnit(ALUBus, RegWire[0], RegWire[1], RegWire[2], RegWire[3],
										 RegWire[4], RegWire[5], RegWire[6], RegWire[7],
										 RegWire[8], RegWire[9], RegWire[10], RegWire[11],
										 RegWire[12], RegWire[13], RegWire[14], RegWire[15],
										 RegEnable, Clock, Reset);

endmodule