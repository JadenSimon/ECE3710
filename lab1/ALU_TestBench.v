`timescale 1ns / 1ps
module ALU_TestBench;

	// Inputs
	reg [7:0] Opcode;
	reg [15:0] SRC;
	reg [15:0] DST;
	reg [15:0] Immediate;
	reg c_in;
	
	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;
	
	// counter variable
	integer i;
	
	// Instantiate the DE1 Soc(de1soc)
	ALUWrapper test1(
		.SRC(SRC), 
		.DST(DST),
		.Immediate(Immediate),
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
	
	$monitor("OPCODE: %b, SRC: %0h, DST: %0h, C: %0d, Flags[4:0]: %b, time:%0d", Opcode, SRC, DST, C, Flags[4:0], $time );

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
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	// addc
	Opcode = 8'b00000111; 
	// overflow
	SRC = 16'b0111111111111111; DST = 16'b0000000000000000; c_in=1;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//		c_in = $urandom % 1;
//	end
//	#10;
	
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
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
	// subtract
	Opcode = 8'b00001001;
	// zero
	SRC = 16'd3; DST = 16'd3;
	#10;	
	// overflow
//	SRC = 16'b1000000000000000; DST = 16'b1000000000000000;
//	#10;
//	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	//and
	Opcode = 8'b00000001;
	// zero
	SRC = 16'b0; DST = 16'b1;	
	#10;
//	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	//or
	Opcode = 8'b00000010;
	// zero
	SRC = 16'b0; DST = 16'b0;
	#10;
//	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
	//xor
	Opcode = 8'b00000011;
	// zero
	SRC = 16'b0; DST = 16'b0;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
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
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
	// lhs
	Opcode = 8'b10000100;
	DST = 16'b1;
	#10;
	// Should this result in zero?
	DST = 16'b1000000000000000;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
	// rhs
	Opcode = 8'b10001100;
	DST = 16'b1;
	#10;
	DST = 16'b1000000000000000;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		SRC = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	// mov
	Opcode = 8'b00001101;
	SRC = 16'b1;
	#10;


	//andi
	Opcode = 8'b00010000;
	// zero
	Immediate = 16'b0; DST = 16'b1;	SRC = 16'bx;
	#10;
//	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	//ori
	Opcode = 8'b00100000;
	// zero
	Immediate = 16'b0; DST = 16'b0; 
	#10;
//	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	//xori
	Opcode = 8'b00110000;
	// zero
	Immediate = 16'b0; DST = 16'b0; 
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	// addi
	Opcode = 8'b01010000; 
	// overflow
	Immediate = 16'b0111111111111111; DST = 16'b0111111111111111;
	#10;
	// zero
	Immediate = 16'd2; DST = -16'd2;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
	// addui
	Opcode = 8'b01100000;
	// carry
	Immediate = 16'b1111111111111111; DST = 1;
	#10;
	// zero
	Immediate = 0; DST = 0;
	#10;
	// carry
	Immediate = 16'b1111111111111111; DST = 1;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;
	
	// addci
	Opcode = 8'b01110000; 
	// overflow
	Immediate = 16'b0111111111111111; DST = 16'b0000000000000000; c_in=1;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//		c_in = $urandom % 1;
//	end
//	#10;

	// subi
	Opcode = 8'b10010000;
	// zero
	Immediate = 16'd3; DST = 16'd3;
	#10;	
	// overflow
//	Immediate = 16'b1000000000000000; DST = 16'b1000000000000000;
//	#10;
//	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	// cmpi
	Opcode = 8'b10110000;
	//negative = 1
	Immediate = 16'b1; DST = 16'b0;
	#10;
	//negative = 0
	Immediate = 16'b0; DST = 16'b1;
	#10;
	// negative = 0
	Immediate = 16'b1111111111111110; DST = 16'b1111111111111111;
	#10;
	// Random
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		Immediate = $random % 16;
//		DST = $random % 16;
//	end
//	#10;

	// movi
	Opcode = 8'b11010000;
	Immediate = 16'b1;
	#10;
	
	$finish(2);
		   
	 end  
endmodule