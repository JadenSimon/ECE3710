`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    09/05/2018 
// Design Name:    ALUWrapper
// Module Name:    ALUWrapper 
// Project Name:   Lab 1
//////////////////////////////////////////////////////////////////////////////////

module ALUWrapper(DST, SRC, Immediate, C, c_in, Opcode, Flags);
input [15:0] DST, SRC;
input [15:0] Immediate;
input [7:0] Opcode;
input c_in;

reg [7:0] decoded_opcode;
reg [15:0] decoded_src;

output [15:0] C;
output [4:0] Flags;

ALU alu(DST, SRC, C, c_in, decoded_opcode, Flags);

// If the high 4-bits of the opcode aren't apart of a group
// then just feed the ALU {4'b0000, Opcode[7:4]}

always @(SRC, DST, Opcode, c_in)
begin
	if (Opcode[7:4] != 4'b0000 &&
		 Opcode[7:4] != 4'b0100 &&
		 Opcode[7:4] != 4'b1000 &&
		 Opcode[7:4] != 4'b1100)
	begin
		decoded_opcode = {4'b0000, Opcode[7:4]};
		decoded_src = Immediate;
	end
	else // Otherwise pass the opcode directly
	begin
		decoded_opcode = Opcode;
		decoded_src = SRC;
	end
end

endmodule
