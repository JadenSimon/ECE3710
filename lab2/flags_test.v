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

module flags_test;
	// Inputs
	wire [4:0] Flags;
	reg [15:0] Instruction;
	reg Clock, Reset;

	// Outputs
	wire [15:0] ALUBus;

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
	
	// Flag [4] = Z (Zero)
	// Flag [3] = C (Carry)
	// Flag [2] = O (Overflow) Note: This flag may sometimes be called 'F' in some documents
	// Flag [1] = L (Low) (Unsigned comparison)
	// Flag [0] = N (Negative) (Signed comparison)

	initial begin

	// Initialize inputs
	Instruction = 0;
	Reset = 1; Clock = 1; #10; Clock = 0; Reset = 0;

	// Initialize the 1st register to 0
	Instruction = 16'b1101000100000000;
	#10; Clock = 1; #10; Clock = 0;

	if (Flags[4] == 1'b1)
		$display("Zero flag PASS\n");
	else
		$display("Zero flag FAIL\tFlags: %b\n", Flags);


	// Initialize the 2nd register to 1
	Instruction = 16'b1101001000000001;
	#10; Clock = 1; #10; Clock = 0;

	// Compare the first two registers
	Instruction = 16'b0000000110110010;
	#10; Clock = 1; #10; Clock = 0;

	if (Flags[0] == 1'b1)
		$display("Negative flag PASS\n");
	else
		$display("Negative flag FAIL\tFlags: %b\n", Flags);


	if (Flags[1] == 1'b1)
		$display("Low flag PASS\n");
 	else
		$display("Low flag FAIL\tFlags: %b\n", Flags);


	// Initialize the 1st register to all ones
	Instruction = 16'b1101000111111111;
	#10; Clock = 1; #10; Clock = 0;

	// Shift to the left by 7
	Instruction = 16'b1000000101000111;
	#10; Clock = 1; #10; Clock = 0;

	// Shift to the left by 1
	Instruction = 16'b1000000101000001;
	#10; Clock = 1; #10; Clock = 0;

	// Initialize the 1st register to all ones
	Instruction = 16'b0010000111111111;
	#10; Clock = 1; #10; Clock = 0;

	// Initialize the 1st register to all ones
	Instruction = 16'b0000000101100010;
	#10; Clock = 1; #10; Clock = 0;

	if (Flags[3] == 1'b1)
		$display("Carry flag PASS\n");
	else
		$display("Carry flag FAIL\tFlags: %b\n", Flags);


	// Shift to the right by 1
	Instruction = 16'b1000000101001111;
	#10; Clock = 1; #10; Clock = 0;

	// mov r0 into r1
	Instruction = 16'b0000001011010001;
	#10; Clock = 1; #10; Clock = 0;

	//add r0 and r1
	Instruction = 16'b0000000101010010;
	#10; Clock = 1; #10; Clock = 0;

	if (Flags[2] == 1'b1)
		$display("Overflow flag PASS\n");
	else
		$display("Overflow flag FAIL\tFlags: %b\n", Flags);


	$finish(2);
	end
endmodule
