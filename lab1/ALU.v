`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    08/30/2018 
// Design Name:    ALU
// Module Name:    ALU 
// Project Name:   Lab 1
//////////////////////////////////////////////////////////////////////////////////
module ALU( DST, SRC, Immediate, C, c_in, Opcode, Flags);
input [15:0] DST, SRC;
input [7:0] Immediate; // This should be taken from a 16-bit instruction, however, for now it is provided to the ALU as is.
input [7:0] Opcode;
input c_in;

output reg [15:0] C;
output reg [4:0] Flags;
// Flag [4] = Z (Zero)
// Flag [3] = C (Carry)
// Flag [2] = O (Overflow) Note: This flag may sometimes be called 'F' in some documents
// Flag [1] = L (Low) (Unsigned comparison)
// Flag [0] = N (Negative) (Signed comparison)

// Currently the ALU design can handle 3 groups of opcodes: Special, Register, and Shift
// Eventually, it may be better to have Special and Shift instructions handled outside of the ALU.
// Special instructions could be handled by the CPU control unit as they are relatively simple.
// There aren't many Shift instructions so they could just be handled by a shifter module.

// Immediate Instructions:
// A CPU controller can also handle immediate instructions pretty easily, no reason to add a bunch of 
// boiler plate code when there's a much more elegant solution. If you look at the chart of instructions
// and their corresponding opcodes, you'll notice that the high 4-bits of the opcode for immediate instructions
// are the exact same as the lower 4-bits of the non-immediate version. The control unit would simply route the
// higher 4-bits to the ALU and set a flag for a mux to take in the immediate value at SRC. Currently the ALU
// implements immediate instructions directly.

// Special group
parameter LOAD = 4'b0000;

// Register group
// Immediate versions of this group use the same 4 bits in the upper 4 bits of the opcode
parameter AND  = 4'b0001;
parameter OR   = 4'b0010;
parameter XOR  = 4'b0011;
parameter ADD  = 4'b0101;
parameter ADDU = 4'b0110;
parameter ADDC = 4'b0111;
parameter SUB  = 4'b1001;
parameter CMP  = 4'b1011;
parameter MOV  = 4'b1101;

// Shift group
parameter LSH 	= 4'b0100;
parameter LSHI = 3'b000;

// Upper 4 bits of the opcode define groups
parameter Register = 4'b0000;
parameter Shift = 	4'b1000;
parameter Special = 	4'b0100;

// Immediate instructions located outside any group
parameter ANDI  = 4'b0001;
parameter ORI   = 4'b0010;
parameter XORI  = 4'b0011;
parameter ADDI  = 4'b0101;
parameter ADDUI = 4'b0110;
parameter ADDCI = 4'b0111;
parameter SUBI  = 4'b1001;
parameter CMPI  = 4'b1011;
parameter MOVI  = 4'b1101;

// Always block for combinational logic
always @(SRC, DST, Immediate, Opcode, c_in)
begin
	// Always reset the flags at the start
	Flags[3:0] = 4'b0000;

	case (Opcode[7:4]) // First case statement is for the upper 4-bits
	Register:
		begin
		case(Opcode[3:0]) // Check the lower 4-bits in the Register group
		// Logical operations are simple, just do the operation
		AND: 	C = DST & SRC;
		OR: 	C = DST | SRC;
		XOR:	C = DST ^ SRC;
		ADD: // Signed addition
			begin
				C = DST + SRC;
				Flags[2] = (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]); // Check for signed overflow here
			end
		ADDU: {Flags[3], C} = DST + SRC; // Set the carry flag
		ADDC: // Signed addition with a carry in
			begin
				C = DST + SRC + c_in; // Same as ADD but use c_in
				Flags[2] = (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]); // Check for signed overflow here
			end
		SUB: // Signed subtraction, could add unsigned subtraction later, though it doesn't make much sense
			begin
				C = DST - SRC;
				Flags[2] = (SRC[15] & ~DST[15] & C[15]) | (~SRC[15] & DST[15] & ~C[15]); // Subtraction overflow
			end
		CMP: // Comparison (does DST < SRC)
			begin
				{Flags[1], C} = DST - SRC;
				Flags[0] = Flags[1] ^ (DST[15] ^ SRC[15]);
			end
		MOV: C = SRC; // Just moves SRC to the output
		 
		default: C = DST;
		endcase
		end
	Shift: // Shift group, may be moved into a separate module eventually
		begin
		case(Opcode[3:0])
		LSH: // Currently only does 1 bit logical shifts to the left
			begin
				C = DST << 1;
			end
		{LSHI, 1'b0}: C = Immediate[3:0] << 1; // Left shift immediate by 1 
		{LSHI, 1'b1}: C = Immediate[3:0] >> 1; // Right shift immediate by 1
		
		default: C = DST;
		endcase
		end
	Special:
		begin
		case(Opcode[3:0])
			LOAD: C = SRC; // Basically just MOV, may change later
			
		default: C = DST;
		endcase
		end
	// Start the immediate case handling
	ANDI: C = DST & Immediate;
	ORI:	C = DST | Immediate;
	XORI: C = DST ^ Immediate;
	ADDI: // Signed addition with immediate
		begin
			C = DST + {{8{Immediate[7]}}, Immediate[7:0]}; // Sign extend the immediate and add to DST
			Flags[2] = (~Immediate[7] & ~DST[15] & C[15]) | (Immediate[7] & DST[15] & ~C[15]); // Check for signed overflow here
		end
	ADDUI: {Flags[3], C} = DST + Immediate; // Set the carry flag, no need to sign extend
	ADDCI: // Signed addition with a carry in
		begin
			C = DST + {{8{Immediate[7]}}, Immediate[7:0]} + c_in; // Same as ADD but use c_in
			Flags[2] = (~Immediate[7] & ~DST[15] & C[15]) | (Immediate[7] & DST[15] & ~C[15]); // Check for signed overflow here
		end
	SUBI: // Signed subtraction, could add unsigned subtraction later, though it doesn't make much sense
		begin
			C = DST - {{8{Immediate[7]}}, Immediate[7:0]};
			Flags[2] = (Immediate[7] & ~DST[15] & C[15]) | (~Immediate[7] & DST[15] & ~C[15]);
		end
	CMPI: // Comparison with immediate (does DST < Imm)
		begin
			{Flags[1], C} = DST - {{8{Immediate[7]}}, Immediate[7:0]};
			Flags[0] = Flags[1] ^ (DST[15] ^ Immediate[7]);
			{Flags[1], C} = DST - {8'b0, Immediate[7:0]};
		end
	MOVI: C = Immediate; // Moves immediate directly to output
	
	default: C = DST;
	endcase
			
	// Always set the zero flag if C == 0
	Flags[4] = C == 0;
end

endmodule