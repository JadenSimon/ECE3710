module VGA_Display(clock, clear, hSync, vSync, hCount, vCount, bright);

input clock;
input clear;

reg [1:0] hState = 2'b0;
reg [1:0] vState = 2'b0;

// Assigns the sync wires, they're low in the sync state
output wire hSync, vSync;
assign hSync = hState != 2'b00;
assign vSync = vState != 2'b00;

// Assign the bright wire, it is active when both states are in the active state (10)
output wire bright;
assign bright = (hState == 2'b10) && (vState == 2'b10);

output reg [9:0] hCount = 10'b0;
output reg [9:0] vCount = 10'b0;

localparam HSYNC = 95;					 // Horizontal sync time
localparam HBACK = 47;					 // Horizontal backporch
localparam HFRONT = 15;					 // Horizontal frontporch
localparam VSYNC = 1;					 // Vertical sync time
localparam VBACK = 32; 					 // Vertical backporch
localparam VFRONT = 9;					 // Vertical frontporch
localparam LINE   = 639;             // complete line (pixels)
localparam SCREEN = 479;             // complete screen (lines)

// True when a new line is starting to draw
wire horizontalStart;
assign horizontalStart = (hState == 2'b01) && (hCount == (HSYNC + HBACK));


//Handles hCount
always@(posedge clock)
begin
	if (clear)
	begin
		hCount <= 10'b0;
		hState <= 2'b00;
	end
	else
	begin 
		hCount <= hCount + 1'b1;
	
		case (hState)
			2'b00 : hState <= hCount == HSYNC ? 2'b01 : 2'b00; 									// Horizontal sync pulse state
			2'b01 : hState <= hCount == (HSYNC + HBACK) ? 2'b10 : 2'b01;   					// Horizontal back porch state
			2'b10 : hState <= hCount == (HSYNC + HBACK + LINE) ? 2'b11 : 2'b10;  			// Horizontal active state
			2'b11 : hState <= hCount == (HSYNC + HBACK + LINE + HFRONT) ? 2'b00 : 2'b11;  // Horizontal front porch state
		endcase
			
		if (hCount == HSYNC + HBACK + LINE + HFRONT)
			hCount <= 10'b0;
	end
end

//Handles vCount
always@(posedge clock)
begin
	if (clear)
	begin
		vCount <= 10'b0;
		vState <= 2'b00;
	end
	else if (horizontalStart)
	begin 
		vCount <= vCount + 1'b1;
	
		case (vState)
			2'b00 : vState <= vCount == VSYNC ? 2'b01 : 2'b00; 									  // Vertical sync pulse state
			2'b01 : vState <= vCount == (VSYNC + VBACK) ? 2'b10 : 2'b01;   					  // Vertical back porch state
			2'b10 : vState <= vCount == (VSYNC + VBACK + SCREEN) ? 2'b11 : 2'b10;  		  	  // Vertical active state
			2'b11 : vState <= vCount == (VSYNC + VBACK + SCREEN + VFRONT) ? 2'b00 : 2'b11;  // Vertical front porch state
		endcase
			
		if (vCount == VSYNC + VBACK + SCREEN + VFRONT)
			vCount <= 10'b0;
	end
	else
	begin
		vCount <= vCount;
		vState <= vState;
	end
end

endmodule
