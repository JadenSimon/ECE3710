`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    09/13/2018
// Design Name:    multiply_test
// Module Name:    multiply_test
// Project Name:   Lab 2
//////////////////////////////////////////////////////////////////////////////////

module multiply_test;
	`include "instructionset.v"

	// Inputs
	reg [15:0] Instruction;
	reg Clock, Reset;
	
	// Outputs
	wire [15:0] ALUBus;
	wire [4:0] Flags;
	
	// Counter variable
	integer i;
	integer y;
	
	// Test variables
	reg [7:0] A, B;
	
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
	
		for (y = 0; y < 16; y = y + 1)
		begin
			Instruction = {4'b0000, y[3:0], 4'b1101, y[3:0]};
			#10; Clock = 1; #10; Clock = 0;
			$write("reg%0d: %0h\t", y, ALUBus);
			
			if (y % 4 == 3) $write("\n");
		end		
	end
	endtask
	
	initial begin
	
	// Initialize inputs
	Instruction = 0;
	Reset = 1; Clock = 1; #10; Clock = 0; Reset = 0;
	
	// Set A and B here
	A = 8'b00011111;
	B = 8'b11100011;

	// Initialize reg0 to A
	PerformInstruction(MOVI, REG0, A[7:4], A[3:0]);
	// Initialize reg1 to B
	PerformInstruction(MOVI, REG1, B[7:4], B[3:0]);
	
	// We're multiplying 8-bit numbers so we will need to shift and compare 8 times.
	// reg2 will be a temporary register
	for (i = 0; i < 8; i = i + 1)
	begin
		// To multiply we check the LSB of the multiplier, if 1 add the multiplicand to our product register (reg3)
		// Checking the LSB is as simple as reg1 AND 0x1, but we move it to a temp register first
		PerformInstruction(Register, REG2, MOV, REG1);
		PerformInstruction(ANDI, REG2, 4'b0000, 4'b0001);
		PerformInstruction(Register, REG2, MOV, REG2);
		
		// Now check the zero flag
		if (Flags[4] != 1)
			PerformInstruction(Register, REG3, ADD, REG0);
		
		// Now shift the multiplicand to the left 1 and the multiplier to the right 1
		PerformInstruction(Shift, REG0, LSH, 4'b0001);
		PerformInstruction(Shift, REG1, LSH, 4'b1111);
	end

	PerformInstruction(Register, REG3, MOV, REG3);
	$display("%0d * %0d = %0d", A, B, ALUBus);
	
	$finish(2);
	end
endmodule