module VGA_Display(clock, clear, hSync, vSync, bright, hCount, vCount);

input clock;
input clear;

output reg hSync = 1'b0;
output reg vSync = 1'b0;
output reg bright = 1'b0;
output reg [9:0] hCount = 10'b0;
output reg [9:0] vCount = 10'b0;

localparam HS_STA = 16;              // horizontal sync start
localparam HS_END = 16 + 96;         // horizontal sync end
localparam HA_STA = 16 + 96 + 48;    // horizontal active pixel start
localparam VS_STA = 480 + 11;        // vertical sync start
localparam VS_END = 480 + 11 + 2;    // vertical sync end
localparam VA_END = 480;             // vertical active pixel end
localparam LINE   = 800;             // complete line (pixels)
localparam SCREEN = 524;             // complete screen (lines)

always@(posedge clock)
	begin
	if(clear)
		begin
		hCount <= 10'b0;
		vCount <= 10'b0;
		hSync  <= 1'b0;
		vSync	 <= 1'b0;
		bright <= 1'b0;
		end
	else
		begin 
		if (h_count == LINE)  // end of line
			begin
			h_count <= 0;
			v_count <= v_count + 1;
			end
		else 
			h_count <= h_count + 1;
		end
		
always@(posedge clock)
	begin
	if (v_count == SCREEN)  // end of screen
		v_count <= 0;
	end

endmodule 