`include "swDac.v"
`include "noiseChannel.v"

module testNoiseChannel();
	
	wire clk; baseClk baseclk(clk); // Generate 4mhz signal

	wire [3:0] left, right;
	swDac dac(left, right);

	wire lenClk; fixedTimer #(16384) lenTimer(clk, lenClk);

	reg trigger;
	wire noise;
	noiseChannel noisechannel(clk, lenClk, 6'd63, 4'd0, 1'd0, 3'd0, 4'd0, 1'd0, 3'd0, trigger, 1'd0, noise);

	assign left = noise ? 4'd15 : 4'd0;
	assign right = left;

	initial begin
		trigger = 0; #10; trigger = 1;

		#4194304 $finish;
	end

endmodule
