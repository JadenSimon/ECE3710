`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    08/30/2018 
// Design Name:    tb_ALU
// Module Name:    tb_ALU
// Project Name:   Lab 1
//////////////////////////////////////////////////////////////////////////////////


// This testbench succeeds when no errors are displayed.
module tb_ALU;

	// Inputs
	reg [7:0] Opcode;
	reg [15:0] SRC;
	reg [15:0] DST;
	reg [7:0] Immediate;
	reg c_in;
	
	// Outputs
	wire [15:0] C;
	wire [4:0] Flags;
	
	// counter variable
	integer i;
	
	// Set to enable/disable random tests
	integer RANDOM_TESTS = 1;
	
	// temporary
	reg [4:0] temp_flags;
	reg [15:0] temp_out;
	
	// Instantiate the DE1 Soc(de1soc)
	ALU test1(
		.SRC(SRC), 
		.DST(DST),
		.Immediate(Immediate),
		.Opcode(Opcode),
		.c_in(c_in),
		.Flags(Flags),
		.C(C)
	);
	
	// This function verifies that the ALU is outputting correctly, displays a warning otherwise
	task test_instruction(input [512:1] Name, input [15:0] C_Answer, input [4:0] Flags_Answer);
	begin
		#10;
		if (C != C_Answer || Flags != Flags_Answer)  
		begin
			$display("Test Name: %s", Name);
		
			if (C != C_Answer)
				$display("\tERROR: Incorrect output got %h expected %h", C, C_Answer);
			if (Flags != Flags_Answer)
				$display("\tERROR: Incorrect flags got %b expected %b", Flags[4:0], Flags_Answer[4:0]);
			
			$display("OPCODE: %b, SRC: %0h, DST: %0h, IMM : %0h, c_in: %b, C: %0h, Flags[4:0]: %b\n", Opcode, SRC, DST, Immediate, c_in, C, Flags[4:0]);
		end
	end
	endtask
	
	initial begin	
	
	// Initialize Inputs
	Opcode = 0;
	SRC = 0;
	DST = 0;
	c_in = 0;
	temp_flags = 0;
	temp_out = 0;
	
	// Flag [4] = Z (Zero)
	// Flag [3] = C (Carry)
	// Flag [2] = O (Overflow) Note: This flag may sometimes be called 'F' in some documents
	// Flag [1] = L (Low)
	// Flag [0] = N (Negative)
		
	/* Corner case tests */
	
	/* ADD Tests */
	Opcode = 8'b00000101; 
	
	// MAX + 1 should overflow 
	SRC = 16'b0111111111111111; DST = 16'b0000000000000001;
	test_instruction("ADD Positive Overflow", 16'b1000000000000000, 5'b00100);
	// Max negative + -1
	SRC = 16'b1111111111111111; DST = 16'b1000000000000000;
	test_instruction("ADD Negative Overflow", 16'b0111111111111111, 5'b00100);
	// Add -1 to 1 for zero flag
	SRC = 16'b1111111111111111; DST = 16'b0000000000000001;
	test_instruction("ADD Zero Flag", 16'b0000000000000000, 5'b10000);
	// ADDI Normal
	Opcode = 8'b0101xxxx;
	Immediate = 8'b00000001; DST = 16'b0000000000000001;
	test_instruction("ADDI Normal", 16'b0000000000000010, 5'b00000);
	// ADDI MAX + 1
	Immediate = 8'b01111111; DST = 16'b0000000000000001;
	test_instruction("ADDI MAX", 16'b0000000010000000, 5'b00000);
	// ADDI MAX_NEGATIVE - 1
	Immediate = 8'b11111111; DST = 16'b1000000000000000;
	test_instruction("ADDI Negative Overflow", 16'b0111111111111111, 5'b00100);
	
	/* ADDU Tests */
	Opcode = 8'b00000110; 
	
	// MAX + 1 should carry
	SRC = 16'b1111111111111111; DST = 16'b0000000000000001;
	test_instruction("ADDU Overflow", 16'b0000000000000000, 5'b11000);
	// Normal unsigned addition test
	SRC = 16'b0000000000000001; DST = 16'b0000000000000001;
	test_instruction("ADDU Normal", 16'b0000000000000010, 5'b00000);
	// ADDUI Normal
	Opcode = 8'b0110xxxx;
	Immediate = 8'b00000001; DST = 16'b0000000000000001;
	test_instruction("ADDUI Normal", 16'b0000000000000010, 5'b00000);
	// ADDI MAX + 1
	Immediate = 8'b11111111; DST = 16'b0000000000000001;
	test_instruction("ADDUI MAX", 16'b0000000100000000, 5'b00000);
	// ADDI enough to overflow to 1
	Immediate = 8'b10000001; DST = 16'b1111111110000000;
	test_instruction("ADDUI Positive Carry", 16'b0000000000000001, 5'b01000);
	
	
	/* ADDC Tests */
	Opcode = 8'b00000111; 
	
	// MAX + 1 should overflow
	SRC = 16'b0111111111111111; DST = 16'b0000000000000000; c_in = 1;
	test_instruction("ADDC Overflow 1", 16'b1000000000000000, 5'b00100);
	// MAX + 2 should overflow
	SRC = 16'b0111111111111111; DST = 16'b0000000000000001; c_in = 1;
	test_instruction("ADDC Overflow 2", 16'b1000000000000001, 5'b00100);
	// MAX_NEGATIVE - 1 + 1 should not overflow
	SRC = 16'b1000000000000000; DST = 16'b1111111111111111; c_in = 1;
	test_instruction("ADDC Overflow 3", 16'b1000000000000000, 5'b00000);
	// Normal ADDC with c_in = 0
	SRC = 16'b0000000000000001; DST = 16'b0000000000000001; c_in = 0;
	test_instruction("ADDC Normal", 16'b0000000000000010, 5'b00000);
	// ADDCI overflow
	Opcode = 8'b0111xxxx;
	Immediate = 8'b00000001; DST = 16'b0111111111111110; c_in = 1;
	test_instruction("ADDCI Overflow", 16'b1000000000000000, 5'b00100);
	// ADDCI negative
	Immediate = 8'b11111111; DST = 16'b0111111111111111; c_in = 1;
	test_instruction("ADDCI MAX + 1 - 1", 16'b0111111111111111, 5'b00000);
	// ADDCI No Carry
	Immediate = 8'b11111111; DST = 16'b0111111111111111; c_in = 0;
	test_instruction("ADDCI No Carry", 16'b0111111111111110, 5'b00000);
	
	/* SUB Tests */
	Opcode = 8'b00001001; 
	
	// MAX_NEGATIVE - 1 should overflow
	SRC = 16'b1000000000000000; DST = 16'b0000000000000001;
	test_instruction("SUB Negative Overflow", 16'b0111111111111111, 5'b00100);
	// MAX_NEGATIVE + 1 should not overflow
	SRC = 16'b1000000000000000; DST = 16'b1111111111111111;
	test_instruction("SUB Negative", 16'b1000000000000001, 5'b00000);
	// MAX + 1 should overflow
	SRC = 16'b0111111111111111; DST = 16'b1111111111111111;
	test_instruction("SUB Positive Overflow", 16'b1000000000000000, 5'b00100);
	// MAX - 1 should not overflow
	SRC = 16'b0111111111111111; DST = 16'b0000000000000001;
	test_instruction("SUB Positive", 16'b0111111111111110, 5'b00000);
	// SUBI Zero
	Opcode = 8'b1001xxxx;
	Immediate = 8'b00000001; DST = 16'b0000000000000001; 
	test_instruction("SUBI Zero", 16'b0000000000000000, 5'b10000);
	// SUBI Positive Overflow
	Immediate = 8'b11111111; DST = 16'b0111111111111111;
	test_instruction("SUBI Positive Overflow", 16'b1000000000000000, 5'b00100);
	// SUBI Negative Overflow
	Immediate = 8'b00000001; DST = 16'b1000000000000000;
	test_instruction("SUBI Negative Overflow", 16'b0111111111111111, 5'b00100);

	/* OR Tests */
	Opcode = 8'b00000010; 
	
	// OR Zero	
	SRC = 16'b0111111111111111; DST = 16'b0000000000000000;
	test_instruction("OR Zero", 16'b0111111111111111, 5'b00000);
	// OR Max
	SRC = 16'b1111111111111111; DST = 16'b1000001001000000;
	test_instruction("OR Max", 16'b1111111111111111, 5'b00000);
	// ORI Normal
	Opcode = 8'b0010xxxx;
	Immediate = 8'b10000001; DST = 16'b0000000000000001; 
	test_instruction("ORI Normal", 16'b0000000010000001, 5'b00000);
	
	/* AND Tests */
	Opcode = 8'b00000001; 
	
	// AND Zero 
	SRC = 16'b0111111111111111; DST = 16'b0000000000000000;
	test_instruction("AND Zero", 16'b0000000000000000, 5'b10000);
	// AND Max
	SRC = 16'b1111111111111111; DST = 16'b1000001001000000;
	test_instruction("AND Max", 16'b1000001001000000, 5'b00000);
	// ANDI Normal
	Opcode = 8'b0001xxxx;
	Immediate = 8'b10000001; DST = 16'b0000000000000001; 
	test_instruction("ANDI Normal", 16'b0000000000000001, 5'b00000);
	
	/* XOR Tests */
	Opcode = 8'b00000011; 
	
	// XOR Zero 
	SRC = 16'b0111111111111111; DST = 16'b0000000000000000;
	test_instruction("XOR Zero", 16'b0111111111111111, 5'b00000);
	// XOR Max
	SRC = 16'b1111111111111111; DST = 16'b1000000000000001;
	test_instruction("XOR Max", 16'b0111111111111110, 5'b00000);
	// XORI Normal
	Opcode = 8'b0011xxxx;
	Immediate = 8'b10000001; DST = 16'b0000000000000001; 
	test_instruction("XORI Normal", 16'b0000000010000000, 5'b00000);
	
	/* CMP Tests */
	Opcode = 8'b00001011; 
	// CMP SRC less than DST
	SRC = 16'b1111111111111111; DST = 16'b0000000000000000;
	test_instruction("CMP SRC < DST 1", 16'b1111111111111111, 5'b00001);
	// CMP SRC less than DST unsigned
	SRC = 16'b0111111111111111; DST = 16'b1111111111111111;
	test_instruction("CMP SRC < DST 2", 16'b1000000000000000, 5'b00010);
	// CMP SRC greater than DST
	SRC = 16'b1111111111111111; DST = 16'b1111111111111110;
	test_instruction("CMP SRC > DST Both", 16'b0000000000000001, 5'b00000);
	// CMP SRC less than DST both
	SRC = 16'b0000000000001111; DST = 16'b0000000000010000;
	test_instruction("CMP SRC < DST Both", 16'b1111111111111111, 5'b00011);
	// CMP SRC equals DST
	SRC = 16'b0000000000000001; DST = 16'b0000000000000001;
	test_instruction("CMP SRC == DST", 16'b0000000000000000, 5'b10000);
	// CMPI IMM less than DST
	Opcode = 8'b1011xxxx;
	Immediate = 8'b11111111; DST = 16'b0000000000000000; 
	test_instruction("CMPI IMM < DST", 16'b1111111111111111, 5'b00001);
	// CMPI IMM greater than DST
	Immediate = 8'b01111111; DST = 16'b1111111111111111; 
	test_instruction("CMPI IMM > DST", 16'b0000000010000000, 5'b00010);
	// CMPI IMM greater than DST Unsigned
	Immediate = 8'b11111111; DST = 16'b0000000000001111; 
	test_instruction("CMPI IMM > DST Unsigned", 16'b1111111111110000, 5'b00001);
	// CMPI IMM greater than DST Signed
	Immediate = 8'b00000000; DST = 16'b1000000000000000; 
	test_instruction("CMPI IMM > DST Signed", 16'b1000000000000000, 5'b00010);
	// CMPI IMM equals DST
	Immediate = 8'b00001111; DST = 16'b0000000000001111; 
	test_instruction("CMPI IMM == DST", 16'b0000000000000000, 5'b10000);
	
	/* LSH Tests */
	Opcode = 8'b10000100; 
	
	// Shift zero left
	SRC = 16'b0000000000000000; DST = 16'b0000000000000000;
	test_instruction("Left Shift Zero", 16'b0000000000000000, 5'b10000);
	// Shift -1 left
	SRC = 16'b0000000000000000; DST = 16'b1111111111111111;
	test_instruction("Left Shift -1", 16'b1111111111111110, 5'b00000);
	// Shift MAX left
	SRC = 16'b0000000000000000; DST = 16'b0111111111111111;
	test_instruction("Left Shift Max", 16'b1111111111111110, 5'b00000);
	
	/* LSHI Tests */
	Opcode = 8'b10000000; 
	// Shift 1 left
	Immediate = 8'b00000001; DST = 16'b0000000000000000;
	test_instruction("Shift Immediate Left", 16'b0000000000000010, 5'b00000);
	// Shift MAX left
	Immediate = 8'b11111111; DST = 16'b0000000000000000;
	test_instruction("Shift Immediate MAX Left", 16'b0000000111111110, 5'b00000);
	
	Opcode = 8'b10000001; // Do right shifts now
	
	// Shift 1 right
	Immediate = 8'b00000001; DST = 16'b0000000000000000;
	test_instruction("Shift Immediate Right", 16'b0000000000000000, 5'b10000);
	// Shift MAX right
	Immediate = 8'b11111111; DST = 16'b0000000000000000;
	test_instruction("Shift Immediate MAX Right", 16'b000000001111111, 5'b00000);

	
	$display("***Corner case tests done!****");
	
	/* Random test section */
	/* Does 25,000 tests each */
	if (RANDOM_TESTS == 1)
	begin		
		$display("Started random tests, this may take a few seconds...");
	
		// Random signed addition
		Opcode = 8'b00000101;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = $signed(SRC) + $signed(DST);
			if (temp_out == 0) temp_flags[4] = 1;
			if( (~SRC[15] & ~DST[15] & temp_out[15]) | (SRC[15] & DST[15] & ~temp_out[15]) ) temp_flags[2] = 1'b1;
			
			// Check the result
			test_instruction("Random ADD", temp_out, temp_flags);
		end
		
		// Random unsigned addition
		Opcode = 8'b00000110;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			{temp_flags[3], temp_out} = SRC + DST;
			if (temp_out == 0) temp_flags[4] = 1;
			
			// Check the result
			test_instruction("Random ADDU", temp_out, temp_flags);
		end
		
		// Random subtraction
		Opcode = 8'b00001001;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = $signed(SRC) - $signed(DST);
			if (temp_out == 0) temp_flags[4] = 1;
			if( (~SRC[15] & DST[15] & temp_out[15]) | (SRC[15] & ~DST[15] & ~temp_out[15]) ) temp_flags[2] = 1'b1;
			
			// Check the result
			test_instruction("Random SUB", temp_out, temp_flags);
		end
		
		// Random and
		Opcode = 8'b00000001;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = SRC & DST;
			if (temp_out == 0) temp_flags[4] = 1;
			
			// Check the result
			test_instruction("Random AND", temp_out, temp_flags);
		end
		
		// Random or
		Opcode = 8'b00000010;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = SRC | DST;
			if (temp_out == 0) temp_flags[4] = 1;
			
			// Check the result
			test_instruction("Random OR", temp_out, temp_flags);
		end
		
		// Random xor
		Opcode = 8'b00000011;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = SRC ^ DST;
			if (temp_out == 0) temp_flags[4] = 1;
			
			// Check the result
			test_instruction("Random XOR", temp_out, temp_flags);
		end
		
		// Random cmp
		Opcode = 8'b00001011;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			SRC = $unsigned($random) % 16'b1111111111111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = $signed(SRC) - $signed(DST);
			if	($signed(SRC) < $signed(DST)) temp_flags[0] = 1'b1;
			if ($unsigned(SRC) < $unsigned(DST)) temp_flags[1] = 1'b1;
			temp_flags[4] = SRC == DST;
			
			// Check the result
			test_instruction("Random CMP", temp_out, temp_flags);
		end
		
		// Random addi
		Opcode = 8'b0101xxxx;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			Immediate = $unsigned($random) % 8'b11111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = {{8{Immediate[7]}}, Immediate[7:0]} + DST;
			if (temp_out == 0) temp_flags[4] = 1;
			if( (~Immediate[7] & ~DST[15] & temp_out[15]) | (Immediate[7] & DST[15] & ~temp_out[15]) ) temp_flags[2] = 1'b1;
			
			// Check the result
			test_instruction("Random ADDI", temp_out, temp_flags);
		end
		
		// Random subi
		Opcode = 8'b1001xxxx;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			Immediate = $unsigned($random) % 8'b11111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = DST + {{8{~Immediate[7]}}, ~Immediate[7:0]} + 1'b1;
			if (temp_out == 0) temp_flags[4] = 1;
			if( (Immediate[7] & ~DST[15] & temp_out[15]) | (~Immediate[7] & DST[15] & ~temp_out[15]) ) temp_flags[2] = 1'b1;
			
			// Check the result
			test_instruction("Random SUBI", temp_out, temp_flags);
		end
		
		// Random addci
		Opcode = 8'b0111xxxx;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			c_in = $unsigned($random) % 1'b1;
			Immediate = $unsigned($random) % 8'b11111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = {{8{Immediate[7]}}, Immediate[7:0]} + DST + c_in;
			if (temp_out == 0) temp_flags[4] = 1;
			if( (~Immediate[7] & ~DST[15] & temp_out[15]) | (Immediate[7] & DST[15] & ~temp_out[15]) ) temp_flags[2] = 1'b1;
			
			// Check the result
			test_instruction("Random ADDCI", temp_out, temp_flags);
		end
		
		// Random cmpi
		Opcode = 8'b1011xxxx;
		for( i = 0; i< 25000; i = i+ 1)
		begin
			Immediate = $unsigned($random) % 8'b11111111;
			DST = $unsigned($random) % 16'b1111111111111111;
			
			// Compute the expected output
			temp_flags = 5'b00000;
			temp_out = $signed({{8{Immediate[7]}}, Immediate[7:0]}) - $signed(DST);
			if	($signed({{8{Immediate[7]}}, Immediate[7:0]}) < $signed(DST)) temp_flags[0] = 1'b1;
			if ($unsigned({8'b00000000, Immediate[7:0]}) < $unsigned(DST)) temp_flags[1] = 1'b1;
			temp_flags[4] = $signed(Immediate) == $signed(DST);
			
			// Check the result
			test_instruction("Random CMPI", temp_out, temp_flags);
		end
		
		
		$display("***Random tests done!****");		
	end
	
	$finish(2);
	end  
endmodule