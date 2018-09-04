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
module ALU( SRC, DST, C, c_in,Opcode, Flags);
input [15:0] SRC, DST;
input [7:0] Opcode;
input c_in;

output reg [15:0] C;
output reg [4:0] Flags;
// Flag [4] = Z 
// Flag [3] = O
// Flag [2] = 
// Flag [1] = 
// Flag [0] = 

//Special group
parameter LOAD = 4'b0000;

//Register group
parameter AND  = 4'b0001;
parameter OR   = 4'b0010;
parameter XOR  = 4'b0011;
parameter ADD  = 4'b0101;
parameter ADDU = 4'b0110;
parameter ADDC = 4'b0111;
parameter SUB  = 4'b1001;
parameter CMP  = 4'b1011;

//Shift group
parameter LHS 	= 4'b0100;
parameter RHS	= 4'b1100;

//
parameter Register = 4'b0000;
parameter Shift = 	4'b1000;
parameter Special = 	4'b0100;

always @(SRC, DST, Opcode)
begin
	case (Opcode[7:4])
	Register:
		begin
		case(Opcode[3:0])
		AND:
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
		ADD:
			begin
			C = SRC + DST;
			if (C == 0) Flags[4] = 1'b1;
			else Flags[4] = 1'b0;
			if( (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]) ) Flags[2] = 1'b1;
			else Flags[2] = 1'b0;
			Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			end
		ADDU:
			begin
			{Flags[3], C} = SRC + DST;
			if (C == 0) Flags[4] = 1'b1; 
			else Flags[4] = 1'b0;
			Flags[2:0] = 3'b000;
			end
		SUB:
			begin
			C = SRC - DST;
			if (C == 0) Flags[4] = 1'b1;
			else Flags[4] = 1'b0;
			if( (~SRC[15] & ~DST[15] & C[15]) | (SRC[15] & DST[15] & ~C[15]) ) Flags[2] = 1'b1;
			else Flags[2] = 1'b0;
			Flags[1:0] = 2'b00; Flags[3] = 1'b0;
			end
		CMP:
			begin
			if( $signed(SRC) < $signed(DST) ) Flags[1:0] = 2'b11;
			else Flags[1:0] = 2'b00;
			C = 0;
			Flags[4:2] = 3'b000;
			end
		default:
			begin
			C = 0;
			Flags = 5'b0000;
			end
		endcase
	Shift:
		switch(Opcode[3:0])
		LHS:
			begin
			C = $signed(DST) << 1;
			Flags = 5'b00000;
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
			Flags = 5'b00000;
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
	Special:
		case(Opcode[3:0])
			LOAD:
			begin
				C = A;
				Flags = 5'b00000;
			end
		default:
			begin
				C=0;
				Flags = 5'b00000;
			end
		endcase
	default: 
		begin
			C = 0;
			Flags = 5'b00000;
		end
	endcase
end

endmodule
