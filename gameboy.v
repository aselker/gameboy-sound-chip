`include "pulseChannel1.v"
`include "noiseChannel.v"
`include "mixer.v"

`define PERIOD 4194304/16
`define LENGTH 10'd1023
`define PLAYBACK_LENGTH 10'd60
`define LONGREG reg [`LENGTH:0]

module gameboy();

	reg [31:0] [3:0] waveTable;

	// Square 1
	`LONGREG [2:0] sq1_swpPd;
	`LONGREG sq1_negate;
	`LONGREG [2:0] sq1_shift;
	`LONGREG [1:0] sq1_duty;
	`LONGREG [5:0] sq1_lenLoad;
	`LONGREG [3:0] sq1_startVol;
	`LONGREG sq1_envAdd;
	`LONGREG [2:0] sq1_period;
	`LONGREG [10:0] sq1_freq;
	`LONGREG sq1_trigger;
	`LONGREG sq1_lenEnable;

	// Square 2
	`LONGREG [1:0] sq2_duty;
	`LONGREG [5:0] sq2_lenLoad;
	`LONGREG [3:0] sq2_startVol;
	`LONGREG sq2_envAdd;
	`LONGREG [2:0] sq2_period;
	`LONGREG [10:0] sq2_freq;
	`LONGREG sq2_trigger;
	`LONGREG sq2_lenEnable;

	// Noise
	`LONGREG [5:0] n_lenLoad;
	`LONGREG [3:0] n_startVol;
	`LONGREG n_envAdd;
	`LONGREG [2:0] n_period;
	`LONGREG [3:0] n_clkShift;  
	`LONGREG n_widthMode;
	`LONGREG [2:0] n_divisor;
	`LONGREG n_trigger;
	`LONGREG n_lenEnable;

	`LONGREG [1:0] w_vol;
	`LONGREG [5:0] w_lenLoad;
	`LONGREG w_trigger;
	`LONGREG w_lenEnable;
	`LONGREG [10:0] w_freq;

	wire clk; baseClk baseclk(clk);
	wire clk256; fixedTimer #(16384) tmr256(clk, clk256);
	wire clk128; fixedTimer #(2) tmr128(clk256, clk128);
	wire clk64; fixedTimer #(2) tmr64(clk128, clk64);

	wire clkT; fixedTimer #(`PERIOD) tmrT(clk, clkT);
	reg [$clog2(`LENGTH)-1:0] t;
	always @(posedge clkT) begin
		if (t < `PLAYBACK_LENGTH) t += 1;
		else $finish;
	end

	wire [3:0] sq1_out, sq2_out, n_out;

	pulseChannel1 pc1(clk, clk256, clk128, clk64, sq1_swpPd[t], sq1_negate[t], sq1_shift[t], sq1_freq[t], sq1_lenLoad[t], sq1_duty[t], sq1_startVol[t], sq1_period[t], sq1_lenEnable[t], sq1_trigger[t], sq1_envAdd[t], sq1_out);
	pulseChannel2 pc2(clk, clk256, clk128, clk64, sq2_freq[t], sq2_lenLoad[t], sq2_duty[t], sq2_startVol[t], sq2_period[t], sq2_lenEnable[t], sq2_trigger[t], sq2_envAdd[t], sq2_out);
	noiseChannel n(clk, clk256, clk64, n_lenLoad[t], n_startVol[t], n_envAdd[t], n_period[t], n_clkShift[t],  n_widthMode[t], n_divisor[t], n_trigger[t], n_lenEnable[t], n_out);


	// Clock at falling edge so that nothing else is going on at the same time
	// swDac dac(!clk, sq1_out, sq2_out);
	mixer mxr(clk, 4'b1101, 4'b1101, 3'b111, 3'b111, sq1_out, sq2_out, 4'd0, n_out);

	reg [4:0] ii; // Fill in the wave table with a triangle wave

	initial begin
		t = 0;

		for (ii = 0; ii < 16; ii++) waveTable[ii] = {ii[3:0]};
		for (ii = 0; ii < 16; ii++) waveTable[ii+5'd16] = 4'd0 - {ii[3:0]};

		// PYTHON GO HERE
	
	end

endmodule
