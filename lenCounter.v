module lenCounter(
	input clk, // TODO: maybe generate 256hz internally from 4mhz?
	input [5:0] lenLoad,
	input trigger,
	input lenEnable,
	output reg chanEnable
);

	reg [5:0] len;
	initial len = 6'b0;
	initial chanEnable = 0;

	// TODO: What if lenLoad = 1, trigger = high, lenEnable = high ?
	always @(posedge clk) if (lenEnable && (len != 0) && !trigger) begin
		len--;
		chanEnable = len != 6'b0;
	end

	always @(posedge trigger) begin
		len = 6'd63 - lenLoad; // TODO: verify this math -- off-by-one?
		chanEnable = 1;
	end

endmodule
