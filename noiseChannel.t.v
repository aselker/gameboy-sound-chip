`include "swDac.v"
`include "noiseChannel.v"

module testNoiseChannel();
	
	wire clk; baseClk baseclk(clk); // Generate 4mhz signal
	wire clk256; fixedTimer #(16384) tmr256(clk, clk256);
	wire clk64; fixedTimer #(4) tmr64(clk256, clk64);

	wire [3:0] left, right;
	swDac dac(left, right);


	reg trigger;
	wire [3:0] noise;
	noiseChannel noisechannel(clk, clk256, clk64, 6'd63, 4'd7, 1'd0, 3'd3, 4'd0, 1'd0, 3'd0, trigger, 1'd0, noise);

	assign left = noise;
	assign right = noise;

	initial begin
		trigger = 0; #100; trigger = 1; #10; trigger = 0;

		#4194304 $finish;
	end

endmodule
