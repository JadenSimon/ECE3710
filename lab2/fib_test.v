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
	
	// Initialize the 2nd register to 1
	Instruction = 16'b1101000100000001;
	#10; Clock = 1; #10; Clock = 0;
	
	// Loop through every register starting from 2, adding the previous two registers
	for (i = 2; i < 16; i = i + 1)
	begin
		Instruction = {4'b0000, i[3:0], 4'b0101, i[3:0] - 4'b0001}; // First instruction
		#10; Clock = 1; #10; Clock = 0;
		Instruction = {4'b0000, i[3:0], 4'b0101, i[3:0] - 4'b0010}; // Second instruction
		#10; Clock = 1; #10; Clock = 0;
	end
	
	DisplayRegs();

	
	$finish(2);
	end
endmodule