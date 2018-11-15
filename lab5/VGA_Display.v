module VGA_Display(clock, clear, hSync, vSync, bright, hCount, vCount);

input clock;
input clear;

output reg hSync = 1'b0;
output reg vSync = 1'b0;
output reg bright = 1'b0;
output reg [9:0] hCount = 10'b0;
output reg [9:0] vCount = 10'b0;


endmodule 