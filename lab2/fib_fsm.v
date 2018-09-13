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
				state = S1;
				end
			S1:
				begin
				state = S2;
				end
			S2:
				begin
				state = S3;
				end
			S3:
				begin
				state = S4;
				end
			S4:
				begin
				state = S5;
				end
			S5:
				begin
				state = S6;
				end
			S6:
				begin
				state = S7;
				end
			S7:
				begin
				state = S8;
				end
			S8:
				begin
				state = S9;
				end
			S9:
				begin
				state = S10;
				end
			S10:
				begin
				state = S11;
				end
			S11:
				begin
				state = S12;
				end
			S12:
				begin
				state = S13;
				end
			S13:
				begin
				state = S14;
				end
			S14:
				begin
				state = S15;
				end
			S15:
				begin
				state = S15;
				end
			default:
				state = 4'bxxxx;
			endcase
	end
	
endmodule 