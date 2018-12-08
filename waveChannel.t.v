`include "waveChannel.v"
`include "swDac.v"

module testWaveChannel();

	wire clk; baseClk baseclk(clk); // Generate 4mhz signal
	wire clk256; fixedTimer #(16384) tmr256(clk, clk256);

	reg trigger;
	reg [1:0] vol;
	reg [10:0] freq;
	reg [31:0] [3:0] samples;
	wire [3:0] signal;

	waveChannel dut(clk, clk256, 1'd1, vol, 6'd31, trigger, 1'd0, freq, samples, signal);
	swDac dac(signal, signal);

	initial begin
		reg [5:0] ii;
		for (ii = 0; ii < 32; ii++) samples[ii] = ii;
		vol = 2'b01;
		freq = 11'd2000;

		
		trigger = 0; #10; trigger = 1; #10; trigger = 0;

		#10000;

		$finish;

	end
endmodule
