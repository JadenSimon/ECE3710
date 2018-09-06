`timescale 1ns / 1ps
module ALU_TestBench;

	// Inputs
	reg [7:0] Opcode;
	reg [15:0] SRC;
	reg [15:0] DST;	
	
	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;
	
	// counter variable
	integer i;
	
	// Instantiate the DE1 Soc(de1soc)
	ALU test1(
		.SRC(SRC), 
		.DST(DST),
		.Opcode(Opcode),
		.c_in(c_in),
		.Flags(Flags),
		.C(C)
	);
	
	initial begin
	
	// Initialize Inputs
	Opcode = 0;
	SRC = 0;
	DST = 0;
	c_in = 0;
	
	$monitor("SRC: %0d, DST: %0d, C: %0d, Flags[4:0]: %b, time:%0d", SRC, DST, C, Flags[4:0], $time );

	// [4] = z, [2] = overflow, 
	
	#10;
	
	// add (signed)
	Opcode = 8'b00000101; 
	// overflow
	SRC = 16'b0111111111111111; DST = 16'b0111111111111111;
	#10;
	// zero
	SRC = 16'd2; DST = -16'd2;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	// add (unsigned)
	Opcode = 8'b00000110;
	// carry
	SRC = 16'b1111111111111111; DST = 1;
	#10;
	// zero
	SRC = 0; DST = 0;
	#10;
	// carry
	SRC = 16'b1111111111111111; DST = 1;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	// subtract
	Opcode = 8'b00001001;
	// zero
	SRC = 16'd3; DST = 16'd3;
	#10;	
	// overflow
	SRC = 16'b1111111111111110; DST = 16'b0111111111111111;	
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;

	//and
	Opcode = 8'b00000001;
	// zero
	SRC = 16'b0; DST = 16'b1;	
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;

	//or
	Opcode = 8'b00000010;
	// zero
	SRC = 16'b0; DST = 16'b0;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	//xor
	Opcode = 8'b00000011;
	// zero
	SRC = 16'b0; DST = 16'b0;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	// compare
	Opcode = 8'b00001011;
	//negative = 1
	SRC = 16'b1; DST = 16'b0;
	#10;
	//negative = 0
	SRC = 16'b0; DST = 16'b1;
	#10;
	// negative = 0
	SRC = 16'b1111111111111110; DST = 16'b1111111111111111;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	// LHS
	Opcode = 8'b10000100;
	DST = 16'b1;
	#10;
	// Should this result in zero?
	DST = 16'b1000000000000000;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	// RHS
	Opcode = 8'b10001100;
	DST = 16'b1;
	#10;
	DST = 16'b1000000000000000;
	#10;
	// Random
	for( i = 0; i< 10; i = i+ 1)
	begin
		#10
		SRC = $random % 16;
		DST = $random % 16;
	end
	#10;
	
	$finish(2);
		   
	 end  
endmodule