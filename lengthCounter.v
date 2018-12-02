module lengthCounter(
	input clk,
	input [5:0] lengthLoad,
	input trigger,
	input lengthEnable,
	output chanEnable
);

	reg [5:0] length;
	initial length = 6'b0;

	// TODO: What if lengthLoad = 1, trigger = high, lengthEnable = high ?
	always @(posedge clk) begin
		if (lengthEnable && (length != 0)) length--;
		if (trigger) length = 6'd63 - lengthLoad;
	end

	assign chanEnable = length != 6'b0;

endmodule
