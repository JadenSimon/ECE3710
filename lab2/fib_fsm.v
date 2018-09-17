module fib_fsm(clk, reset, display);

	input clk, reset;
	
	output reg [6:0] display;
	
	reg Instruction[15:0];

	reg state[3:0];
	// Outputs
	wire [15:0] ALUBus;
	wire [4:0] Flags;
	
	// Counter variable
	integer i;
	
	// Instantiate our Decoder
	Decoder test(
		.Instruction(Instruction),
		.Clock(Clock),
		.Reset(Reset),
		.Flags(Flags),
		.ALUBus(ALUBus)
	);
	
	// States for FSM
	localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, 
		S8 = 4'd8, S9 = 4'd9, S10 = 4'd10, S11 = 4'd11, S12 = 4'd12, S13 = 4'd13, S14 = 4'd14, S15 = 4'd15;
	
	//Register values for SRC and DST
	localparam A[3:0], B[3:0], ADDER[3:0];
	
	initial begin
	
	A = 4'b0000;
	B = 4'b0000;
	ADDER = 4'b0101;
	
	always@(posedge clk)
	begin
		if(reset)
		begin
			state = S0;
		end
		else
			case(state)
			S0:
				begin
				state <= S1;
				end
			S1:
				begin
				state <= S2;
				end
			S2:
				begin
				state <= S3;
				end
			S3:
				begin
				state <= S4;
				end
			S4:
				begin
				state <= S5;
				end
			S5:
				begin
				state <= S6;
				end
			S6:
				begin
				state <= S7;
				end
			S7:
				begin
				state <= S8;
				end
			S8:
				begin
				state <= S9;
				end
			S9:
				begin
				state <= S10;
				end
			S10:
				begin
				state <= S11;
				end
			S11:
				begin
				state <= S12;
				end
			S12:
				begin
				state <= S13;
				end
			S13:
				begin
				state <= S14;
				end
			S14:
				begin
				state <= S15;
				end
			S15:
				begin
				state <= S15;
				end
			default:
				state = 4'bxxxx;
			endcase
	end
	
	always@(state)
	begin
		if(reset)
		begin
			A = 4'b0000;
			B = 4'b0000;
			Instruction = 16'bxxxxxxxxxxxxxxxx;
		end
		case:
			S0:
				begin
					//Uses MOVI to store 1 into register 0
					Instruction = {4'b1101, A, 4'b0001, 4'b0000};
					A = A;
					B = B + 4'b0001;
				end
			S1:
				begin
					//Uses ADDI to store 1 + register 0 into register 1
					Instruction = {ADDER, A, 4'b0001, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S2:
				begin
					//ADD reg 1 and reg 2, stores in reg 2
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S3:
				begin
					//ADD reg 2 and reg 3, stores in reg 3
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S4:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S5:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S6:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S7:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S8:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S9:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end
			S10:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end			
			S11:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end			
			S12:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end			
			S13:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end			
			S14:
				begin
					Instruction = {4'b0000, A, ADDER, B};
					A = A + 4'b0001;
					B = B + 4'b0001;
				end			
			S15:
				begin
					//Loads reg 14 into reg 15. Ready to display
					Instruction = {4'b0100, A, 4'b0000, B};
					A = A;
					B = B;				
				end
	end
		
endmodule 