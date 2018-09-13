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
	Instruction = 16'b1101000000000101;
	#10; Clock = 1; #10; Clock = 0;
	$display("Set reg0 to %0h", ALUBus);
	Instruction = 16'b1101000100000010;
	#10; Clock = 1; #10; Clock = 0;
	$display("Set reg1 to %0h", ALUBus);
	
	// Add reg0 and reg1
	Instruction = 16'b0000000001010001;
	#10; Clock = 1; #10; Clock = 0;
	$display("Performed reg0 = reg0 + reg1");
	
	// Shift reg1 to the left
	Instruction = 16'b1000000101000000;
	#10; Clock = 1; #10; Clock = 0;
	$display("Performed reg1 = reg1 << 1");
	
	// Compare and display flags
	Instruction = 16'b0000000010110001;
	#10; Clock = 1; #10; Clock = 0;
	$display("Performed CMP reg0 reg1, flags: %b", Flags);
	
	// Compare and display flags
	Instruction = 16'b1011000000001011;
	#10; Clock = 1; #10; Clock = 0;
	$display("Performed CMP reg0 11, flags: %b", Flags);
	
	DisplayRegs();

	
	$finish(2);
	end
endmodule