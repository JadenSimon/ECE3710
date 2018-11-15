module VGA_Display(clock, clear, hSync, vSync, bright, hCount, vCount);

input clock;
input clear;

output reg hSync = 1'b0;
output reg vSync = 1'b0;
output reg bright = 1'b0;
output reg [9:0] hCount = 10'b0;
output reg [9:0] vCount = 10'b0;

/*
	STATE 0: Reset State
	STATE 1:
	STATE 2:
	STATE 3:
 */
reg [1:0] state = 2'b0;

always@(posedge clock)
begin
	if(clear)
	begin
		hSync = 1'b0;
		vSync = 1'b0;
		bright = 1'b0;
		hCount = 10'b0;
		vCount = 10'b0;		
	end
	else
	begin
	end
end

always@(state)
begin
end

endmodule 