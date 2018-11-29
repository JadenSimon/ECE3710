`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Superfriends team
// Engineer: Jaden, Dan, Kyle, Melvin
// 
// Create Date:    10/17/2018
// Design Name:    simple_test
// Module Name:    simple_test
// Project Name:   Lab 4
//////////////////////////////////////////////////////////////////////////////////

// Tests the CPU datapath
// Uses the memory loaded into program.txt
module simple_test();

	// Create clock and reset
	reg clk, reset;
	wire [15:0] d_out;
	wire snes1_in, snes2_in;
	wire snes1_latch, snes2_latch;
	wire [15:0] snes_data1, snes_data2;
	reg [2:0] slow_clk_counter = 3'b0;
   reg slow_clk = 1'b0;
	
	// generate 5 Mhz clock
	always@(posedge clk)
	begin
		slow_clk_counter <= slow_clk_counter + 1'b1;
		if (slow_clk_counter == 3'b100)
		begin
			slow_clk <= !slow_clk;
			slow_clk_counter <= 3'b0;
		end
	end
	
	// Create the CPU
	cpu_datapath CPU(clk, reset, snes_data1, snes_data2, d_out);	
	// Create the SNES controller modules
	SNES_Controller controller1(slow_clk, snes1_in, snes1_latch, snes_data1);
	SNES_Controller controller2(slow_clk, snes2_in, snes2_latch, snes_data2);
		
		
	reg [15:0] test_reg1, test_reg2, shift_reg1, shift_reg2;
	always@(posedge slow_clk)
	begin
		if (snes1_latch)
			shift_reg1 <= test_reg1;
		else
			shift_reg1 <= shift_reg1 << 1;
	
		if (snes2_latch)
			shift_reg2 <= test_reg2;
		else
			shift_reg2 <= shift_reg2 << 1;
	end
	
	assign snes1_in = shift_reg1[15];
	assign snes2_in = shift_reg2[15];
	
	// Do some stuff
	initial begin
		test_reg1 = 16'b1010;
		test_reg2 = 16'b0010;
	
		clk = 0;
		reset = 1;
		#40
		reset = 0;
			
		#20000
		
		reset = 1;
		#40
		reset = 0;
		
		#20000
		
		$finish;
	end
	
	initial begin
		forever #10 clk = ~clk;
	end
	
endmodule
