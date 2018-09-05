`timescale 1ns / 1ps
module ALU_TestBench;

	// Inputs
	reg [7:0] Opcode;
	reg [15:0] Src;
	reg [15:0] Dest;	
	
	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;
	
	// counter variable
	integer i;
	
	// Instantiate the DE1 Soc(de1soc)
	ALU test1(
		.Src(Src), 
		.Dest(Dest),
		.Opcode(Opcode),
		.Flags(Flags),
		.C(C)
	);
	
	initial begin
	
	// Initialize Inputs
	Opcode = 0;
	Src = 0;
	Dest = 0;
	
	$monitor("Src: %0d, Dest: %0d, C: %0d, Flags[4:0]: %b, time:%0d", Src, Dest, C, Flags[4:0], $time );

	// [4] = z, [2] = overflow, 
	
	#10;
	
	// add (signed)
	Opcode = 8'b00000101; 
	// overflow
	Src = 16'b0111111111111111; Dest = 16'b0111111111111111;
	#10;
	// zero
	Src = 16'd2; Dest = -16'd2;
	#10;
	
	// add (unsigned)
	Opcode = 8'b00000110;
	// carry
	Src = 16'b1111111111111111; Dest = 1;
	#10;
	// zero
	Src = 0; Dest = 0;
	#10;
	// carry
	Src = 16'b1111111111111111; Dest = 1;
	#10;
	
	// subtract
	Opcode = 8'b00001001;
	#10;
	// zero
	Src = 16'd3; Dest = 16'd3;
	#10;	
	// overflow
	Src = 16'b1111111111111110; Dest = 16'b0111111111111111;	
	#10;
	
	//and
	Opcode = 8'b00000001;
	#10;
	// zero
	Src = 16'b0; Dest = 16'b1;	
	#10;
	
	//or
	Opcode = 8'b00000010;
	#10;
	// zero
	Src = 16'b0; Dest = 16'b0;
	#10;
	
	//xor
	Opcode = 8'b00000011;
	#10;
	// zero
	Src = 16'b0; Dest = 16'b0;
	#10;
	
	// compare
	Opcode = 8'b00001011;
	#10;
	//negative = 1
	Src = 16'b1; Dest = 16'b0;
	#10;
	//negative = 0
	Src = 16'b0; Dest = 16'b1;
	#10;
	// negative = 0
	Src = 16'b1111111111111110; Dest = 16'b1111111111111111;
	#10;
	
	// LHS
	Opcode = 8'b10000100;
	#10;
	Dest = 16'b1;
	#10;
	// Should this result in zero?
	Dest = 16'b1000000000000000;
	#10;
	
	// RHS
	Opcode = 8'b10001100;
	#10;
	Dest = 16'b1;
	#10;
	Dest = 16'b1000000000000000;
	#10;
	
	
	

	
//	//Random simulation
//	for( i = 0; i< 10; i = i+ 1)
//	begin
//		#10
//		A = $random % 16;
//		B = $random %16;
//		$display("A: %0d, B: %0d, C: %0d, Flags[1:0]: %b, time:%0d", A, B, C, Flags[1:0], $time );
//	end
//	$finish(2);
		
    
	 end  
endmodule