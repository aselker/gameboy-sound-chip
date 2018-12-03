`include "swDac.v"
`include "noiseChannel.v"

module testNoiseChannel();
	
	wire clk; baseClk baseclk(clk); // Generate 4mhz signal

	wire [3:0] left, right;
	swDac dac(left, right);

	wire lenClk; fixedTimer #(16384) lenTimer(clk, lenClk);

	wire noise;
	noiseChannel noisechannel(clk, lenClk, 6'd63, 4'd0, 1'd0, 3'd0, 4'd0, 1'd0, 3'd0, 1'd1, 1'd0, noise);

	assign left = noise ? 4'd15 : 4'd0;
	assign right = left;

	initial #1000 $finish;

endmodule
