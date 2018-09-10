`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    09/05/2018 
// Design Name:    ALUDemo
// Module Name:    ALUDemo 
// Project Name:   Lab 1
//////////////////////////////////////////////////////////////////////////////////

// Implemented Instructions:
// Register:
// AND ANDI
// OR ORI
// XOR XORI
// ADD ADDI
// ADDU ADDUI
// ADDC ADDCI
// SUB SUBI
// CMP CMPI
// MOV MOVI

// Shift:
// LHS
// LHSI

// Special:
// LOAD // Needs register file to actually work

// Note that immediates, ADDC, and LOAD are not being demo'd

// We still need to implement some of the shift instructions like arithmetic shifts instead of only logical
// Perhaps shifting by a certain amount instead of only by 1 as well.


// Demos the ALU using 4-bit values
// Because we want to show how flags are set, we use the 4-bit inputs as the higher 4 bits into the ALU
// For example, an input of 0011 on the FPGA would actually be 0011 0000 0000 0000 into the ALU.
module ALUDemo(A, B, C, Carry, Opcode, Flags);

input [3:0] A, B;
input [4:0] Opcode;
input Carry;

reg [15:0] DST, SRC;
reg [7:0] decoded_opcode;
wire [15:0] Immediate, OUT;

output [3:0] C;
output [4:0] Flags;

assign Immediate = 16'b0000000000000000;

ALU alu(DST, SRC, Immediate, OUT, Carry, decoded_opcode, Flags); 

// Connect the upper 4 bits of OUT to C
assign C = OUT[15:12];

always @(A, B, Carry, Opcode)
begin
	// Shift A, B by 12 bits
	DST = {A, 12'b000000000000};
	SRC = {B, 12'b000000000000};
	
	// The opcode from the ALU will be only be 5 bits
	// For some reason buttons are low when pressed?
	decoded_opcode = {4'b0000, ~Opcode[3:0]};
	decoded_opcode[7] = Opcode[4]; // Allows access to shift instructions
end

endmodule
