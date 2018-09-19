module fib_fsm(clk, reset, seven_seg_out, seven_seg_out2, seven_seg_out3, seven_seg_out4);
	`include "instructionset.v"

	input clk, reset;
	
	output reg [6:0] seven_seg_out;
	output reg [6:0] seven_seg_out2;
	output reg [6:0] seven_seg_out3;
	output reg [6:0] seven_seg_out4;
	
	reg [15:0] display;
	
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
		.Reset(~reset),
		.Flags(Flags),
		.ALUBus(ALUBus)
	);
	
	// States for FSM
	localparam S0 = 5'd0, 	S1 = 5'd1, 	 S2 = 5'd2,   S3 = 5'd3, 	S4 = 5'd4, 	 S5 = 5'd5,   S6 = 5'd6, 	S7 = 5'd7, 
				  S8 = 5'd8, 	S9 = 5'd9, 	 S10 = 5'd10, S11 = 5'd11, S12 = 5'd12, S13 = 5'd13, S14 = 5'd14, S15 = 5'd15,
				  S16 = 5'd16, S17 = 5'd17, S18 = 5'd18, S19 = 5'd19, S20 = 5'd20, S21 = 5'd21, S22 = 5'd22, S23 = 5'd23,
				  S24 = 5'd24, S25 = 5'd25, S26 = 5'd26, S27 = 5'd27, S28 = 5'd28, S29 = 5'd29, S30 = 5'd30, S31 = 5'd31;
				  
	
	initial begin
		state = 5'b00000; // Initialize state to 0
	end
	
	// Increase the state by 1 each positive clock edge
	always@(posedge clk)
	begin
		if(~reset) 						state <= S0;
		else if(state != S31)		state <= state + 1'b1;
		else 								state <= state;
	end
	
	// Depending on the state, set the correct instruction
	always@(state)
	begin
		case (state)
			S0: Instruction = 16'b0; // Do nothing on the initial state
			S1: Instruction = {MOVI, REG0, 8'b000000000}; // Load 0 into REG0
			S2: Instruction = {MOVI, REG1, 8'b000000001}; // Load 1 into REG1
			S3: Instruction = {Register, REG2, ADD, REG0}; // Every two instructions computes the next register
			S4: Instruction = {Register, REG2, ADD, REG1};
			S5: Instruction = {Register, REG3, ADD, REG1}; 
			S6: Instruction = {Register, REG3, ADD, REG2}; 	
			S7: Instruction = {Register, REG4, ADD, REG2}; 
			S8: Instruction = {Register, REG4, ADD, REG3}; 
			S9: Instruction = {Register, REG5, ADD, REG3}; 
			S10: Instruction = {Register, REG5, ADD, REG4}; 
			S11: Instruction = {Register, REG6, ADD, REG4}; 
			S12: Instruction = {Register, REG6, ADD, REG5}; 
			S13: Instruction = {Register, REG7, ADD, REG5}; 
			S14: Instruction = {Register, REG7, ADD, REG6}; 
			S15: Instruction = {Register, REG8, ADD, REG6}; 
			S16: Instruction = {Register, REG8, ADD, REG7}; 
			S17: Instruction = {Register, REG9, ADD, REG7}; 
			S18: Instruction = {Register, REG9, ADD, REG8}; 
			S19: Instruction = {Register, REG10, ADD, REG8}; 
			S20: Instruction = {Register, REG10, ADD, REG9}; 
			S21: Instruction = {Register, REG11, ADD, REG9}; 
			S22: Instruction = {Register, REG11, ADD, REG10}; 
			S23: Instruction = {Register, REG12, ADD, REG10}; 
			S24: Instruction = {Register, REG12, ADD, REG11}; 
			S25: Instruction = {Register, REG13, ADD, REG11}; 
			S26: Instruction = {Register, REG13, ADD, REG12}; 
			S27: Instruction = {Register, REG14, ADD, REG12}; 
			S28: Instruction = {Register, REG14, ADD, REG13}; 
			S29: Instruction = {Register, REG15, ADD, REG13}; 
			S30: Instruction = {Register, REG15, ADD, REG14}; 
			S31: Instruction = {Register, REG15, MOV, REG15}; // Move REG15 to the output so it can be shown 
			default: Instruction = 16'b0;
			
			//$display("%0b + %0b = %0d", Instruction[11:8], Instruction[3:0], ALUBus);

		endcase
	end
	
	always@(state, reset)
	begin
		if(~reset || state != S31)
			display <= 16'b0;
		else 
			display <= ALUBus;
	end
	
	always @(state)
	begin
		case (display[3:0])
		4'b0000 :      	//Hexadecimal 0
		//seven_seg_out = 7'b0111111;
		seven_seg_out = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		//seven_seg_out = 7'b0000110  ;
		seven_seg_out = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		//seven_seg_out = 7'b1011011 ; 
		seven_seg_out = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		//seven_seg_out = 7'b1001111 ;
		seven_seg_out = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		//seven_seg_out = 7'b1100110 ;
		seven_seg_out = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		//seven_seg_out = 7'b1101101 ;  
		seven_seg_out = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		//seven_seg_out = 7'b1111101 ;
		seven_seg_out = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		//seven_seg_out = 7'b0000111;
		seven_seg_out = 7'b1111000;
		4'b1000 :     		 //Hexadecimal 8
		//seven_seg_out = 7'b1111111;
		seven_seg_out = 7'b0000000;
		4'b1001 :    		//Hexadecimal 9
		//seven_seg_out = 7'b1101111 ;
		seven_seg_out = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		//seven_seg_out = 7'b1110111 ; 
		seven_seg_out = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		//seven_seg_out = 7'b1111100;
		seven_seg_out = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		//seven_seg_out = 7'b0111001 ;
		seven_seg_out = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		//seven_seg_out = 7'b1011110 ;
		seven_seg_out = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		//seven_seg_out = 7'b1111001 ;
		seven_seg_out = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		//seven_seg_out = 7'b1110001 ;
		seven_seg_out = 7'b0001110 ;
		endcase
		case(display[7:4])
		4'b0000 :      	//Hexadecimal 0
		//seven_seg_out = 7'b0111111;
		seven_seg_out2 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		//seven_seg_out = 7'b0000110  ;
		seven_seg_out2 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		//seven_seg_out = 7'b1011011 ; 
		seven_seg_out2 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		//seven_seg_out = 7'b1001111 ;
		seven_seg_out2 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		//seven_seg_out = 7'b1100110 ;
		seven_seg_out2 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		//seven_seg_out = 7'b1101101 ;  
		seven_seg_out2 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		//seven_seg_out = 7'b1111101 ;
		seven_seg_out2 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		//seven_seg_out = 7'b0000111;
		seven_seg_out2 = 7'b1111000;
		4'b1000 :     		 //Hexadecimal 8
		//seven_seg_out = 7'b1111111;
		seven_seg_out2 = 7'b0000000;
		4'b1001 :    		//Hexadecimal 9
		//seven_seg_out = 7'b1101111 ;
		seven_seg_out2 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		//seven_seg_out = 7'b1110111 ; 
		seven_seg_out2 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		//seven_seg_out = 7'b1111100;
		seven_seg_out2 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		//seven_seg_out = 7'b0111001 ;
		seven_seg_out2 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		//seven_seg_out = 7'b1011110 ;
		seven_seg_out2 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		//seven_seg_out = 7'b1111001 ;
		seven_seg_out2 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		//seven_seg_out = 7'b1110001 ;
		seven_seg_out2 = 7'b0001110 ;
		endcase
		case(display[11:8])
		4'b0000 :      	//Hexadecimal 0
		//seven_seg_out = 7'b0111111;
		seven_seg_out3 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		//seven_seg_out = 7'b0000110  ;
		seven_seg_out3 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		//seven_seg_out = 7'b1011011 ; 
		seven_seg_out3 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		//seven_seg_out = 7'b1001111 ;
		seven_seg_out3 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		//seven_seg_out = 7'b1100110 ;
		seven_seg_out3 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		//seven_seg_out = 7'b1101101 ;  
		seven_seg_out3 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		//seven_seg_out = 7'b1111101 ;
		seven_seg_out3 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		//seven_seg_out = 7'b0000111;
		seven_seg_out3 = 7'b1111000;
		4'b1000 :     		 //Hexadecimal 8
		//seven_seg_out = 7'b1111111;
		seven_seg_out3 = 7'b0000000;
		4'b1001 :    		//Hexadecimal 9
		//seven_seg_out = 7'b1101111 ;
		seven_seg_out3 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		//seven_seg_out = 7'b1110111 ; 
		seven_seg_out3 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		//seven_seg_out = 7'b1111100;
		seven_seg_out3 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		//seven_seg_out = 7'b0111001 ;
		seven_seg_out3 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		//seven_seg_out = 7'b1011110 ;
		seven_seg_out3 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		//seven_seg_out = 7'b1111001 ;
		seven_seg_out3 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		//seven_seg_out = 7'b1110001 ;
		seven_seg_out3 = 7'b0001110 ;
		endcase
		case(display[15:12])
		4'b0000 :      	//Hexadecimal 0
		//seven_seg_out = 7'b0111111;
		seven_seg_out4 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		//seven_seg_out = 7'b0000110  ;
		seven_seg_out4 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		//seven_seg_out = 7'b1011011 ; 
		seven_seg_out4 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		//seven_seg_out = 7'b1001111 ;
		seven_seg_out4 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		//seven_seg_out = 7'b1100110 ;
		seven_seg_out4 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		//seven_seg_out = 7'b1101101 ;  
		seven_seg_out4 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		//seven_seg_out = 7'b1111101 ;
		seven_seg_out4 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		//seven_seg_out = 7'b0000111;
		seven_seg_out4 = 7'b1111000;
		4'b1000 :     		 //Hexadecimal 8
		//seven_seg_out = 7'b1111111;
		seven_seg_out4 = 7'b0000000;
		4'b1001 :    		//Hexadecimal 9
		//seven_seg_out = 7'b1101111 ;
		seven_seg_out4 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		//seven_seg_out = 7'b1110111 ; 
		seven_seg_out4 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		//seven_seg_out = 7'b1111100;
		seven_seg_out4 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		//seven_seg_out = 7'b0111001 ;
		seven_seg_out4 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		//seven_seg_out = 7'b1011110 ;
		seven_seg_out4 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		//seven_seg_out = 7'b1111001 ;
		seven_seg_out4 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		//seven_seg_out = 7'b1110001 ;
		seven_seg_out4 = 7'b0001110 ;
		endcase
	end
endmodule 