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
module ALU( DST, SRC, C, c_in,Opcode, Flags);
input [15:0] DST, SRC;
input [7:0] Opcode;
input c_in;

output reg [15:0] C;
output reg [4:0] Flags;
// Flag [4] = Z (Zero)
// Flag [3] = C (Carry)
// Flag [2] = O (Overflow) Note: This flag may sometimes be called 'F' in some documents
// Flag [1] = L (Low)
// Flag [0] = N (Negative)

// Currently the ALU design can handle 3 groups of opcodes: Special, Register, and Shift
// Eventually, it may be better to have Special and Shift instructions handled outside of the ALU.
// Special instructions could be handled by the CPU control unit as they are relatively simple.
// There aren't many Shift instructions so they could just be handled by a shifter module.

// Immediate Instructions:
// A CPU controller can also handle immediate instructions pretty easily, no reason to add a bunch of 
// boiler plate code when there's a much more elegant solution. If you look at the chart of instructions
// and their corresponding opcodes, you'll notice that the high 4-bits of the opcode for immediate instructions
// are the exact same as the lower 4-bits of the non-immediate version. The control unit would simply route the
// higher 4-bits to the ALU and set a flag for a mux to take in the immediate value at SRC.


// Special group
parameter LOAD = 4'b0000;

// Register group
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
parameter LHS 	= 4'b0100;
parameter RHS	= 4'b1100;

// Upper 4 bits of the opcode define groups
parameter Register = 4'b0000;
parameter Shift = 	4'b1000;
parameter Special = 	4'b0100;

// Always block for combinational logic
always @(SRC, DST, Opcode, c_in)
begin
	case (Opcode[7:4]) // First case statement is for the upper 4-bits
	Register:
		begin
		case(Opcode[3:0]) // Check the lower 4-bits in the Register group
		AND: // Logical operations are simple; only need to check for Z flag
			begin
			C = SRC & DST;
			Flags[3:0] = 4'b0000;
			Flags[4] = C == 0;
			end
		OR:
			begin
			C = SRC | DST;
			Flags[3:0] = 4'b0000;
			Flags[4] = C == 0;		
			end
		XOR:
			begin
			C = SRC ^ DST;
			Flags[3:0] = 4'b0000;
			Flags[4] = C == 0;
			end
		ADD: // Signed addition
			begin
			C = SRC + DST;
			if (C == 0) Flags[4] = 1'b1;
			else Flags[4] = 1'b0;
			if( (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]) ) Flags[2] = 1'b1; // Check for signed overflow here
			else Flags[2] = 1'b0;
			Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			end
		ADDU:
			begin
			{Flags[3], C} = SRC + DST; // Set the carry flag
			if (C == 0) Flags[4] = 1'b1; 
			else Flags[4] = 1'b0;
			Flags[2:0] = 3'b000;
			end
		ADDC: // Signed addition with a carry in
			begin
			C = SRC + DST + c_in; // Same as ADD but use c_in
			if (C == 0) Flags[4] = 1'b1;
			else Flags[4] = 1'b0;
			if( (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]) ) Flags[2] = 1'b1; // Check for signed overflow here
			else Flags[2] = 1'b0;
			Flags[2:0] = 2'b00; Flags[3] = 1'b0;
			end
		SUB: // Signed subtraction, could add unsigned subtraction later, though it doesn't make much sense
			begin
			C = SRC - DST;
			if (C == 0) Flags[4] = 1'b1;
			else Flags[4] = 1'b0;
			if( (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]) ) Flags[2] = 1'b1;
			else Flags[2] = 1'b0;
			Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			end
		CMP: // Signed comparison
			begin
			if( $signed(SRC) > $signed(DST) ) Flags[1:0] = 2'b11;
			else Flags[1:0] = 2'b00;
			C = 0;
			Flags[4:2] = 3'b000;
			end
		MOV: // Sets all flags to 0 and C = SRC
			begin
				C = SRC;
				Flags[4:0] = 5'b00000;
			end
		default:
			begin
			C = 0;
			Flags = 5'b0000;
			end
		endcase
		end
	Shift: // Shift group, may be moved into a separate module eventually
		begin
		case(Opcode[3:0])
		LHS: // Currently only does 1 bit signed shifts
			begin
			C = $signed(DST) << 1;
			if (C == 0) Flags[4:0] = {1'b1, 4'b0000};
			else Flags[4:0] = 5'b0;
			end
		/*LHSI:
			begin
			C = $signed(DST) << 1;
			Flags = 5'b00000;
			end
		LHSIS:
			begin
			C = $signed(DST) << 1;
			Flags = 5'b00000;
			end*/
		RHS:
			begin
			C = $signed(DST) >> 1;
			if (C == 0) Flags[4:0] = {1'b1, 4'b0000};
			else Flags[4:0] = 5'b0;
			end
		/*RHSI:
			begin
			C = $signed(DST) >> 1;
			Flags = 5'b00000;
			end
		RHSIS:
			begin
			C = $signed(DST) >> 1;
			Flags = 5'b00000;
			end*/
		default:
			begin
				C=0;
				Flags = 5'b00000;
			end
		endcase
		end
	Special:
		begin
		case(Opcode[3:0])
			LOAD:
			begin
				C = SRC;
				Flags = 5'b00000;
			end
		default:
			begin
				C=0;
				Flags = 5'b00000;
			end
		endcase
		end
	default: 
		begin
			C = 0;
			Flags = 5'b00000;
		end
	endcase
end

endmodule