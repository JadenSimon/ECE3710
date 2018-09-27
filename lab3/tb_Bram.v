`timescale 1ns / 1ps

// Test module, performs some operations on the block ram then outputs a value to the 7 seg display.
module tb_Bram(clk, reset, seven_seg_out1, seven_seg_out2, seven_seg_out3, seven_seg_out4);
	input clk, reset;
	
	output reg [6:0] seven_seg_out1;
	output reg [6:0] seven_seg_out2;
	output reg [6:0] seven_seg_out3;
	output reg [6:0] seven_seg_out4;

	reg [15:0] data_a = 0;
	reg [15:0] data_b = 0;
	reg [15:0] addr_a = 0;
	reg [15:0] addr_b = 0;
	reg we_a = 0;
	reg we_b = 0;
	wire [15:0] q_a, q_b;
	
	reg [1:0] state = 0; // State for the FSM, need 4 states
	reg [15:0] display = 0; // Store the display value

	Bram memory(data_a, data_b, addr_a, addr_b, we_a, we_b, clk, q_a, q_b);
	
	// Increase the state on every clock positve edge, stopping at the final state
	always@(posedge clk)
	begin
		if (!reset) 
		begin
			state <= 2'b0;
			display <= 16'b0;
		end
		else 
		begin
			state <= (state != 2'b11) ? state + 1'b1 : 2'b11;
			display <= q_a + q_b; // Set the display to the sum of both read ports.
		end
	end
	
	// Modify which address we read/write to on every state
	always@(negedge clk)
	begin
		if (!reset) // If reset, read from address 510 on both ports (outputs 0)
		begin
			addr_a = 16'b0000000111111110;
			addr_b = 16'b0000000111111110;
			data_a = 16'b0000000000000000;
			data_b = 16'b0000000000000000;
			we_a = 0; we_b = 0;
		end
		else
		begin
			case(state)
				2'b00 : // Write to address 0, read from address 2 
					begin
						addr_a = 16'b0000000000000000;
						addr_b = 16'b0000000000000010;
						data_a = 16'b0000000000000000;
						data_b = 16'b0000000000000000;
						we_a = 1; we_b = 0;
					end
				2'b01 : // Write to address 0 using address 2, read from address 513
					begin
						addr_a = 16'b0000000000000000;
						addr_b = 16'b0000001000000001;
						data_a = q_b;
						data_b = 16'b0000000000000000;
						we_a = 1; we_b = 0;
					end
				2'b10 : // Try to write to address 513 using both ports (port a overrides port b)
					begin
						addr_a = 16'b0000001000000001;
						addr_b = 16'b0000001000000001;
						data_a = q_b + 1;
						data_b = q_b;
						we_a = 1; we_b = 1;
					end
				2'b11 : // Read address 0 and address 513
					begin
						addr_a = 16'b0000000000000000;
						addr_b = 16'b0000001000000001;
						data_a = 16'b0000000000000000;
						data_b = 16'b0000000000000000;
						we_a = 0; we_b = 0;
					end			
			endcase	
		end
	end
	
	// Updates the seven seg display output
	always @(*)
	begin
		case (display[3:0])
		4'b0000 :      //Hexadecimal 0
		seven_seg_out1 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		seven_seg_out1 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		seven_seg_out1 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		seven_seg_out1 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		seven_seg_out1 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		seven_seg_out1 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		seven_seg_out1 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		seven_seg_out1 = 7'b1111000;
		4'b1000 :     	 //Hexadecimal 8
		seven_seg_out1 = 7'b0000000;
		4'b1001 :    	//Hexadecimal 9
		seven_seg_out1 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		seven_seg_out1 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		seven_seg_out1 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		seven_seg_out1 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		seven_seg_out1 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		seven_seg_out1 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		seven_seg_out1 = 7'b0001110 ;
		endcase
		case(display[7:4])
		4'b0000 :     	//Hexadecimal 0
		seven_seg_out2 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		seven_seg_out2 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		seven_seg_out2 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		seven_seg_out2 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		seven_seg_out2 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		seven_seg_out2 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		seven_seg_out2 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		seven_seg_out2 = 7'b1111000;
		4'b1000 :     	 //Hexadecimal 8
		seven_seg_out2 = 7'b0000000;
		4'b1001 :    	//Hexadecimal 9
		seven_seg_out2 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		seven_seg_out2 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		seven_seg_out2 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		seven_seg_out2 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		seven_seg_out2 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		seven_seg_out2 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		seven_seg_out2 = 7'b0001110 ;
		endcase
		case(display[11:8])
		4'b0000 :      //Hexadecimal 0
		seven_seg_out3 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		seven_seg_out3 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		seven_seg_out3 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		seven_seg_out3 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		seven_seg_out3 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		seven_seg_out3 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		seven_seg_out3 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		seven_seg_out3 = 7'b1111000;
		4'b1000 :     	//Hexadecimal 8
		seven_seg_out3 = 7'b0000000;
		4'b1001 :    	//Hexadecimal 9
		seven_seg_out3 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		seven_seg_out3 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		seven_seg_out3 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		seven_seg_out3 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		seven_seg_out3 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		seven_seg_out3 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		seven_seg_out3 = 7'b0001110 ;
		endcase
		case(display[15:12])
		4'b0000 :      	//Hexadecimal 0
		seven_seg_out4 = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
		seven_seg_out4 = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
		seven_seg_out4 = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
		seven_seg_out4 = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
		seven_seg_out4 = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
		seven_seg_out4 = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
		seven_seg_out4 = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
		seven_seg_out4 = 7'b1111000;
		4'b1000 :     		 //Hexadecimal 8
		seven_seg_out4 = 7'b0000000;
		4'b1001 :    		//Hexadecimal 9
		seven_seg_out4 = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
		seven_seg_out4 = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
		seven_seg_out4 = 7'b0000011;
		4'b1100 :		// Hexadecimal C
		seven_seg_out4 = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
		seven_seg_out4 = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
		seven_seg_out4 = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
		seven_seg_out4 = 7'b0001110 ;
		endcase
	end
	
endmodule
