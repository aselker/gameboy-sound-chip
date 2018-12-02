module lenCounter(
	input clk,
	input [5:0] lenLoad,
	input trigger,
	input lenEnable,
	output chanEnable
);

	reg [5:0] len;
	initial len = 6'b0;

	// TODO: What if lenLoad = 1, trigger = high, lenEnable = high ?
	always @(posedge clk) begin
		if (lenEnable && (len != 0)) len--;
		if (trigger) len = 6'd63 - lenLoad;
	end

	assign chanEnable = len != 6'b0;

endmodule
