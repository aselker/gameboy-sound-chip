module baseClk (
	output reg clk
);
	initial begin
		clk = 0;
		forever #1 clk <= !clk;
	end
endmodule

module fixedTimer #(parameter period = 2) (
	input clk,
	output clkOut
);

	reg [$clog2(period):0] i;
	initial i = 1;
	always @(posedge clk) i <= i-1;
	always @(negedge clk) i <= i == 0 ? period : i;
	assign clkOut = (i == 0);

endmodule

module varTimer #(parameter width = 1) (
	input clk,
	input [width-1:0] period,
	output clkOut
);

	reg [width-1:0] i;
	initial i = 1;
	always @(posedge clk) i <= i-1;
	always @(negedge clk) i <= i == 0 ? period : i;
	assign clkOut = (i == 0);

endmodule
