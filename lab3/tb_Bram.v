`timescale 1ns / 1ps

module db_memory;

reg [15:0] data_a, data_b = 16'b0;
reg [8:0] addr_a, addr_b = 9'b0;
reg we_a, we_b, clk = 1'b 0;
wire [15:0] q_a, q_b;

Bram memory(data_a, data_b, addr_a, addr_b, we_a, we_b, clk, q_a, q_b);

initial begin
we_a = 1'b1; clk = 1; #10;
$monitor("%b", q_a);
end

endmodule
