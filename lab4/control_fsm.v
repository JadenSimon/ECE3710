`timescale 1ns / 1ps
module control_fsm(clk, mem_data, ld_mux, pc_mux, Opcode, RegEnable, FlagsEnable, PCEnable, we_a);
	`include "instructionset.v"
	input clk;
	input [15:0] mem_data;
	
	output reg ld_mux;
	output reg pc_mux;
	output reg [7:0] Opcode;
	output reg [15:0] RegEnable;
	output reg [4:0] FlagsEnable;
	output reg PCEnable;
	output reg we_a;
	output reg [3:0] mux_A, mux_B;
	
	reg fsm_state = 1'b0;
	
	always@(posedge clk)
	begin
		if (fsm_state == 1'b0)
		begin
			// Set the PC enables
			PCEnable = 1;
			
			// Set the write enable
			we_a = Instruction[7:4] == STOR;
			
			// Set the pc/ld mux
			pc_mux = Instruction[7:4] == LOAD;
			ld_mux = 0;
			
			// ALU DST/SRC Muxes
			mux_A = Instruction[11:8];
			mux_B = Instruction[3:0];

			// Decode the DST register for the RegFile. If the instruction is CMP or CMPI set all to 0.
			RegEnable = (Instruction[15:12] == CMPI || (Instruction[15:12] == Register && Instruction[7:4] == CMP)) ? 16'b0 : 1'b1 << Instruction[11:8];
			
			// Set the opcode
			Opcode = {Instruction[15:12], Instruction[7:4]};
	
			// Set the flags enable
			FlagsEnable = 5'b11111;
			
			fsm_state = Instruction[7:4] == LOAD;
		end
		else
		begin
			// Set the PC enables
			PCEnable = 0;
			
			// Set the write enable
			we_a = 0;
			
			// Set the pc/ld mux
			pc_mux = 0;
			ld_mux = 1;
			
			// ALU DST/SRC Muxes
			mux_A = 4'b0000;
			mux_B = 4'b0000;

			// Decode the DST register for the RegFile. If the instruction is CMP or CMPI set all to 0.
			RegEnable = (Instruction[15:12] == CMPI || (Instruction[15:12] == Register && Instruction[7:4] == CMP)) ? 16'b0 : 1'b1 << Instruction[11:8];
			
			// Set the opcode
			Opcode = {Instruction[15:12], Instruction[7:4]};
	
			// Set the flags enable
			FlagsEnable = 5'b11111;
			
			fsm_state = Instruction[7:4] == LOAD;
		end
	end

	

endmodule