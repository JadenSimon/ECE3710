`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    09/13/2018
// Design Name:    fib_test
// Module Name:    fib_test
// Project Name:   Lab 2
//////////////////////////////////////////////////////////////////////////////////

module fib_test;
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
	Reset = 1; Clock = 1; #10; Clock = 0; Reset = 0;
	
	// Initialize REG1 to 1
	PerformInstruction(MOVI, REG1, 4'b0000, 4'b0001);
	
	// Loop through every register starting from 2, adding the previous two registers
	for (i = 2; i < 16; i = i + 1)
	begin
		PerformInstruction(Register, i[3:0], ADD, i[3:0] - 4'b0001); // REGi = REGi + REGi-1
		PerformInstruction(Register, i[3:0], ADD, i[3:0] - 4'b0010); // REGi = REGi + REGi-2
	end
	
	DisplayRegs();
	
	$finish(2);
	end
endmodule