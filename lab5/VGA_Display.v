module VGA_Display(clock, clear, hSync, vSync, bright, hCount, vCount);

input clock;
input clear;

reg enable = 1'b0;
reg slowclock = 1'b0;

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

//HANDLES h_count
always@(posedge clock)
begin
	if(clear)
	begin
		hCount <= 10'b0;
		hSync  <= 1'b0;
	end
	else if(enable)
	begin 
		if (h_count == LINE) // end of line
		begin
			h_count <= 0;
			hSync <= ~(h_count >= HS_STA && h_count <= HS_END);
		end
		else	// keeps on down the line
		begin
			h_count <= h_count + 1;
			hSync <= ~(h_count >= HS_STA && h_count <= HS_END);
		end
	end
	else
	begin
		h_count <= h_count;
		hSync <= ~(h_count >= HS_STA && h_count <= HS_END);
	end
end

//Handles v_count
always@(posedge clock)
begin
	if(clear)
	begin
		v_count <= 0;
		vSync <= 0;
	end
	else
		if(enable)
		begin
			if(v_count == SCREEN) //At bottom of screen
			begin
				v_count <= 10'b0;
				vSync <= ~(v_count >= VS_STA && v_count <= VS_END);
			end
			else if(h_count == LINE) //New line
			begin
				v_count <= v_count + 1;
				vSync <= ~(v_count >= VS_STA && v_count <= VS_END);
			end
			else //No new line
			begin
				v_count <= v_count;
				vSync <= ~(v_count >= VS_STA && v_count <= VS_END);
			end

		end
		else
		begin
			v_count <= v_count;
			vSync <= ~(v_count >= VS_STA && v_count <= VS_END);
		end
end

//Sets bright signal when h_count is in the range and v_count is in range
always@(posedge clock)
begin
	bright <= (h_count >= HA_STA && v_count <= VA_END);
end

always@(posedge clock)
begin
	if(slowclock)
	begin
		enable = 1'b1;
		slowclock = ~slowclock;
	end
	else
	begin
		enable = 1'b0;
		slowclock = ~slowclock;
	end
end

endmodule 