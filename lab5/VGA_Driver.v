module VGA_Driver(clock, clear, swc, btn, slowPulse, xLocation, yLocation);

input clock;
input clear;
input [7:0] swc;
input [3:0] button;

output reg slowPulse = 1'b0;
output reg [9:0] xLocation = 10'b0; 
output reg [9:0] yLocation = 10'b0;

endmodule