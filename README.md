TANKS: a top-down game controlled with 2 SNES controllers on an Altera/Intel Cyclone V FPGA where players fight to the death as an armored, rolling patriot of  the USSR or the USA! 

The components for a 16-bit CPU, a VGA controller, and a plethora of testbenches were designed in verilog. The game logic is written in assembly code that follows the instruction set defined in "instructionset.v". "game.sof" is the final sof file that was used to live demo the game on the Cyclone V. As the name would suggest, FINAL_PINS.csv has the pinout that was used. 


The following briefly defines the contents of the project folders:

lab1: ALU, ALU testbenches

lab2: reg file, reg file testbenches

lab3: Bram module, Bram testbenches

lab4: CPU control FSM, testbenches

Assembler: the assembler, different variations of the assembly code for the tank game

SNES: SNES module, SNES module testbenches

images: png files and their corresponding .data (raw rgb data) files for the tank game glyphs

lab5: tank game files (VGA files, top-level tank game file, game assembly code, .data glyph files, VGA testbench, font/background controllers)
