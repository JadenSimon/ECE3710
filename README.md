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

The lab5 directory was used as the final working directory for the complete project. To rebuild the project, all dependencies must be included and all data files and instructionset.v must be located in the directory. TankGame.v should be the top level module. Also, an assembled machine code file, called "machine_code.txt" should be placed there as well. Dependencies include:
  ALU.v
  BRAM.v
  Regfile.v
  flags.v
  cpu_atapath.v
  control_fsm.v
  SNES_Controller.v
  BackgroundController.v
  FontController.v
  VGADisplay.v
  VGAController.v
  HardwareSprite.v
