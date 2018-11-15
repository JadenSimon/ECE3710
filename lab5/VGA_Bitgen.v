module VGA_Bitgen(bright, hCount, vCount, clock, xLocation, yLocation, slowPulse, pixelData, rgb);

input bright;
input clock;
input slowPulse;
input [7:0] pixelData;
input [9:0] hCount;
input [9:0] vCount;
input [9:0] xLocation;
input [9:0] yLocation;

output reg [7:0] rgb;

endmodule 