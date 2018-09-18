module fib_fsm(clk, reset, display);
	`include "instructionset.v"

	input clk, reset;
	
	output reg [6:0] display;
	
	reg [15:0] Instruction;
	reg [4:0] state;
	
	// Outputs
	wire [15:0] ALUBus;
	wire [4:0] Flags;
	
	// Counter variable
	integer i;
	
	// Instantiate our Decoder
	Decoder test(
		.Instruction(Instruction),
		.Clock(clk),
		.Reset(reset),
		.Flags(Flags),
		.ALUBus(ALUBus)
	);
	
	// States for FSM
	localparam S0 = 5'd0, S1 = 5'd1, S2 = 5'd2, S3 = 5'd3, S4 = 5'd4, S5 = 5'd5, S6 = 5'd6, S7 = 5'd7, 
				  S8 = 5'd8, S9 = 5'd9, S10 = 5'd10, S11 = 5'd11, S12 = 5'd12, S13 = 5'd13, S14 = 5'd14, S15 = 5'd15,
				  S16 = 5'd16, S17 = 5'd17, S18 = 5'd18, S19 = 5'd19, S20 = 5'd20, S21 = 5'd21, S22 = 5'd22, S23 = 5'd23,
				  S24 = 5'd24, S25 = 5'd25, S26 = 5'd26, S27 = 5'd27, S28 = 5'd28, S29 = 5'd29, S30 = 5'd30;
				  
			
	// Increase the state by 1 each positive clock edge
	always@(posedge clk)
	begin
		if(reset || state == S29) 	state <= S0;
		else								state <= state + 1'b1;
	end
	
	// Depending on the state, set the correct instruction
	always@(state, reset)
	begin
		if (reset) Instruction <= 16'b0;
		else begin
			case (state)
				S0: Instruction <= {MOVI, REG0, 8'b000000000}; // Load 0 into REG0
				S1: Instruction <= {MOVI, REG1, 8'b000000001}; // Load 1 into REG1
				S2: Instruction <= {Register, REG2, ADD, REG0}; // Every two instructions computes the next register
				S3: Instruction <= {Register, REG2, ADD, REG1};
				S4: Instruction <= {Register, REG3, ADD, REG1}; 
				S5: Instruction <= {Register, REG3, ADD, REG2}; 	
				S6: Instruction <= {Register, REG4, ADD, REG2}; 
				S7: Instruction <= {Register, REG4, ADD, REG3}; 
				S8: Instruction <= {Register, REG5, ADD, REG3}; 
				S9: Instruction <= {Register, REG5, ADD, REG4}; 
				S10: Instruction <= {Register, REG6, ADD, REG4}; 
				S11: Instruction <= {Register, REG6, ADD, REG5}; 
				S12: Instruction <= {Register, REG7, ADD, REG5}; 
				S13: Instruction <= {Register, REG7, ADD, REG6}; 
				S14: Instruction <= {Register, REG8, ADD, REG6}; 
				S15: Instruction <= {Register, REG8, ADD, REG7}; 
				S16: Instruction <= {Register, REG9, ADD, REG7}; 
				S17: Instruction <= {Register, REG9, ADD, REG8}; 
				S18: Instruction <= {Register, REG10, ADD, REG8}; 
				S19: Instruction <= {Register, REG10, ADD, REG9}; 
				S20: Instruction <= {Register, REG11, ADD, REG9}; 
				S21: Instruction <= {Register, REG11, ADD, REG10}; 
				S22: Instruction <= {Register, REG12, ADD, REG10}; 
				S23: Instruction <= {Register, REG12, ADD, REG11}; 
				S24: Instruction <= {Register, REG13, ADD, REG11}; 
				S25: Instruction <= {Register, REG13, ADD, REG12}; 
				S26: Instruction <= {Register, REG14, ADD, REG12}; 
				S27: Instruction <= {Register, REG14, ADD, REG13}; 
				S28: Instruction <= {Register, REG15, ADD, REG13}; 
				S29: Instruction <= {Register, REG15, ADD, REG14}; 
				S30: Instruction <= {Register, REG15, MOV, REG15}; // Move REG15 to the output so it can be shown 
				default: Instruction <= 16'b0;
			endcase
		end
	end
		
endmodule 