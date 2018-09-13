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
	Instruction = {8'b11010000, A};
	#10; Clock = 1; #10; Clock = 0;
	// Initialize reg1 to B
	Instruction = {8'b11010001, B};
	#10; Clock = 1; #10; Clock = 0;
	
	// We're multiplying 8-bit numbers so we will need to shift and compare 8 times.
	// reg2 will be a temporary register
	for (i = 0; i < 8; i = i + 1)
	begin
		// To multiply we check the LSB of the multiplier, if 1 add the multiplicand to our product register (reg3)
		// Checking the LSB is as simple as reg1 AND 0x1, but we move it to a temp register first
		Instruction = 16'b0000001011010001; // MOV reg2 reg1
		#10; Clock = 1; #10; Clock = 0;
		Instruction = 16'b0001001000000001; // ANDI reg2 0x1
		#10; Clock = 1; #10; Clock = 0;
		Instruction = 16'b0000001011010010; // MOV reg2 reg2
		#10; Clock = 1; #10; Clock = 0;
		
		// Now check the zero flag
		if (Flags[4] != 1)
		begin
			Instruction = 16'b0000001101010000; // ADD reg3 reg0
			#10; Clock = 1; #10; Clock = 0;
		end
		
		// Now shift the multiplicand to the left 1 and the multiplier to the right 1
		Instruction = 16'b1000000001000001;
		#10; Clock = 1; #10; Clock = 0;
		Instruction = 16'b1000000101001111;
		#10; Clock = 1; #10; Clock = 0;		
	end

	Instruction = 16'b0000001111010011; // MOV reg3 reg3
	#10; Clock = 1; #10; Clock = 0;
	$display("%0d * %0d = %0d", A, B, ALUBus);
	
	$finish(2);
	end
endmodule