module VGA_Bitgen(bright, hCount, vCount, clock, xLocation, yLocation, slowPulse, pixelData, rgb);

input bright;
input clock;
input slowPulse;
input [7:0] pixelData;
input [9:0] hCount;
input [9:0] vCount;
input [9:0] xLocation;
input [8:0] yLocation;

output reg [7:0] rgb;

parameter BLACK = 8’b000_000_00;
parameter WHITE = 8’b111_111_11;
parameter RED = 8’b111_000_00;
parameter GREEN = 8’b000_111_00;
parameter BLUE = 8’b000_000_00;

always@(*)
begin
	if(~bright)
		rgb = BLACK;
	else
	begin
		if()
		else if()
		else
			rgb = RED;
	end
end

endmodule 