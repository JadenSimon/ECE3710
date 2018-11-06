`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    11/05/2018
// Design Name:    cpu_demo
// Module Name:    cpu_demo
// Project Name:   Lab 4
//////////////////////////////////////////////////////////////////////////////////

// Loads a test program onto the FPGA
// 
module cpu_demo(clk, reset, seven_seg_out1, seven_seg_out2, seven_seg_out3, seven_seg_out4);
	input clk, reset;
	
	output wire [6:0] seven_seg_out1, seven_seg_out2, seven_seg_out3, seven_seg_out4;
	
	wire [15:0] data_out;
	reg [6:0] seven_seg [3:0]; // Used to convert data_out > display
	
	reg [1:0] clk_counter = 1'b0;
	reg slw_clk = 1'b0;
	
	// Make a slower clock
	always@(posedge clk)
	begin
		if (clk_counter == 2'b11)
			slw_clk = ~slw_clk;
			
		clk_counter = clk_counter + 2'b01;
	end
	
	// Create the CPU
	cpu_datapath CPU(slw_clk, reset, data_out);
	
	// Display on the FPGA
	genvar i;
	
	generate
	for(i=0; i<=3; i=i+1)
	begin:display_seg
		always@(*)
		begin
			if (reset == 1'b1)
				seven_seg[i] <= 7'b1000000;
			else
			begin
				case (data_out[(i*4+3):(i*4)])
				4'b0000 :      //Hexadecimal 0
				seven_seg[i] <= 7'b1000000;
				4'b0001 :    	//Hexadecimal 1
				seven_seg[i] <= 7'b1111001  ;
				4'b0010 :  		// Hexadecimal 2
				seven_seg[i] <= 7'b0100100 ; 
				4'b0011 : 		// Hexadecimal 3
				seven_seg[i] <= 7'b0110000 ;
				4'b0100 :		// Hexadecimal 4
				seven_seg[i] <= 7'b0011001 ;
				4'b0101 :		// Hexadecimal 5
				seven_seg[i] <= 7'b0010010 ;  
				4'b0110 :		// Hexadecimal 6
				seven_seg[i] <= 7'b0000010 ;
				4'b0111 :		// Hexadecimal 7
				seven_seg[i] <= 7'b1111000;
				4'b1000 :     	 //Hexadecimal 8
				seven_seg[i] <= 7'b0000000;
				4'b1001 :    	//Hexadecimal 9
				seven_seg[i] <= 7'b0010000 ;
				4'b1010 :  		// Hexadecimal A
				seven_seg[i] <= 7'b0001000 ; 
				4'b1011 : 		// Hexadecimal B
				seven_seg[i] <= 7'b0000011;
				4'b1100 :		// Hexadecimal C
				seven_seg[i] <= 7'b1000110 ;
				4'b1101 :		// Hexadecimal D
				seven_seg[i] <= 7'b0100001 ;
				4'b1110 :		// Hexadecimal E
				seven_seg[i] <= 7'b0000110 ;
				4'b1111 :		// Hexadecimal F
				seven_seg[i] <= 7'b0001110 ;
				endcase
			end
		end
	end
	endgenerate
	
	// Set the correct outputs
	assign seven_seg_out1 = seven_seg[0];
	assign seven_seg_out2 = seven_seg[1];
	assign seven_seg_out3 = seven_seg[2];
	assign seven_seg_out4 = seven_seg[3];
	
endmodule
