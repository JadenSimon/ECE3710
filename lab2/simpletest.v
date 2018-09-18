`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    09/13/2018
// Design Name:    simpletest
// Module Name:    simpletest
// Project Name:   Lab 2
//////////////////////////////////////////////////////////////////////////////////

module simpletest;
	`include "instructionset.v"
	
	// Inputs
	reg [15:0] Instruction;
	reg Clock, Reset;
	
	// Outputs
	wire [15:0] ALUBus;
	wire [4:0] Flags;
	
	// Counter variable
	integer i;
	
	// Instantiate our Decoder
	Decoder test(
		.Instruction(Instruction),
		.Clock(Clock),
		.Reset(Reset),
		.Flags(Flags),
		.ALUBus(ALUBus)
	);
	
	// Performs an instruction
	task PerformInstruction(input [3:0] DST, input [3:0] Group, input [3:0] SRC, input [3:0] Opcode);		
	begin	
		Instruction = {DST, Group, SRC, Opcode};
		#10; Clock = 1; #10; Clock = 0;
	end
	endtask
	
	// Helper task to initialize registers to 0
	task InitializeRegs();
	begin
		for (i = 0; i < 16; i = i + 1)
		begin
			Instruction = {4'b1101, i[3:0], 8'b0};
			#10; Clock = 1; #10; Clock = 0;
		end
	end
	endtask
	
	// Helper task to display all the register values
	task DisplayRegs();
	begin
		$display("Register dump:");
	
		for (i = 0; i < 16; i = i + 1)
		begin
			Instruction = {4'b0000, i[3:0], 4'b1101, i[3:0]};
			#10; Clock = 1; #10; Clock = 0;
			$write("reg%0d: %0h\t", i, ALUBus);
			
			if (i % 4 == 3) $write("\n");
		end		
	end
	endtask
	
	initial begin
	
	// Initialize inputs
	Instruction = 0;
	Clock = 0;
	Reset = 0;
	InitializeRegs();
	
	// Set reg0 and reg1 to 5 and 2 respectively using MOVI
	PerformInstruction(MOVI, REG0, 4'b0000, 4'b0101);
	$display("Set reg0 to %0h", ALUBus);
	PerformInstruction(MOVI, REG1, 4'b0000, 4'b0010);
	$display("Set reg1 to %0h", ALUBus);
	
	// Add reg0 and reg1
	PerformInstruction(Register, REG0, ADD, REG1);
	$display("Performed reg0 = reg0 + reg1");
	
	// Shift reg1 to the left
	PerformInstruction(Shift, REG1, LSH, 4'b0001);
	$display("Performed reg1 = reg1 << 1");
	
	// Compare and display flags
	PerformInstruction(Register, REG0, CMP, REG1);
	$display("Performed CMP reg0 reg1, flags: %b", Flags);
	
	// Compare and display flags
	PerformInstruction(CMPI, REG0, 4'b0000, 4'b1011);
	$display("Performed CMPI reg0 0xb, flags: %b", Flags);
	
	// Subtract -1 from reg1
	PerformInstruction(SUBI, REG1, 4'b0000, 4'b0001);
	$display("Performed SUBI reg1 0x1, flags: %b", Flags);
	
	DisplayRegs();

	
	$finish(2);
	end
endmodule